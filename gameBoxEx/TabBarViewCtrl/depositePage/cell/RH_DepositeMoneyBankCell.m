//
//  RH_DepositeMoneyBankCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeMoneyBankCell.h"
#import "coreLib.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeMoneyBankCell()
@property(nonatomic,strong)NSMutableArray *bankNameArray;

@end
@implementation RH_DepositeMoneyBankCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder]) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseBankName)];
    self.bankNameLabel.userInteractionEnabled = YES;
    self.bankNameString = self.bankNameLabel.text;
    [self.bankNameLabel addGestureRecognizer:tap];
    self.bankNameArray = [NSMutableArray array];
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.bankNameArray = [NSMutableArray array];
    RH_DepositeTransferChannelModel *channelModel = ConvertToClassPointer(RH_DepositeTransferChannelModel, context);
    for (RH_DepositeTransferListModel *listModel in channelModel.mArrayListModel) {
        if (listModel.mPayName!=nil) {
           [self.bankNameArray addObject:listModel.mPayName];
        }
    }
}
-(void)chooseBankName
{
    ifRespondsSelector(self.delegate, @selector(depositeMoneyBankCellChoosePickerview:andBankNameArray:)){
        [self.delegate depositeMoneyBankCellChoosePickerview:self andBankNameArray:self.bankNameArray];
    }
}
- (IBAction)chooseBankNameClick:(id)sender {
    [self chooseBankName];
}

@end
