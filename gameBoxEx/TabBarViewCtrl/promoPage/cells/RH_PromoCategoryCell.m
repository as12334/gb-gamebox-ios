//
//  RH_PromoCategoryCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/21.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_PromoCategoryCell.h"
#import "coreLib.h"
#import "RH_DiscountActivityTypeModel.h"

@interface RH_PromoCategoryCell()<CLMaskViewDataSource>
@property (nonatomic,strong) IBOutlet CLBorderView *borderView ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@property (nonatomic,strong) RH_DiscountActivityTypeModel *activityTypeModel ;
@end

@implementation RH_PromoCategoryCell
+(CGSize)sizeForViewWithInfo:(NSDictionary *)info containerViewSize:(CGSize)containerViewSize context:(id)context
{
    RH_DiscountActivityTypeModel *discountType = ConvertToClassPointer(RH_DiscountActivityTypeModel, context) ;
    CGSize size = caculaterLabelTextDrawSize(discountType.mActivityTypeName, [UIFont systemFontOfSize:12.0f], containerViewSize.width) ;
    return CGSizeMake(size.width + 20 ,30) ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = [UIFont systemFontOfSize:12.0f]    ;
    self.labTitle.textColor =  colorWithRGB(60, 60, 60) ;
    self.selectionOption = CLSelectionOptionNone ;
    self.borderMask = CLBorderMarkNone ;
    self.borderView.layer.cornerRadius = 5.0f ;
    self.borderView.backgroundColor = colorWithRGB(227, 227, 226) ;
    self.labTitle.textColor = colorWithRGB(60, 60, 60) ;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated] ;
    self.borderView.backgroundColor = selected?colorWithRGB(68, 172, 190):colorWithRGB(227, 227, 226) ;
    self.labTitle.textColor = selected?colorWithRGB(255, 255, 255):colorWithRGB(60, 60, 60) ;
}

-(void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO] ;
}


-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.activityTypeModel = ConvertToClassPointer(RH_DiscountActivityTypeModel, context) ;
    self.labTitle.text = self.activityTypeModel.mActivityTypeName ;
}

@end
