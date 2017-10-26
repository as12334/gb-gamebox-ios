//
//  CLLabel.h
//  TaskTracking
//
//  Created by jinguihua on 2017/5/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLabel : UILabel

//计算内建大小时单元扩张的比例，单位量，默认为CGSizeZero
@property(nonatomic) CGSize intrinsicSizeExpansionScale;

////计算内建大小时单元扩张的比例长度，绝对值，默认为CGSizeZero
@property(nonatomic) CGSize intrinsicSizeExpansionLength;



@end
