//
//  RH_PromoTableCell.m
//  gameBoxEx
//
//  Created by luis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoTableCell.h"

@interface RH_PromoTableCell()
@property (nonatomic,weak) IBOutlet UIImageView *activeImageView ;
@property (nonatomic,strong) RH_DiscountActivityModel *discountActivityModel ;
@property (nonatomic,weak) IBOutlet UILabel *labTitle ;
@property (weak, nonatomic) IBOutlet UIButton *LookDetail;

@end


@implementation RH_PromoTableCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_DiscountActivityModel *discountActivityModel = ConvertToClassPointer(RH_DiscountActivityModel, context) ;
    if (discountActivityModel){
        return floor((discountActivityModel.showImageSize.height/discountActivityModel.showImageSize.width)*tableView.frameWidth) + 60 ;
    }
    
    return 0.0f  ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
    self.selectionColorAlpha = 0.5f ;
    self.labTitle.textColor = colorWithRGB(50, 51, 51);
    self.labTitle.font = [UIFont systemFontOfSize:14.f];
    [self.LookDetail setTitleColor:colorWithRGB(49, 126, 194) forState:UIControlStateNormal];
    self.LookDetail.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:RHNT_DiscountActivityImageSizeChanged
                                               object:nil] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(UIView *)showSelectionView
{
    return self.activeImageView ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.discountActivityModel = ConvertToClassPointer(RH_DiscountActivityModel, context) ;
    [self.activeImageView sd_setImageWithURL:[NSURL URLWithString:self.discountActivityModel.showPhoto]
                                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                       if (image){
                                           [self.discountActivityModel updateImageSize:image.size] ;
                                       }
                                   }] ;
    self.labTitle.text = self.discountActivityModel.showName;
}


#pragma mark-
-(void)handleNotification:(NSNotification*)nf
{
    if ([nf.name isEqualToString:RHNT_DiscountActivityImageSizeChanged]){
        RH_DiscountActivityModel *discountModel = ConvertToClassPointer(RH_DiscountActivityModel, nf.object) ;
        if (discountModel == self.discountActivityModel){
            ifRespondsSelector(self.delegate, @selector(promoTableCellImageSizeChangedNotification:)){
                [self.delegate promoTableCellImageSizeChangedNotification:self] ;
            }
        }
    }
}
@end
