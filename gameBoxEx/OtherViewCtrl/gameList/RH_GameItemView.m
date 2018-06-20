//
//  RH_GameItemView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameItemView.h"
#import "RH_LotteryInfoModel.h"
#import "UIImageView+WebCache.h"
#import "MacroDef.h"
#import "RH_LotteryAPIInfoModel.h"

@interface RH_GameItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverIMG;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UIImageView *typeMarkIMG;

@end

@implementation RH_GameItemView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cornerView.layer.borderWidth = 0.5;
    self.cornerView.layer.borderColor = colorWithRGB(255,255,255).CGColor;
    self.cornerView.layer.cornerRadius = 8;
    self.cornerView.clipsToBounds = YES;
    self.layer.shadowColor = ColorWithRGBA(0, 0, 0, 0.5).CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 4.0;
    self.layer.cornerRadius = 8.0;
    
    self.clipsToBounds = NO;
}

- (void)setModel:(RH_LotteryInfoModel *)model
{
    _model = model;
    [self.coverIMG sd_setImageWithURL:[NSURL URLWithString:_model.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.nameLB.text = _model.mName;
}

- (void)setTypeModel:(RH_LotteryAPIInfoModel *)typeModel
{
    _typeModel = typeModel;
    [self.typeMarkIMG sd_setImageWithURL:[NSURL URLWithString:_typeModel.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ifRespondsSelector(self.delegate, @selector(gameItemView:didSelect:)){
        [self.delegate gameItemView:self didSelect:self.model];
    }
}

@end
