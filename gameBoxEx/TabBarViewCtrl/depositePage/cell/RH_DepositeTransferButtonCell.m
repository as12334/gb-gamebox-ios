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
