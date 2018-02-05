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
#import "RH_CapitalInfoModel.h"
@interface RH_CapitalRecordDetailsCell()
@property (weak, nonatomic) IBOutlet CLBorderView *lineView;
@property (weak, nonatomic) IBOutlet UIView *personInfoView;
@property (weak, nonatomic) IBOutlet CLBorderView *headerLineView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;

@property (weak, nonatomic) IBOutlet UIView *FirstView;
@property (weak, nonatomic) IBOutlet UILabel *FirstTitleLab;  //第一个标题
@property (weak, nonatomic) IBOutlet UILabel *subFirstTitleLab;  //第一个子标题

@property (weak, nonatomic) IBOutlet UIView *SecondView;
@property (weak, nonatomic) IBOutlet UILabel *SecondTitleLab;  //第二个标题
@property (weak, nonatomic) IBOutlet UILabel *subSecondTitleLab;  //第二个子标题

@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitleLab;  //第三个标题
@property (weak, nonatomic) IBOutlet UILabel *subThirdTitleLab;  //第三个子标题

@property (weak, nonatomic) IBOutlet UIView *FourthView;
@property (weak, nonatomic) IBOutlet UILabel *FourthTitleLab;  //第四个标题
@property (weak, nonatomic) IBOutlet UILabel *subFourthTitleLab;  //第四个子标题

@property (weak, nonatomic) IBOutlet UIView *FivethView;
@property (weak, nonatomic) IBOutlet UILabel *FivethTitleLab;  //第五个标题
@property (weak, nonatomic) IBOutlet UILabel *subFivethTitleLab;  //第五个子标题

@property (weak, nonatomic) IBOutlet UIView *SixthView;
@property (weak, nonatomic) IBOutlet UILabel *SixthTitleLab;  //第六个标题
@property (weak, nonatomic) IBOutlet UILabel *subSixthTitleLab;  //第六个子标题

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
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_BankCardModel *cardModel = ConvertToClassPointer(RH_BankCardModel, MineSettingInfo.mBankCard);
    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.showBankURL]];
    RH_CapitalDetailModel *detailModel = ConvertToClassPointer(RH_CapitalDetailModel, context);
    RH_CapitalInfoModel *infoModel = ConvertToClassPointer(RH_CapitalInfoModel, [info objectForKey:@"RH_CapitalInfoModel"]);
    if ([infoModel.mTransaction_typeName isEqualToString:@"转账"])
    {
        self.thirdTitleLab.text = @"金额";
        self.FourthTitleLab.text = @"转出";
        self.FivethTitleLab.text = @"转入";
        self.SixthTitleLab.text = @"状态";
        self.subFivethTitleLab.text = detailModel.mTransactionNo;
        self.subSecondTitleLab.text =  dateStringWithFormatter(detailModel.mCreateTime, @"yyyy-MM-dd HH:mm:SS");
        self.subThirdTitleLab.text = detailModel.showTransactionMoney;
        self.subFourthTitleLab.text = detailModel.mTransferOut;
        self.subFivethTitleLab.text = detailModel.mTransferInto;
        self.subSixthTitleLab.text = detailModel.mStatusName;
        
    }
    if ([infoModel.mTransaction_typeName isEqualToString:@"返水"]|| [infoModel.mTransaction_typeName isEqualToString:@"推荐"]||[infoModel.mTransaction_typeName isEqualToString:@"优惠"]) {
        self.thirdTitleLab.text = @"描述";
        self.FourthTitleLab.text = @"金额";
        self.FivethTitleLab.text = @"状态";
        self.SixthView.hidden = YES;
        _BottomView.hidden = YES;
    }
    if ([infoModel.mTransaction_typeName isEqualToString:@"存款"] || [infoModel.mTransaction_typeName isEqualToString:@"取款"]) {
        self.thirdTitleLab.text = @"描述";
        self.subThirdTitleLab.text = detailModel.mTransactionWayName;
        self.FourthView.hidden = YES;
        self.FivethView.hidden = YES;
        self.SixthView.hidden = YES;
        _BottomView.hidden = NO;
        _BottomView.whc_TopSpaceToView(36, self.thirdView).whc_LeftSpace(15).whc_RightSpace(15).whc_HeightAuto();
    }else
    {
        _BottomView.hidden = YES;
    }

    NSString *strState;
    if([detailModel.mStatusName isEqualToString:@"失败"]){
        strState = detailModel.mFailureReason;
    }else
    {
        strState = @"";
    }
}

@end
