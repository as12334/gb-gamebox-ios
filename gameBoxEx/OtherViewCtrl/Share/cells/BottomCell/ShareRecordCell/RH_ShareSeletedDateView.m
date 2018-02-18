//
//  RH_MPGameSeletedDateView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareSeletedDateView.h"
#import "coreLib.h"
@interface RH_ShareSeletedDateView()


@end
@implementation RH_ShareSeletedDateView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.dateLabel.textColor = colorWithRGB(51, 51, 51) ;
    self.dateLabel.font = [UIFont systemFontOfSize:10.0f] ;
    self.dateLabel.text = dateStringWithFormatter([NSDate date], @"yyyy-MM-dd") ;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = colorWithRGB(242, 242, 242).CGColor;
}

#pragma mark-
-(void)addTarget:(id)object Selector:(SEL)selector
{
    [self addTarget:object action:selector forControlEvents:UIControlEventTouchUpInside] ;
}

-(void)updateUIWithDate:(NSDate*)date
{
    if (date){
        self.dateLabel.text = dateStringWithFormatter(date, @"yyyy-MM-dd") ;
    }
}

@end
