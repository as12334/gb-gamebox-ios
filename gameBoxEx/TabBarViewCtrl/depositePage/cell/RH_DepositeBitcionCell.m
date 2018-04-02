//
//  RH_DepositeBitcionCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/31.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeBitcionCell.h"
#import "coreLib.h"
#import "RH_DespositeBitCoinStaticDataCell.h"

@interface RH_DepositeBitcionCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bitcoinAdressTextfield;

@property (weak, nonatomic) IBOutlet UITextField *txidTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinChangeTimeTextfield;
@property (nonatomic,strong,readonly) RH_DespositeBitCoinStaticDataCell *bitcoinStaticDateCell ;

@end
@implementation RH_DepositeBitcionCell
@synthesize bitcoinStaticDateCell = _bitcoinStaticDateCell ;

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
