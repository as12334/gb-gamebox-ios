//
//  RH_DepositeBitcionCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/31.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeBitcionCell.h"
#import "coreLib.h"
@interface RH_DepositeBitcionCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bitcoinAdressStr;

@property (weak, nonatomic) IBOutlet UITextField *txidStr;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinNum;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinChangeTimeStr;
@property (nonatomic,strong)NSMutableArray *bitcoinInfoArray;
@end
@implementation RH_DepositeBitcionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bitcoinInfoArray = [NSMutableArray array];
    self.bitcoinAdressStr.delegate = self;
    self.txidStr.delegate = self;
    self.bitcoinNum.delegate = self;
    self.bitcoinChangeTimeStr.delegate = self;
    // Initialization code
}
- (IBAction)submitClick:(id)sender {
    
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellSubmit:)){
        [self.delegate depositeBitcionCellSubmit:self.bitcoinInfoArray] ;
    }
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.bitcoinInfoArray addObject:self.bitcoinAdressStr.text];
    [self.bitcoinInfoArray addObject:self.txidStr.text];
    [self.bitcoinInfoArray addObject:self.bitcoinNum.text];
    [self.bitcoinInfoArray addObject:self.bitcoinChangeTimeStr.text];
    return YES;
}

@end
