//
//  CLHeaderTitleView.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/21.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLBorderView.h"

@interface CLHeaderTitleView : CLBorderView
@property(nonatomic,strong,readonly) UILabel *labTitle ;
@property(nonatomic,strong) UIFont *titleFont ;
@property(nonatomic,strong) UIColor *titleColor ;
@property(nonatomic,assign) CGFloat leftEdgeInset ;
@end
