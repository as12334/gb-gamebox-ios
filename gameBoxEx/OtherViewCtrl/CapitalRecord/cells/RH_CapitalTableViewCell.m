//
//  RH_CapitalTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalTableViewCell.h"
#import "coreLib.h"
#import "RH_CapitalInfoModel.h"
@interface RH_CapitalTableViewCell ()

@property(nonatomic,strong)UILabel *dataLab; //日期
@property(nonatomic,strong)UILabel *moneyTypeLab; //金额
@property(nonatomic,strong)UILabel *depositTypeLab;//存款
@property(nonatomic,strong)UILabel *timeoutTypeLab;//超时
@end

@implementation RH_CapitalTableViewCell

+ (CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40.0f ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UILabel *)dataLab
{
    if(_dataLab == nil){
        _dataLab = [UILabel new];
    }
    return _dataLab;
}

-(UILabel *)moneyTypeLab
{
    if(_moneyTypeLab == nil){
        _moneyTypeLab = [[UILabel alloc] init];
    }
    return _moneyTypeLab;
}

-(UILabel *)depositTypeLab
{
    if(_depositTypeLab == nil){
        _depositTypeLab = [[UILabel alloc] init];
    }
    return _depositTypeLab;
}

-(UILabel *)timeoutTypeLab
{
    if(_timeoutTypeLab == nil){
        _timeoutTypeLab = [[UILabel alloc] init];
    }
    return _timeoutTypeLab;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine;
    self.separatorLineColor = colorWithRGB(242, 242, 242);
    self.separatorLineWidth = 1.0f;
    self.backgroundColor = colorWithRGB(255, 255, 255);
    
    [self.contentView addSubview:self.dataLab];
    [self.contentView addSubview:self.moneyTypeLab];
    [self.contentView addSubview:self.depositTypeLab];
    [self.contentView addSubview:self.timeoutTypeLab];
    
    CGFloat widthRect = self.contentView.frame.size.width;
    self.dataLab.whc_LeftSpace(10).whc_TopSpace(5).whc_Width(80).whc_Height(30);
    self.dataLab.textColor = colorWithRGB(51, 51, 51);
    self.dataLab.font = [UIFont systemFontOfSize:12.f];
    self.dataLab.text = @"2018-01-09";
    self.moneyTypeLab.whc_LeftSpace(screenSize().width > 375?0.45*widthRect:0.36*widthRect).whc_TopSpace(5).whc_Width(40).whc_Height(30);
    self.moneyTypeLab.textColor = colorWithRGB(28, 217,135);
    self.moneyTypeLab.font = [UIFont systemFontOfSize:12.f];
    self.moneyTypeLab.text = @"+100";
    self.timeoutTypeLab.whc_RightSpace(10).whc_TopSpace(5).whc_Width(40).whc_Height(30);
    
    self.timeoutTypeLab.textColor = colorWithRGB(244, 158, 46);
    self.timeoutTypeLab.font = [UIFont systemFontOfSize:12.f];
    self.timeoutTypeLab.text = @"超时";

    self.depositTypeLab.whc_RightSpace(screenSize().width > 375?0.35*widthRect:0.28*widthRect).whc_TopSpace(5).whc_Width(40).whc_Height(30);
    self.depositTypeLab.textColor = colorWithRGB(51, 51, 51);
    self.depositTypeLab.font = [UIFont systemFontOfSize:12.f];
    self.depositTypeLab.text = @"存款";
    
    self.dataLab.textAlignment = NSTextAlignmentCenter;
    self.moneyTypeLab.textAlignment = NSTextAlignmentCenter;
    self.depositTypeLab.textAlignment = NSTextAlignmentCenter;
    self.timeoutTypeLab.textAlignment = NSTextAlignmentCenter;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_CapitalInfoModel *capitalInfoModel = ConvertToClassPointer(RH_CapitalInfoModel, context);
    self.dataLab.text = capitalInfoModel.mCreateTime;
    self.moneyTypeLab.text = capitalInfoModel.mTransactionMoney;
    self.depositTypeLab.text = capitalInfoModel.mTransaction_typeName;
    self.timeoutTypeLab.text = capitalInfoModel.mStatusName;
    
}
@end
