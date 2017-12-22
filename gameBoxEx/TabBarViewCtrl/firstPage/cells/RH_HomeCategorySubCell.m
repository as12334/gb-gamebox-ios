//
//  RH_HomeCategorySubCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/21.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeCategorySubCell.h"
#import "coreLib.h"

@interface RH_HomeCategorySubCell()<CLMaskViewDataSource>
@property (nonatomic,strong) IBOutlet UIImageView *imgIcon ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@end

@implementation RH_HomeCategorySubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.labTitle.font = [UIFont systemFontOfSize:12.0f]    ;
    self.labTitle.textColor =  RH_Label_DefaultTextColor ;
    
    self.selectionOption = CLSelectionOptionSelected|CLSelectionOptionHighlighted ;
    self.selectionColor = [UIColor whiteColor] ;
}

-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.labTitle.text = @"捕鱼游戏" ;
}

@end
