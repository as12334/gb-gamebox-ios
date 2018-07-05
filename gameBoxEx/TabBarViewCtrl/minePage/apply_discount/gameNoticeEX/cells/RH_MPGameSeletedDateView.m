//
//  RH_MPGameSeletedDateView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameSeletedDateView.h"
#import "coreLib.h"
@interface RH_MPGameSeletedDateView()


@end
@implementation RH_MPGameSeletedDateView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.dateLabel.textColor = colorWithRGB(51, 51, 51) ;
    self.dateLabel.font = [UIFont systemFontOfSize:10.0f] ;
    self.dateLabel.text = dateString([NSDate date], @"yyyy-MM-dd") ;
}

#pragma mark-
-(void)addTarget:(id)object Selector:(SEL)selector
{
    [self addTarget:object action:selector forControlEvents:UIControlEventTouchUpInside] ;
}

-(void)updateUIWithDate:(NSDate*)date
{
    if (date){
        self.dateLabel.text = dateString(date, @"yyyy-MM-dd");
    }
}

@end
