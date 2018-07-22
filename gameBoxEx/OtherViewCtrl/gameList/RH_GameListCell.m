//
//  RH_GameListCell.m
//  gameBoxEx
//
//  Created by shin on 2018/6/7.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListCell.h"
#import "RH_LotteryInfoModel.h"
#import "UIImageView+WebCache.h"
#import "RH_LotteryAPIInfoModel.h"

@interface RH_GameListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *gameIMG;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *subtypeLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UIImageView *typeMarkIMG;

@end

@implementation RH_GameListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RH_LotteryInfoModel *)model
{
    _model = model;
    [self.gameIMG sd_setImageWithURL:[NSURL URLWithString:_model.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.nameLB.text = _model.mName;
}

- (void)setTypeModel:(RH_LotteryAPIInfoModel *)typeModel
{
    _typeModel = typeModel;
    [self.typeMarkIMG sd_setImageWithURL:[NSURL URLWithString:_typeModel.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)setType:(NSString *)type
{
    _type = type;
    self.typeLB.text = _type;
}

- (void)setSubType:(NSString *)subType
{
    _subType = subType;
    self.subtypeLB.text = _subType;
}
@end
