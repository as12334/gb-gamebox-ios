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

/**
 银行卡的View
 */
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

/*有银行卡信息的Bottomview*/
/*右边lab*/
//姓名  第一行
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;
// 折扣优惠 第二行
@property (weak, nonatomic) IBOutlet UILabel *youhuiLab;
//  第三行
@property (weak, nonatomic) IBOutlet UILabel *thirdRightLab;
//手续费
@property (weak, nonatomic) IBOutlet UILabel *shouxuFeiLab;
//实际到账
@property (weak, nonatomic) IBOutlet UILabel *shijiMoney;
//状态
@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLab;
@property (weak, nonatomic) IBOutlet UILabel *SevenRightLab;

@property (weak, nonatomic) IBOutlet UILabel *realNameLab1; //真实姓名

@property (weak, nonatomic) IBOutlet UIImageView *TypeImageView;
/*左边lab*/
@property (weak, nonatomic) IBOutlet UIImageView *bankRightImage;  //银行卡右边的图片
@property (weak, nonatomic) IBOutlet UILabel *xingmingLab;

@property (weak, nonatomic) IBOutlet UILabel *zhekouyouhuiLeftLab;
//左边第三
@property (weak, nonatomic) IBOutlet UILabel *thirdLeftLab;

@property (weak, nonatomic) IBOutlet UILabel *shouxufeiLeftLab;
@property (weak, nonatomic) IBOutlet UILabel *shijidaozhangLeftLab;

@property (weak, nonatomic) IBOutlet UILabel *zhuangtaiLeftLab;
@property (weak, nonatomic) IBOutlet UILabel *SevenLeftLab;


/**
 存款为其它的BottomView2
 */
@property (weak, nonatomic) IBOutlet UIView *BottomView2;
// BottomView2 右边
@property (weak, nonatomic) IBOutlet UILabel *rechargeMoney;  //存款金额
@property (weak, nonatomic) IBOutlet UILabel *serviceChargeMoney; // 手续费
@property (weak, nonatomic) IBOutlet UILabel *inMyAccountMoney; //  实际到账
@property (weak, nonatomic) IBOutlet UILabel *isSuccState;  //  状态

@property (weak, nonatomic) IBOutlet UILabel *typeTitleLab; //类型

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
    
    self.BottomView2.layer.cornerRadius = 10.f;
    self.BottomView2.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.BottomView2.layer.borderWidth = 1.f;
    
    self.backgroundColor = colorWithRGB(255, 255, 255);
    self.headerLineView.backgroundColor = colorWithRGB(226, 226, 226);
    self.lineView.backgroundColor = colorWithRGB(226, 226, 226);
    _BottomView2.hidden = YES;
    _BottomView.hidden = YES;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
//    RH_BankCardModel *cardModel = ConvertToClassPointer(RH_BankCardModel, MineSettingInfo.mBankCard);
//    [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.showBankURL]];
    RH_CapitalDetailModel *detailModel = ConvertToClassPointer(RH_CapitalDetailModel, context);
    RH_CapitalInfoModel *infoModel = ConvertToClassPointer(RH_CapitalInfoModel, [info objectForKey:@"RH_CapitalInfoModel"]);
    if ([infoModel.mTransaction_typeName isEqualToString:@"转账"] ||[infoModel.mTransaction_typeName isEqualToString:@"transfers"])
    {
        self.thirdTitleLab.text = @"金额";
        self.FourthTitleLab.text = @"转出";
        self.FivethTitleLab.text = @"转入";
        self.SixthTitleLab.text = @"状态";
        self.subFirstTitleLab.text = detailModel.mTransactionNo;
        self.subSecondTitleLab.text =  dateStringWithFormatter(detailModel.mCreateTime, @"yyyy-MM-dd HH:mm:ss");
        self.subThirdTitleLab.text = detailModel.mTransactionMoney;
        self.subFourthTitleLab.text = detailModel.mTransferOut;
        self.subFivethTitleLab.text = detailModel.mTransferInto;
        self.subSixthTitleLab.text = detailModel.mStatusName;
    }
    if ([infoModel.mTransaction_typeName isEqualToString:@"返水"]|| [infoModel.mTransaction_typeName isEqualToString:@"推荐"]||[infoModel.mTransaction_typeName isEqualToString:@"优惠"]) {
        self.thirdTitleLab.text = @"描述";
        self.FourthTitleLab.text = @"金额";
        self.FivethTitleLab.text = @"状态";
        self.SixthView.hidden = YES;
        self.subFirstTitleLab.text = detailModel.mTransactionNo;
        self.subSecondTitleLab.text = dateStringWithFormatter(detailModel.mCreateTime, @"yyyy-MM-dd HH:mm:ss");
        if ([infoModel.mTransaction_typeName isEqualToString:@"返水"]) {
            self.subFourthTitleLab.text = [NSString stringWithFormat:@"%@", detailModel.mDeductFavorable];
        }else
        {
            self.subFourthTitleLab.text =  detailModel.mTransactionMoney;
        }
        self.subThirdTitleLab.text = detailModel.mTransactionWayName;
        self.subFivethTitleLab.text = detailModel.mStatusName;
    }
    if ([infoModel.mTransaction_typeName isEqualToString:@"存款"]  ||[infoModel.mTransaction_typeName isEqualToString:@"deposit"] ) {
        self.SevenLeftLab.hidden = YES ;
        self.SevenRightLab.hidden = YES ;
        if ([detailModel.mBankCodeName isEqualToString:@"比特币"] || [detailModel.mBankCode isEqualToString:@"bitcoin"])
        {
            //比特币存款
            self.bankRightImage.hidden = YES;
            self.BottomView2.hidden = YES;
            self.BottomView.hidden = NO;
            self.FirstTitleLab.text = @"交易号:";
            self.subFirstTitleLab.text = detailModel.mTransactionNo;
            self.SecondTitleLab.text = @"创建时间:";
            self.subSecondTitleLab.text = dateStringWithFormatter(detailModel.mCreateTime, @"yyyy-MM-dd HH:mm:ss");
            self.thirdTitleLab.text = @"描述:";
            self.subThirdTitleLab.text = detailModel.mTransactionWayName;
            self.FourthTitleLab.text = @"txId:";
            self.subFourthTitleLab.text = detailModel.mTxId;
            self.FivethTitleLab.text = @"交易时间:";
            self.subFivethTitleLab.text = dateStringWithFormatter(detailModel.mReturnTime, @"yyyy-MM-dd HH:mm:SS");
            self.SixthTitleLab.text = @"比特币地址:";
            self.subSixthTitleLab.text = detailModel.mBitcoinAdress;
            self.bankImageView.image = ImageWithName(@"bitcoin_image");
            self.isSuccState.hidden = YES;
            self.xingmingLab.text = @"姓名:";
            self.realNameLab.text = detailModel.mRealName?:MineSettingInfo.mRealName;
            self.zhekouyouhuiLeftLab.text = @"比特币:";
            self.youhuiLab.text = detailModel.mRechargeAmount;
            self.thirdLeftLab.text = @"状态:";
            self.thirdRightLab.text = detailModel.mStatusName;
            self.shouxuFeiLab.hidden = YES;
            self.shouxufeiLeftLab.hidden = YES;
            self.shijidaozhangLeftLab.hidden = YES;
            self.zhuangtaiLeftLab.hidden = YES;
            self.shijiMoney.hidden = YES;
            self.zhuangtaiLab.hidden = YES;
        }else if([detailModel.mBankCodeName containsString:@"银行"]){
            //有银行卡信息
            self.BottomView2.hidden = YES;
            self.BottomView.hidden = NO;
            self.zhekouyouhuiLeftLab.text = @"存款金额:";
            _BottomView.whc_TopSpaceToView(36, self.thirdView).whc_LeftSpace(15).whc_RightSpace(15).whc_HeightAuto();
            self.FourthView.hidden = YES;
            self.FivethView.hidden = YES;
            self.SixthView.hidden = YES;
            self.zhuangtaiLab.hidden = YES;
            self.zhuangtaiLeftLab.hidden = YES;
            self.thirdLeftLab.text = @"手续费:";
            self.thirdRightLab.text = detailModel.mPoundage ;
            self.shouxufeiLeftLab.text = @"实际到账:";
             self.shouxuFeiLab.text =detailModel.mRechargeTotalAmount;
            self.shijidaozhangLeftLab.text = @"状态:";
            self.shijiMoney.text = detailModel.mStatusName ;
            self.subFirstTitleLab.text = detailModel.mTransactionNo;
            self.subSecondTitleLab.text = dateStringWithFormatter(detailModel.mCreateTime, @"yyyy-MM-dd HH:mm:ss");
            self.subThirdTitleLab.text = detailModel.mTransactionWayName;
            [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.showBankURL]];
            self.realNameLab.text = detailModel.mRealName;
            self.youhuiLab.text = detailModel.mRechargeAmount;
        }
        else  // 普通存款
        {
            self.BottomView2.hidden = NO;
            self.BottomView.hidden = YES;
            
            self.rechargeMoney.text = detailModel.mRechargeAmount ;
            self.serviceChargeMoney.text = detailModel.mPoundage ;
            self.inMyAccountMoney.text = detailModel.mRechargeTotalAmount ;
            self.isSuccState.text = detailModel.mStatusName ;
             _BottomView2.whc_TopSpaceToView(36, self.thirdView).whc_LeftSpace(15).whc_RightSpace(15).whc_HeightAuto();
            self.realNameLab1.text = detailModel.mRealName?:MineSettingInfo.mRealName;
            if (detailModel.showBankURL.length > 0) {
                 [self.TypeImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.showBankURL]];
            }else
            {
                self.typeTitleLab.text = detailModel.mBankCodeName;
            }
            self.thirdTitleLab.text = @"描述";
            self.subFirstTitleLab.text = detailModel.mTransactionNo;
            self.subSecondTitleLab.text =  dateStringWithFormatter(detailModel.mCreateTime, @"yyyy-MM-dd HH:mm:ss");
            self.subThirdTitleLab.text = detailModel.mTransactionWayName;
            self.FourthView.hidden = YES;
            self.FivethView.hidden = YES;
            self.SixthView.hidden = YES;
        }
        
    }
    if ([infoModel.mTransaction_typeName isEqualToString:@"取款"]) {
        [self.bankImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.showBankURL]];
        self.thirdTitleLab.text = @"描述";
        self.subFirstTitleLab.text = detailModel.mTransactionNo;
        self.subSecondTitleLab.text = dateStringWithFormatter(detailModel.mCreateTime, @"yyyy-MM-dd HH:mm:ss");
        self.subThirdTitleLab.text = detailModel.mTransactionWayName;
        self.FourthView.hidden = YES;
        self.FivethView.hidden = YES;
        self.SixthView.hidden = YES;
        _BottomView.hidden = NO;
        self.xingmingLab.text = @"姓名:";
        self.zhekouyouhuiLeftLab.text = @"取款金额:";
        self.thirdLeftLab.text = @"手续费:";
        self.shouxufeiLeftLab.text = @"行政费用：";
        self.shijidaozhangLeftLab.text = @"折扣优惠:";
        self.zhuangtaiLeftLab.text = @"实际到账:";
        self.SevenLeftLab.text = @"状态：";
        _BottomView2.hidden = YES;
        _BottomView.whc_TopSpaceToView(36, self.thirdView).whc_LeftSpace(15).whc_RightSpace(15).whc_HeightAuto();
        self.realNameLab.text = detailModel.mRealName;
        self.youhuiLab.text= [NSString stringWithFormat:@"%@",detailModel.mWithdrawMoney] ;
        self.thirdRightLab.text =  detailModel.mPoundage;
        self.shouxuFeiLab.text = detailModel.mAdministrativeFee;
        self.shijiMoney.text =detailModel.mDeductFavorable;
        self.zhuangtaiLab.text = detailModel.mRechargeTotalAmount;
        self.SevenRightLab.text = detailModel.mStatusName ;
    }
}

@end
