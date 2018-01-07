//
//  RH_LotteryGameListTopView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_LotteryGameListTopView.h"
@interface RH_LotteryGameListTopView()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation RH_LotteryGameListTopView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.textField.layer.borderWidth = 1.0f;
    
}
@end
