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
@property (weak, nonatomic) IBOutlet UITextField *bitcoinAdressTextfield;

@property (weak, nonatomic) IBOutlet UITextField *txidTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinChangeTimeTextfield;

@end
@implementation RH_DepositeBitcionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (IBAction)submitClick:(id)sender {
    self.bitcoinAdressTextfield.delegate = self;
    self.txidTextfield.delegate = self;
    self.bitcoinNumTextfield.delegate = self;
    self.bitcoinChangeTimeTextfield.delegate = self;
    [self.bitcoinAdressTextfield resignFirstResponder];
    [self.txidTextfield resignFirstResponder];
    [self.bitcoinNumTextfield resignFirstResponder];
    [self.bitcoinChangeTimeTextfield resignFirstResponder];
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellSubmit:)){
        [self.delegate depositeBitcionCellSubmit:self] ;
    }
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.bitcoinAdressStr = self.bitcoinAdressTextfield.text;
    self.txidStr = self.txidTextfield.text;
    self.bitcoinNumStr = self.bitcoinNumTextfield.text;
    self.bitcoinChangeTimeStr = self.bitcoinChangeTimeTextfield.text;
    return YES;
}

@end
