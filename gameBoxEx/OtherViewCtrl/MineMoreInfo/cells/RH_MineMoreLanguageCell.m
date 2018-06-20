//
//  RH_MineMoreLanguageCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineMoreLanguageCell.h"
#import "coreLib.h"
#import "RH_UserInfoManager.h"

@interface RH_MineMoreLanguageCell()
@property (weak, nonatomic) IBOutlet UIImageView *languageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation RH_MineMoreLanguageCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.textColor = colorWithRGB(51, 51, 51) ;
    self.titleLab.font = [UIFont systemFontOfSize:13.0f] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.titleLab.text = info.myTitle ;
    
    CLLanguageOption language =  [RH_UserInfoManager shareUserManager].languageOption ;
    NSString *languageImage = nil ;
    switch (language) {
        case CLLanguageOptionZHhant:
        case CLLanguageOptionZHhans:
        {
            languageImage = @"language_zh" ;
        }
            break;
        
        case CLLanguageOptionEnglish:
        {
            languageImage = @"language_en" ;
        }
            break;
            
        default:
            languageImage = @"language_zh" ;
            break;
    } ;
    
    self.languageImageView.image = ImageWithName(languageImage) ;
}


@end
