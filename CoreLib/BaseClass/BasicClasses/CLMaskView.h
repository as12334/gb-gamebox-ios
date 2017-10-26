//
//  CLMaskView.h
//  CoreLib
//
//  Created by apple pro on 2016/11/24.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------

@class CLMaskView;

//----------------------------------------------------------

@protocol CLMaskViewDataSource

@optional

//返回用于蒙版的layer，优先级高于下面的路径
- (CALayer *)maskLayerForMaskView:(CLMaskView *)maskView;
//返回用于蒙版的路径
- (UIBezierPath *)maskPathForMaskView:(CLMaskView *)maskView;

@end

//----------------------------------------------------------

typedef CALayer * (^GetMaskLayerBlock)(CLMaskView * maskView);
typedef UIBezierPath * (^GetMaskPathBlock)(CLMaskView * maskView);

//----------------------------------------------------------

@interface CLMaskView : UIView

//是否重新加载蒙版当视图大小改变时，默认为YES
@property(nonatomic) BOOL reloadMaskWhenSizeChange;

@property(nonatomic,weak) id<CLMaskViewDataSource> dataSource;

//获取的block，如果无数据源或者数据源没实现则调用下面两个block获取
@property(nonatomic,copy) GetMaskLayerBlock maskLayerBlock;
@property(nonatomic,copy) GetMaskPathBlock  maskPathBlock;

//重新加载
- (void)reloadMask;

@end

//----------------------------------------------------------

@interface UIView (CLMaskView)

@property(nonatomic,strong,readonly) CLMaskView * myMaskView;

@end
