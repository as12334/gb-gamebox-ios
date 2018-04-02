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

#import "RH_DespositeBitCoinStaticDataCell.h"

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
@property (nonatomic,strong,readonly) RH_DespositeBitCoinStaticDataCell *bitcoinStaticDateCell ;
@end
@implementation RH_DepositeBitcionCell
@synthesize bitcoinStaticDateCell = _bitcoinStaticDateCell ;
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
    WHC_StackView *stackView = [[WHC_StackView alloc] init];
    stackView.userInteractionEnabled = YES ;
    [self addSubview:stackView];
    stackView.whc_RightSpace(0).whc_TopSpaceToView(4, _bitcoinNumTextfield).whc_Width(200).whc_Height(38) ;
    stackView.whc_Column = 1;
    stackView.whc_HSpace = 10;
    stackView.whc_VSpace = 10;
    stackView.whc_Orientation = Horizontal;
    [stackView addSubview:self.bitcoinStaticDateCell];
    stackView.whc_Edge = UIEdgeInsetsMake(0, 0, 0, 0);
    [stackView whc_StartLayout];
    _bitConDate = [NSDate date] ;
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
- (IBAction)saveToPhone:(id)sender {
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellDidTouchSaveToPhoneWithUrl:)){
        [self.delegate depositeBitcionCellDidTouchSaveToPhoneWithUrl:self.listModel.qrShowCover] ;
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

-(RH_DespositeBitCoinStaticDataCell *)bitcoinStaticDateCell
{
    if (!_bitcoinStaticDateCell) {
        _bitcoinStaticDateCell = [RH_DespositeBitCoinStaticDataCell createInstance] ;
        [_bitcoinStaticDateCell updateUIWithDate:_bitConDate] ;
        [_bitcoinStaticDateCell addTarget:self Selector:@selector(bitcoinStaticDateCellHandle)];
    }
    return _bitcoinStaticDateCell ;
}

-(void)bitcoinStaticDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellDidTouchTimeSelectView:DefaultDate:)){
        [self.delegate depositeBitcionCellDidTouchTimeSelectView:self DefaultDate:_bitConDate] ;
    }

}

-(void)setBitConDate:(NSDate *)bitConDate
{
    if (![_bitConDate isEqualToDate:bitConDate]){
        _bitConDate = bitConDate;
        [self.bitcoinStaticDateCell updateUIWithDate:_bitConDate];
    }
}

@end
