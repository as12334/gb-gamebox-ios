//
//  RH_DepositeBitcionCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/31.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeBitcionCell.h"
#import "coreLib.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeBitcionCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bitcoinAdressTextfield;

@property (weak, nonatomic) IBOutlet UITextField *txidTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinChangeTimeTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *bitcoinIcon;
@property (weak, nonatomic) IBOutlet UITextView *bitcoinNoteTextview;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic,strong)RH_DepositeTransferListModel *listModel;

@end
@implementation RH_DepositeBitcionCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listeModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.listModel = listeModel;
    [self.bitcoinIcon sd_setImageWithURL:[NSURL URLWithString:self.listModel.accountImgCover]];
    self.personNameLabel.text = self.listModel.mFullName;
    [self.qrImageView sd_setImageWithURL:[NSURL URLWithString:self.listModel.qrShowCover]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    self.bitcoinAdressTextfield.delegate = self;
    self.txidTextfield.delegate = self;
    self.bitcoinNumTextfield.delegate = self;
    self.bitcoinChangeTimeTextfield.delegate = self;
}
- (IBAction)submitClick:(id)sender {
 
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellUpframe:)){
        [self.delegate depositeBitcionCellUpframe:self];
    }
    return YES;
}
@end
