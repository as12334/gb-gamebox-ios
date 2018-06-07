//
//  RH_GameListCategoryView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListCategoryView.h"
#import "RH_LotteryAPIInfoModel.h"
#import "UIImageView+WebCache.h"

@interface RH_GameListCategoryView ()
@property (weak, nonatomic) IBOutlet UIImageView *categoryIMG;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@end

@implementation RH_GameListCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(RH_LotteryAPIInfoModel *)model
{
    _model = model;
    self.titleLB.text = _model.mName;
    [self.categoryIMG sd_setImageWithURL:[NSURL URLWithString:_model.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];

}
@end
