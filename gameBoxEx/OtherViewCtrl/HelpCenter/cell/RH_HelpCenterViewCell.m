//
//  RH_HelpCenterViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_HelpCenterViewCell.h"
#import "RH_HelpCenterModel.h"
#import "coreLib.h"

@implementation RH_HelpCenterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40.f;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imageView = [UIImageView new] ;
        [self.contentView addSubview:imageView];
        imageView.whc_CenterY(0).whc_RightSpace(10).whc_WidthAuto().whc_HeightAuto() ;
        imageView.image = ImageWithName(@"more_next_icon") ;
        self.textLabel.textColor = colorWithRGB(51, 51, 51) ;
        self.textLabel.font = [UIFont systemFontOfSize:13.0f] ;
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0) ;
        self.separatorLineColor = RH_Line_DefaultColor ;
        self.selectionOption = CLSelectionOptionHighlighted ;
        self.selectionColor = RH_Cell_DefaultHolderColor ;
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_HelpCenterModel *model  = ConvertToClassPointer(RH_HelpCenterModel, context) ;
    self.textLabel.text  = model.mName ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
