//
//  CLIndicateView.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLActivityIndicatorView.h"
#import "help.h"

//----------------------------------------------------------

typedef NS_ENUM(int, CLIndicateViewStyle){
    CLIndicateViewStyleNoneView,
    CLIndicateViewStyleActivityView,
    CLIndicateViewStyleImageView,
    CLIndicateViewStyleCustomView

};

//----------------------------------------------------------


@interface CLIndicateView : UIView

@property(nonatomic) CLIndicateViewStyle style;


//--------layout----------


//缩进的比例
@property(nonatomic) UIEdgeInsets marginScale;
//缩进的值
@property(nonatomic) UIEdgeInsets marginValue;

//偏移值
@property(nonatomic) CGPoint contentOffset;

//内容布局方式
@property(nonatomic) CLContentLayout contentLayout;

//default is 10.f
@property(nonatomic) float   topMargin;
//default is 5.f
@property(nonatomic) float   bottomMargin;


//--------content----------

@property(nonatomic,strong,readonly) CLActivityIndicatorView * activityIndicatorView;

@property(nonatomic,strong) UIImage  * image;

@property(nonatomic,strong) UIView   * customView;

@property (copy) NSString *titleLabelText;

@property (copy) NSString *detailLabelText;

//--------UI----------

@property(nonatomic,strong) UIFont* titleLabelFont;

@property(nonatomic,strong) UIColor* titleLabelColor;

@property(nonatomic,strong) UIFont* detailLabelFont;

@property(nonatomic,strong) UIColor* detailLabelColor;

@property (assign) float progress;

//-------------------

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
