//
//  RH_GameListContentPageCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_LotteryAPIInfoModel.h"

@interface RH_GameListContentPageCell : RH_PageLoadContentPageCell
-(void)updateViewWithType:(NSDictionary*)typeModel
               SearchName:(NSString*)searchName
             APIInfoModel:(RH_LotteryAPIInfoModel*)lotteryApiInfo
                  Context:(CLPageLoadDatasContext*)context ;

@end
