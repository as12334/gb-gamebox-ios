//
//  RH_PromoTableCell.m
//  gameBoxEx
//
//  Created by luis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoTableCell.h"
#import "RH_UserInfoManager.h"
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"

@interface RH_PromoTableCell()
@property (nonatomic,weak) IBOutlet CLBorderView *borderView ;
@property (nonatomic,weak) IBOutlet UIView *bottomView ;
@property (nonatomic,weak) IBOutlet UIImageView *activeImageView ;
@property (nonatomic,strong) RH_DiscountActivityModel *discountActivityModel ;
@property (nonatomic,weak) IBOutlet UILabel *labTitle ;
@property (nonatomic,weak) IBOutlet CLButton *btnDetail ;

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
    self.borderView.layer.borderColor = colorWithRGB(226, 226, 226).CGColor ;
    self.borderView.layer.borderWidth = 1.0f ;
    self.borderView.layer.cornerRadius = 4.f ;
    self.borderView.layer.masksToBounds = YES ;

    self.borderView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.bottomView.backgroundColor = colorWithRGB(242, 242, 242) ;
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
    self.selectionColorAlpha = 0.5f ;
    self.labTitle.textColor = colorWithRGB(50, 51, 51) ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f] ;
    [self.btnDetail setTitleColor:colorWithRGB(49, 126, 194) forState:UIControlStateNormal] ;
    [self.btnDetail setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:RHNT_DiscountActivityImageSizeChanged
                                               object:nil] ;
    if ([THEMEV3 isEqualToString:@"green"]) {
        self.labTitle.textColor = colorWithRGB(255, 255, 255) ;
        [self.btnDetail setTitleColor:colorWithRGB(15, 167, 115) forState:UIControlStateNormal]  ;
        self.borderView.backgroundColor = colorWithRGB(53, 53, 53);
        self.bottomView.backgroundColor = colorWithRGB(37, 37, 37);;
    }
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
    [self.activeImageView sd_setImageWithURL:[NSURL URLWithString:self.discountActivityModel.showPhoto] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates
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

-(IBAction)btn_enterDetail:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(promoTableCellTouchEnterDetail:CellModel:)){
        [self.delegate promoTableCellTouchEnterDetail:self CellModel:self.discountActivityModel] ;
    }
}
@end
