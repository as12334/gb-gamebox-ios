//
//  RH_HomeCategoryItemSubCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/21.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeCategoryItemSubCell.h"
#import "coreLib.h"

@interface RH_HomeCategoryItemSubCell()<CLMaskViewDataSource>
@property (nonatomic,strong) IBOutlet UIImageView *imgIcon ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@end

@implementation RH_HomeCategoryItemSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor] ;
    self.contentView.layer.cornerRadius = 6.0f ;
    self.contentView.layer.masksToBounds = YES ;
    
    self.labTitle.font = [UIFont systemFontOfSize:12.0f]    ;
    self.labTitle.textColor =  RH_Label_DefaultTextColor ;
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
}

-(UIView *)showSelectionView
{
    return self.contentView ;
}

-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    NSIndexPath *indexPath = ConvertToClassPointer(NSIndexPath, context) ;
    self.labTitle.text = [NSString stringWithFormat:@"AG %ld.%ld",indexPath.section,indexPath.item] ;
}

@end
