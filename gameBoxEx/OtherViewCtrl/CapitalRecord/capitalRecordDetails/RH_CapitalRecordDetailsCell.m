//
//  RH_CapitalRecordDetailsCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalRecordDetailsCell.h"
#import "coreLib.h"
#import "RH_CapitalDetailModel.h"
@implementation RH_CapitalRecordDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_CapitalDetailModel *detailModel = ConvertToClassPointer(RH_CapitalDetailModel, context);
    for (int i = 10; i<16; i++) {
        UILabel *lab = [self viewWithTag:i];
        switch (i) {
            case 10:
                lab.text = detailModel.mTransactionNo;
                break;
            case 11:
                lab.text = [NSString stringWithFormat:@"%d",detailModel.mCreateTime];
                break;
            case 12:
                lab.text =detailModel.showTransactionMoney;
                break;
            case 13:
                lab.text = nil;
                break;
            case 14:
                lab.text = nil;
                break;
            case 15:
                lab.text =detailModel.mStatusName;
                break;
            default:
                break;
        }
    }
}

@end
