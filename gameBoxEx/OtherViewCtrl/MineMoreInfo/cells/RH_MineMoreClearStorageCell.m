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
    //计算缓存
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    CGFloat fileSize=[self folderSizeAtPath:libPath];
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    float mbCache = bytesCache/1000/1000 + fileSize;
    self.detailLabel.text = [NSString stringWithFormat:@"%.2fM",mbCache];
    if ([self.detailLabel.text isEqualToString:@"0.00M"]) {
        self.block();
    }
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
