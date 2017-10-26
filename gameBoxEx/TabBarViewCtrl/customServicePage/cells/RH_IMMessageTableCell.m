//
//  RH_IMMessageTableCell.m
//  gameBoxEx
//
//  Created by luis on 2017/10/19.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_IMMessageTableCell.h"
#import "RH_IMMessageModel.h"

@interface RH_IMMessageTableCell()
@property(nonatomic,weak) IBOutlet UILabel *labIMMessage ;
@end

@implementation RH_IMMessageTableCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_IMMessageModel *imModel = ConvertToClassPointer(RH_IMMessageModel, context) ;

    if (imModel){
        if (CGSizeEqualToSize(imModel.showSize, CGSizeZero)){
            imModel.showSize =  caculaterLabelTextDrawSize(imModel.showInfo, [UIFont systemFontOfSize:12.0f],
                                                            tableView.frameWidth-10) ;
        }
    }

    return imModel.showSize.height + 10.0f  ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.labIMMessage.font = [UIFont systemFontOfSize:12.0f] ;
}


-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_IMMessageModel *imModel = ConvertToClassPointer(RH_IMMessageModel, context) ;
    self.labIMMessage.text = imModel.showInfo ;
}

@end
