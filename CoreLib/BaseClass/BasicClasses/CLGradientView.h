//
//  CLGradientView.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLGradientView : UIView
@property(nonatomic,strong) NSArray * colors;
@property(nonatomic,strong) NSArray * locations;

@property(nonatomic) CGPoint startPoint,endPoint;

@end
