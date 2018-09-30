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
//缓存数据
@property(nonatomic,copy)NSString  * mbCache;

@property (nonatomic, strong) NSString *title;

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
    NSArray *dataArr = ConvertToClassPointer(NSArray,context) ;
  
    //消息中心提示
    RH_SiteMsgUnReadCountModel *model = ConvertToClassPointer(RH_SiteMsgUnReadCountModel, dataArr[0]);
    self.mbCache = [NSString stringWithFormat:@"%.2f",[dataArr[1] floatValue]] ;
//    if ([[NSString stringWithFormat:@"%ld",(long)model.siteMsgUnReadCount] isEqualToString:@"0"]&&[[NSString stringWithFormat:@"%ld",(long)model.sysMsgUnreadCount] isEqualToString:@"0"]&&[[NSString stringWithFormat:@"%ld",(long)model.mineMsgUnreadCount] isEqualToString:@"0"]) {
//        self.readCountMarkView.hidden = YES;
//        return;
//    }
    self.title = [info objectForKey:@"title"];
    if ([[info objectForKey:@"title"] isEqualToString:@"消息中心"]&&(model.siteMsgUnReadCount>0||[model.sysMsgUnreadCount intValue]>0||[model.mineMsgUnreadCount intValue]>0)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:)name:@"NotUnReadMsg_NT" object:nil];
        self.readCountMarkView.hidden = NO;
    }
    else
    {
        self.readCountMarkView.hidden = YES;
    }
   
   
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"NotUnReadMsg_NT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
////        RH_SiteMsgUnReadCountModel *model = note.object ;
//        self.readCountMarkView.hidden = YES;
//    }];
    
    if ([[info objectForKey:@"code"] isEqualToString:@"cleanCache"])
    {
        [self.titleLab setTextWithFirstString:[NSString stringWithFormat:@"清理缓存(%@M)",self.mbCache] SecondString:[NSString stringWithFormat:@"(%@M)",self.mbCache] FontSize:14.f Color:colorWithRGB(217, 0, 4)] ;
    }
}

-(void)tongzhi:(NSNotification *)notification
{
    if ([notification.userInfo[@"NotUnReadMsg"] isEqualToString:@"YES"]) {
         self.readCountMarkView.hidden = YES;
    }else{
        if ([self.title isEqualToString:@"消息中心"]) {
            self.readCountMarkView.hidden = NO;
        }
        else
        {
            self.readCountMarkView.hidden = YES;
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
