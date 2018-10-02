//
//  RH_NewPromoTableViewCell.m
//  gameBoxEx
//
//  Created by barca on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "RH_NewPromoTableViewCell.h"
#import "UIColor+PGHex.h"
#import "coreLib.h"

@implementation RH_NewPromoTableViewCell
- (IBAction)didClickPromoAction:(id)sender {
    if ([self.promoDelegate respondsToSelector:@selector(cellToJump:)]) {
        [self.promoDelegate cellToJump:self.cellIndexPath];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexStr:@"#DEDEDE"];
    self.promoImageView.layer.masksToBounds = YES;
    self.promoImageView.layer.cornerRadius = 5.0f;
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self.promoButton setTitleColor:[UIColor colorWithHexString:@"#2D90F5"] forState:(UIControlStateNormal)];
    [self.detailLabel setTextColor:[UIColor colorWithHexString:@"#343434"]];

}
-(void)passRH_DiscountActivityModel:(RH_DiscountActivityModel *)discountActivityModel
{
    self.detailLabel.text = discountActivityModel.showName;
    [self.promoImageView sd_setImageWithURL:[NSURL URLWithString:discountActivityModel.showPhoto] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
//    CGFloat proportion = self.promoImageView.image.size.width/ScreenWidth;
//    UIImage *image =  [self.promoImageView.image imageZoomInToMaxSize:CGSizeMake(self.promoImageView.image.size.width /proportion, self.promoImageView.image.size.height /proportion)];
    
    
//    self.promoImageView.image = [UIImage ct_imageFromImage:image inRect:CGRectMake(0,image.size.height/2 - 25 , ScreenWidth - 40, 50)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
