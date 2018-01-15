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
@end


@implementation RH_PromoTableCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40.0f ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    
}

@end
