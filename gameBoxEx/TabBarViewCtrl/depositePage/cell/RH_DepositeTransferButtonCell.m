//
//  RH_DepositeTransferButtonCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/28.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferButtonCell.h"
#import "coreLib.h"
@interface RH_DepositeTransferButtonCell()
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
@implementation RH_DepositeTransferButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = colorWithRGB(23, 102, 187);
    self.backgroundColor = colorWithRGB(242, 242, 242);
    if ([THEMEV3 isEqualToString:@"green"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"black"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
    }else if ([THEMEV3 isEqualToString:@"red"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"blue"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
    }else if ([THEMEV3 isEqualToString:@"orange"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
    }else if ([THEMEV3 isEqualToString:@"red_white"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
    }else if ([THEMEV3 isEqualToString:@"green_white"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
    }else if ([THEMEV3 isEqualToString:@"orange_white"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
    }else{
        
    }
}
- (IBAction)click:(id)sender {
    ifRespondsSelector(self.delegate, @selector(selectedDepositeTransferButton:)){
        [self.delegate selectedDepositeTransferButton:self] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
