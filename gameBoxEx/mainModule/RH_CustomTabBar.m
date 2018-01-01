//
//  RH_CustomTabBar.m
//  gameBoxEx
//
//  Created by luis on 2017/11/14.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_CustomTabBar.h"
#import "coreLib.h"

@interface RH_CustomTabBar ()

@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) CALayer *midBackLayer;
@end

@implementation RH_CustomTabBar

// 重新布局tabBarItem（这里需要具体情况具体分析，本例是中间有个按钮，两边平均分配按钮）
- (void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    [super layoutSubviews];
    // 把tabBarButton取出来（把tabBar的SubViews打印出来就明白了）
    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonArray addObject:view];
        }
    }
    
    [tabBarButtonArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIView *view1 = obj1 ;
        UIView *view2 = obj2 ;
        
        NSComparisonResult result = NSOrderedSame ;
        if (view1.frameX > view2.frameX){
            result = NSOrderedDescending ;
        }else{
            result = NSOrderedAscending ;
        }
        
        return result ;
    }] ;
    
    if (tabBarButtonArray.count==0) return ;
    
    if (!((tabBarButtonArray.count -1)%2)){//说明奇数，有中间数
        NSInteger midIndex = (tabBarButtonArray.count -1)/2 ;
        UIView *midView = [tabBarButtonArray objectAtIndex:midIndex] ;
        CGRect frame = midView.frame ;
        frame = CGRectMake(frame.origin.x, frame.origin.y-self.midMoveUP,
                           frame.size.width,
                           frame.size.height + self.midMoveUP) ;
//        frame.origin.y = -self.midMoveUP ;
        midView.frame = frame ;
        
        //给底部Tabbar添加背景；
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _midBackLayer = [CALayer new];
            _midBackLayer.frame = CGRectMake(CGRectGetMinX(frame) - 30 + frame.size.width/2, CGRectGetMinY(frame), 60, 50);
            _midBackLayer.backgroundColor = RH_TabBar_BackgroundColor.CGColor ;
            _midBackLayer.cornerRadius = 30;
            [midView.superview.layer insertSublayer:_midBackLayer below:midView.layer];
        });
    }
}


- (void)setViewBackgroundColor:(UIColor *)color {
    _midBackLayer.backgroundColor = [color CGColor];
}
#pragma mark - UIViewGeometry
// 重写hitTest方法，让超出tabBar部分也能响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.clipsToBounds || self.hidden || (self.alpha == 0.f)) {
        return nil;
    }
    UIView *result = [super hitTest:point withEvent:event];
    // 如果事件发生在tabbar里面直接返回
    if (result) {
        return result;
    }
    // 这里遍历那些超出的部分就可以了，不过这么写比较通用。
    for (UIView *subview in self.subviews) {
        // 把这个坐标从tabbar的坐标系转为subview的坐标系
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        // 如果事件发生在subView里就返回
        if (result) {
            return result;
        }
    }
    return nil;
}

-(void)setMidMoveUP:(CGFloat)midMoveUP
{
    if (_midMoveUP!=midMoveUP){
        _midMoveUP = midMoveUP ;
        [self setNeedsLayout] ;
    }
}


@end
