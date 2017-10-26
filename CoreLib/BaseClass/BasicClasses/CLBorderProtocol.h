//
//  CLBorderProtocol.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

//----------------------------------------------------------

#import <UIKit/UIKit.h>
#import "CLLineLayer.h"

//----------------------------------------------------------

//边界掩码
typedef NS_OPTIONS(NSUInteger,CLBorderMask) {
    CLBorderMarkNone   = 0,
    CLBorderMarkTop    = 1,
    CLBorderMarkBottom = 1 << 1,
    CLBorderMarkLeft   = 1 << 2,
    CLBorderMarkRight  = 1 << 3,
    CLBorderMarkAll    = ~0UL
};

//----------------------------------------------------------

@protocol CLBorderProtocol

@property(nonatomic) CLLineStyle borderStyle;

//默认为MyBorderNone
@property(nonatomic) CLBorderMask borderMask;

@property(nonatomic) CGFloat  borderWidth;
@property(nonatomic,strong) UIColor * borderColor;

@property(nonatomic) UIEdgeInsets borderInset;
@property(nonatomic) UIEdgeInsets borderLineInset;
@property(nonatomic) UIEdgeInsets borderLineScaleInset;

@end

