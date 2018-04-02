//
//  RH_CapitalStaticDataCell.m
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DespositeBitCoinStaticDataCell.h"
#import "coreLib.h"


@interface RH_DespositeBitCoinStaticDataCell()

@property (weak, nonatomic) IBOutlet CLSelectionControl *borderView;

@property (weak, nonatomic) IBOutlet UILabel *labDate;
@end


@implementation RH_DespositeBitCoinStaticDataCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor] ;
    self.borderView.backgroundColor = [UIColor clearColor] ;
//    self.borderView.layer.cornerRadius = 3.0f ;
//    self.borderView.layer.borderColor = RH_Line_DefaultColor.CGColor ;
//    self.borderView.layer.borderWidth = 1.0f  ;
//    self.borderView.layer.masksToBounds = YES ;
    self.borderView.whc_TopSpace(0).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
    self.labDate.textColor = colorWithRGB(51, 51, 51) ;
    self.labDate.font = [UIFont systemFontOfSize:14.0f] ;
    self.labDate.text = dateStringWithFormatter([ NSDate date], @"yyyy-MM-dd HH:mm:ss") ;
    self.labDate.textAlignment = NSTextAlignmentRight ;
}

#pragma mark-
-(void)addTarget:(id)object Selector:(SEL)selector
{
    [self.borderView addTarget:object action:selector forControlEvents:UIControlEventTouchUpInside] ;
}

-(void)updateUIWithDate:(NSDate*)date
{
    if (date){
        self.labDate.text = dateStringWithFormatter(date, @"yyyy-MM-dd HH:mm:ss") ;
    }
}
@end
