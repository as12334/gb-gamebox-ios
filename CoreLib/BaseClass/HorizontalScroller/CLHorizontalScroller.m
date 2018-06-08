//
//  HorizontalScroller.m
//  AlbumLibrary
//
//  Created by LamTsanFeng on 14-8-16.
//  Copyright (c) 2014年 LamTsanFeng. All rights reserved.
//

#import "CLHorizontalScroller.h"

#define VIEW_PADDING 5
#define VIEW_DIMENSIONS 70
#define VIEWS_OFFSET 70

@interface CLHorizontalScroller ()

@property (nonatomic, assign) int currentIndex;
@end

@implementation CLHorizontalScroller
{
    //3  创建了UIScrollerView的实例
    UIScrollView *scroller;   //水平滚动视图
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.showsVerticalScrollIndicator = NO;
        scroller.showsHorizontalScrollIndicator = NO;
        scroller.delegate = self;
        
        [self addSubview:scroller];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}

// didMoveToSuperview方法会在视图被增加到另外一个视图作为子视图的时候调用，这正式重新加载滚动视图的最佳时机。
- (void)didMoveToSuperview
{
    // 当数据已经发生改变的时候，你要执行reload方法。当增加HorizontalScroller到另外一个视图的时候，你也需要调用reload方法。
    [self reload];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// 加载滚动视图
- (void)reload
{
    // 1 - 如果没有委托，那么不需要做任何事情，仅仅返回即可。
    if (self.delegate == nil) return;
    
    // 2 - 移除之前添加到滚动视图的子视图
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        [obj removeFromSuperview];
        
    }];
    
    // 3 - 所有的视图的位置从给定的偏移量开始。当前的偏移量是100，它可以通过改变文件头部的#DEFINE来很容易的调整。
    CGFloat xValue = VIEWS_OFFSET;
    
    for (int i=0; i<[self.delegate numberOfViewsForHorizontalScroller:self]; i++)
        
    {
        
        // 4 - 右边增加一个视图，对应增加x值  HorizontalScroller每次从委托请求视图对象，并且根据预先设置的边框来水平的放置这些视图。
        
        xValue += VIEW_PADDING;
        
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        
        view.frame = CGRectMake(xValue, (self.bounds.size.height-view.bounds.size.height)/2.0, view.bounds.size.width, view.bounds.size.height);
        
        [scroller addSubview:view];
        
        xValue += VIEW_DIMENSIONS+VIEW_PADDING;
        
    }
    
    // 5 设置UIScrollView的可滚动区域  一旦所有视图都设置好了以后，设置UIScrollerView的内容偏移（contentOffset）以便用户可以滚动的查看所有的专辑封面。
    
    [scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
    
    // 6 - HorizontalScroller检测是否委托实现了initialViewIndexForHorizontalScroller:方法，这个检测是需要的，因为这个方法是可选的。如果委托没有实现这个方法，0就是缺省值。最后设置滚动视图为协议规定的初始化视图的中间。
    
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)])
        
    {
        
        NSInteger initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        UIView *view = scroller.subviews[initialView];
        [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];

//        [scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
        
    }
}

- (void)scrollerTapped:(UITapGestureRecognizer*)gesture
{
    // Gesture对象被当做参数传递，让你通过locationInView：导出点击的位置。
    CGPoint location = [gesture locationInView:gesture.view];
    
    // 我们在这里不能使用枚举器，因为我们不想枚举所有的UIScrollView子视图。
    
    // 我们想只枚举子视图
    
    // 调用numberOfViewsForHorizontalScroller:委托方法，HorizontalScroller实例除了知道它可以安全的发送这个消息给委托之外，它不知道其它关于委托的信息，因为委托必须遵循HorizontalScrollerDelegate协议。
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++)
        
    {
        UIView *view = scroller.subviews[index];
        
        // 对于滚动视图中的每个子视图，通过CGRectContainsPoint方法发现被点击的视图。当你已经找到了被点击的视图，给委托发送horizontalScroller:clickedViewAtIndex:消息。在退出循环之前，将被点击的视图放置到滚动视图的中间。
        if (CGRectContainsPoint(view.frame, location))
        {
            if (self.currentIndex != index) {
                self.currentIndex = index;
                CGAffineTransform viewsOriginalTransform = view.transform;
                view.transform = CGAffineTransformScale(viewsOriginalTransform, 1.2, 1.2);
                view.alpha = 1.0;
            }

            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
        }
        else
        {
            view.transform = CGAffineTransformIdentity;
            view.alpha = 0.8;
        }
    }
}


// 确保所有你正在浏览的专辑数据总是在滚动视图的中间，为了计算当前视图到中间的距离，考虑了滚动视图当前的偏移量，视图的尺寸以及边框。最后一行代码是重要的，当子视图被置中，你将需要将这种变化通知委托。
- (void)centerCurrentView

{
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    
    int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    
    xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++)
        
    {
        UIView *view = scroller.subviews[index];
        
        if (index == viewIndex)
        {
            if (self.currentIndex != index) {
                self.currentIndex = index;
                CGAffineTransform viewsOriginalTransform = view.transform;
                view.transform = CGAffineTransformScale(viewsOriginalTransform, 1.2, 1.2);
                view.alpha = 1.0;
            }
        }
        else
        {
            view.transform = CGAffineTransformIdentity;
            view.alpha = 0.8;
        }
    }

    UIView *view = scroller.subviews[viewIndex];

    [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
    
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}

#pragma mark - UIScrollView Delegate
// 检测用户在滚动视图中的滚动
// 在用户完成拖动的时候通知委托。如果视图还没有完全的停止，那么decelerate参数为true.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self centerCurrentView];
    }
}

// 当滚动完全停止的时候，系统将会调用scrollViewDidEndDecelerating.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}

@end
