//
//  RH_CapitalRecordNameLabel.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalRecordNameLabel.h"
#import "coreLib.h"
@implementation RH_CapitalRecordNameLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}
-(void)layoutSubviews
{
    self.textColor  = colorWithRGB(153, 153, 153);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
