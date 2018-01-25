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
#import "RH_UserInfoManager.h"
#import "RH_BankCardModel.h"
#import "UIImageView+WebCache.h"
@interface RH_CapitalRecordDetailsCell()
@property (weak, nonatomic) IBOutlet CLBorderView *lineView;
@property (weak, nonatomic) IBOutlet UIView *personInfoView;
@property (weak, nonatomic) IBOutlet CLBorderView *headerLineView;
@property (weak, nonatomic) IBOutlet CLBorderView *bottomLineView;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@end

@implementation RH_CapitalRecordDetailsCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return MainScreenH-StatusBarHeight-NavigationBarHeight;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self= [super initWithCoder:aDecoder]) {
        self.backgroundColor = colorWithRGB(242, 242, 242);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.personInfoView.layer.cornerRadius = 10.f;
    self.personInfoView.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.personInfoView.layer.borderWidth = 1.f;
    self.backgroundColor = colorWithRGB(255, 255, 255);
    self.headerLineView.backgroundColor = colorWithRGB(226, 226, 226);
    self.lineView.backgroundColor = colorWithRGB(226, 226, 226);
    self.bottomLineView.backgroundColor =colorWithRGB(226, 226, 226);
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_BankCardModel *cardModel = ConvertToClassPointer(RH_BankCardModel, MineSettingInfo.mBankCard);
    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.mbankUrl]];
    RH_CapitalDetailModel *detailModel = ConvertToClassPointer(RH_CapitalDetailModel, context);
    for (int i=10; i<19; i++) {
        UILabel *label = [self viewWithTag:i];
        switch (i) {
            case 10:
                label.text = detailModel.mTransactionNo;
                break;
            case 11:
                label.text = [NSString stringWithFormat:@"%ld",detailModel.mCreateTime];
                break;
            case 12:
                label.text = detailModel.mTransactionWayName;
                break;
            case 13:
                label.text = detailModel.mStatusName;
                break;
            case 14:
                label.text = detailModel.mRealName;
                break;
            case 15:
                label.text = detailModel.mDeductFavorable;
                break;
            case 16:
                label.text = detailModel.mPoundage;
                break;
            case 17:
                label.text = detailModel.mRechargeTotalAmount;
                break;
            case 18:
                label.text = detailModel.mStatus;
                break;
                
            default:
                break;
        }
    }
}

@end
