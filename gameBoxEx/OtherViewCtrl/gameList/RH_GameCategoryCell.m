//
//  RH_GameCategoryCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/21.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_GameCategoryCell.h"
#import "coreLib.h"

@interface RH_GameCategoryCell()<CLMaskViewDataSource>
@property (nonatomic,strong) IBOutlet CLBorderView *borderView ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@property (nonatomic,strong) NSDictionary *gamelistTypeModel ;
@end

@implementation RH_GameCategoryCell
+(CGSize)sizeForViewWithInfo:(NSDictionary *)info containerViewSize:(CGSize)containerViewSize context:(id)context
{
    CGSize size = caculaterLabelTextDrawSize([info stringValueForKey:@"value"]?:[info stringValueForKey:@"key"], [UIFont systemFontOfSize:12.0f], containerViewSize.width) ;
    return CGSizeMake(size.width + 20 ,40) ;
}

- (void)setTitleLabelTextColor:(UIColor *)color {
    self.labTitle.textColor = color;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f]    ;
    self.labTitle.textColor =  colorWithRGB(50, 51, 51) ;
    self.selectionOption = CLSelectionOptionNone ;
    self.borderMask = CLBorderMarkNone ;
    self.borderView.layer.cornerRadius = 5.0f ;
    self.borderView.backgroundColor = colorWithRGB(255, 255, 255) ;
    if ([THEMEV3 isEqualToString:@"black"]) {
        self.borderView.backgroundColor = [UIColor clearColor] ;
//        self.labTitle.textColor =  [UIColor whiteColor] ;
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated] ;
//    if (selected){
//        self.sep
//    }
//    self.borderView.backgroundColor = selected?colorWithRGB(49, 126, 194):colorWithRGB(255, 255, 255) ;
//    self.labTitle.textColor = selected?colorWithRGB(252, 252, 252):colorWithRGB(50, 51, 51) ;
}

-(void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO] ;
}

-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.gamelistTypeModel = info ;
    self.labTitle.text = [self.gamelistTypeModel stringValueForKey:@"value"]?:[self.gamelistTypeModel stringValueForKey:@"key"] ;
}

@end
