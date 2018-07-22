//
//  RH_MineMoreClearStorageCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MineMoreClearStorageCell.h"
#import "coreLib.h"
#import "CLDocumentCachePool.h"
#import "SDImageCache.h"
@interface RH_MineMoreClearStorageCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end

//CGFloat fileSize=[self folderSizeAtPath:libPath];
@implementation RH_MineMoreClearStorageCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = colorWithRGB(51, 51, 51) ;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f] ;
    self.detailLabel.textColor = colorWithRGB(51, 51, 51) ;
    self.detailLabel.font = [UIFont systemFontOfSize:13.0f] ;
    
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
   
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    CGFloat mbCache = [ConvertToClassPointer(NSNumber, context) floatValue];
    self.detailLabel.text = [NSString stringWithFormat:@"%.2fM",mbCache];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
