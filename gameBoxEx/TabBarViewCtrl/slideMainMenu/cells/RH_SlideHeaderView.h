//
//  RH_SlideHeaderView.h
//  gameBoxEx
//
//  Created by luis on 2017/12/20.
//  Copyright © 2017年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_SlideHeaderView ;
@protocol SlideHeaderViewProtocol
@optional
-(void)slideHeaderViewTouchUserCenter:(RH_SlideHeaderView*)slideHeaderView ;
@end

@interface RH_SlideHeaderView : UIView
@property (nonatomic,weak) id<SlideHeaderViewProtocol> delegate ;
@end
