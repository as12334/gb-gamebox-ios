//
//  RH_BankPickerSelectView.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BankPickerSelectView.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"
@interface RH_BankPickerSelectView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickView;

@end

@implementation RH_BankPickerSelectView
{
    NSInteger selectedRow;
    NSArray *_list;
}
@synthesize pickView = _pickView;
- (UIPickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        UIButton *button_Cancel = [UIButton new];
        [self addSubview:button_Cancel];
        button_Cancel.whc_LeftSpace(15).whc_TopSpace(5).whc_Width(60).whc_Height(44);
        button_Cancel.layer.cornerRadius = 5;
        button_Cancel.clipsToBounds = YES;
        [button_Cancel setTitle:@"取消" forState:UIControlStateNormal];
        [button_Cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        UIButton *button_Confirm = [UIButton new];
        [self addSubview:button_Confirm];
        button_Confirm.whc_TopSpace(5).whc_RightSpace(15).whc_Height(44).whc_Width(60);
        button_Confirm.layer.cornerRadius = 5;
        button_Confirm.clipsToBounds = YES;
        [button_Confirm setTitle:@"确定" forState:UIControlStateNormal];
        [button_Confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [UIView new];
        [self addSubview:line];
        line.whc_LeftSpace(20).whc_RightSpace(20).whc_Height(2).whc_TopSpaceToView(10, button_Confirm);
        
        [self addSubview:self.pickView];
        self.pickView.whc_TopSpaceToView(5, line).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.pickView.whc_BottomSpace(0);
}

- (void)cancel {
    ifRespondsSelector(self.delegate, @selector(bankPickerSelectViewDidTouchCancelButton:)){
        [self.delegate bankPickerSelectViewDidTouchCancelButton:self] ;
    }
}
- (void)confirm {
    ifRespondsSelector(self.delegate, @selector(bankPickerSelectViewDidTouchConfirmButton:WithSelectedBank:)){
        [self.delegate bankPickerSelectViewDidTouchConfirmButton:self WithSelectedBank:BankList[selectedRow]] ;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_list.count > 0) {
        return _list.count;
    }
    return BankList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_list.count > 0) {
        return _list[row];
    }
    return BankList[row].mBankName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

- (void)setDatasourceList:(NSArray *)list{
    _list = list ;
}

@end
