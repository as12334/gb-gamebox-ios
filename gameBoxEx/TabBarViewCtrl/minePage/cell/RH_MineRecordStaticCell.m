//
//  RH_MineRecordStaticCell.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineRecordStaticCell.h"
#import "coreLib.h"
#import "RH_SiteMsgUnReadCountModel.h"
@interface RH_MineRecordStaticCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *explainLab;
@property (weak, nonatomic) IBOutlet UIView *readCountMarkView;

@end
@implementation RH_MineRecordStaticCell
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = [UIColor lightGrayColor] ;
    self.selectionColorAlpha = 0.3f ;
    self.titleLab.textColor = colorWithRGB(51, 51, 51);
    self.explainLab.textColor = colorWithRGB(153, 153, 153);
//    if ([THEMEV3 isEqualToString:@"black"]) {
//        self.titleLab.textColor = [UIColor whiteColor];
//        self.explainLab.textColor = colorWithRGB(240, 240, 240);
//        self.backgroundColor = colorWithRGB(37, 37, 37);
//    }
    self.titleLab.font = [UIFont systemFontOfSize:14];
    self.explainLab.font = [UIFont systemFontOfSize:11];
    
    self.cellImageView.whc_TopSpace(15).whc_LeftSpace(22);
    self.titleLab.whc_TopSpaceEqualView(self.cellImageView).whc_LeftSpaceToView(17, self.cellImageView);
    self.explainLab.whc_TopSpaceToView(5, self.titleLab).whc_LeftSpaceEqualView(self.titleLab);
    
    self.readCountMarkView.layer.cornerRadius = 5;
    self.readCountMarkView.layer.masksToBounds = YES;
    self.readCountMarkView.hidden = YES;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.cellImageView.image = info.myImage ;
    self.titleLab.text = info.myTitle ;
    self.explainLab.text = info.myDetailTitle;
    NSLog(@"----%@",info);
    //消息中心提示
//    RH_SiteMsgUnReadCountModel *model = ConvertToClassPointer(RH_SiteMsgUnReadCountModel, context);
//    if ([[info objectForKey:@"title"] isEqualToString:@"消息中心"]&&(model.siteMsgUnReadCount>0||model.sysMsgUnreadCount>0||model.mineMsgUnreadCount>0)) {
//        self.readCountMarkView.hidden = NO;
//    }
//    else
//    {
        self.readCountMarkView.hidden = YES;
//    }
}
@end
