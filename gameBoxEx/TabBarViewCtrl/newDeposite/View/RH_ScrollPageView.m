//
//  RH_ScrollPageView.m
//  gameBoxEx
//
//  Created by jun on 2018/9/14.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ScrollPageView.h"
@interface RH_ScrollPageView ()
@property (strong, nonatomic) RH_SegmentStyle *segmentStyle;
@property (weak, nonatomic) RH_ScrollSegmentView *segmentView;
@property (weak, nonatomic) RH_ContentView *contentView;

@property (weak, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) NSArray *titlesArray;

@end
@implementation RH_ScrollPageView
#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(RH_SegmentStyle *)segmentStyle childVcs:(NSArray *)childVcs Titles:(NSArray *)titles parentViewController:(UIViewController *)parentViewController {
    
    if (self = [super initWithFrame:frame]) {
        self.childVcs = childVcs;
        self.segmentStyle = segmentStyle;
        self.parentViewController = parentViewController;
        [self commonInitTitles:titles];
    }
    return self;
}

- (void)commonInitTitles:(NSArray *)titles {
    
//    NSMutableArray *tempTitles = [NSMutableArray array];
//    for (UIViewController *childVc in self.childVcs) {
//        NSAssert(childVc.title, @"子控制器的title没有正确设置!!");
//        if (childVc.title) {
//            [tempTitles addObject:childVc.title];
//        }
//    }
    
    self.titlesArray = [NSArray arrayWithArray:titles];
    
    // 触发懒加载
    self.segmentView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    NSLog(@"RH_ScrollPageView--销毁");
}

#pragma mark - public helper

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self.segmentView setSelectedIndex:selectedIndex animated:animated];
}

/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadChildVcsWithNewChildVcs:(NSArray *)newChildVcs {
    
    self.childVcs = nil;
    self.titlesArray = nil;
    self.childVcs = newChildVcs;
    
    NSMutableArray *tempTitles = [NSMutableArray array];
    for (UIViewController *childVc in self.childVcs) {
        NSAssert(childVc.title, @"子控制器的title没有正确设置!!");
        if (childVc.title) {
            [tempTitles addObject:childVc.title];
        }
    }
    self.titlesArray = [NSArray arrayWithArray:tempTitles];
    
    [self.segmentView reloadTitlesWithNewTitles:self.titlesArray];
    [self.contentView reloadAllViewsWithNewChildVcs:self.childVcs];
}


#pragma mark - getter ---- setter

- (RH_ContentView *)contentView {
    if (!_contentView) {
        RH_ContentView *content = [[RH_ContentView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.segmentView.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.segmentView.frame)) childVcs:self.childVcs segmentView:self.segmentView parentViewController:self.parentViewController];
        [self addSubview:content];
        _contentView = content;
    }
    
    return  _contentView;
}


- (RH_ScrollSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        RH_ScrollSegmentView *segment = [[RH_ScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.segmentStyle.segmentHeight) segmentStyle:self.segmentStyle titles:self.titlesArray titleDidClick:^(UILabel *label, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:NO];
            
        }];
        [self addSubview:segment];
        _segmentView = segment;
    }
    return _segmentView;
}


- (NSArray *)childVcs {
    if (!_childVcs) {
        _childVcs = [NSArray array];
    }
    return _childVcs;
}

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSArray array];
    }
    return _titlesArray;
}

- (void)setExtraBtnOnClick:(ExtraBtnOnClick)extraBtnOnClick {
    _extraBtnOnClick = extraBtnOnClick;
    self.segmentView.extraBtnOnClick = extraBtnOnClick;
}

@end
