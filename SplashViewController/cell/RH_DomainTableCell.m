//
//  RH_DomainTableCell.m
//  gameBoxEx
//
//  Created by luis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DomainTableCell.h"

@interface RH_DomainTableCell()
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@property (nonatomic,strong) IBOutlet UILabel *labDesc ;
@end

@implementation RH_DomainTableCell

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 20.0f ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor] ;
    self.contentView.backgroundColor = [UIColor clearColor] ;
    
    self.labTitle.font = [UIFont systemFontOfSize:13.0f] ;
    self.labDesc.font = [UIFont systemFontOfSize:13.0f] ;
    self.labTitle.textColor = [UIColor whiteColor] ;
    self.labDesc.textColor = [UIColor whiteColor] ;
}


-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.labTitle.text = info.myTitle ;
    self.labDesc.text = info.myDetailTitle ;
}
@end
