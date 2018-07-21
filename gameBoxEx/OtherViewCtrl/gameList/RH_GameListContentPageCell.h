//
//  RH_GameListContentPageCell.h
//  gameBoxEx
//
//  Created by Lenny on 2018/1/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_LotteryAPIInfoModel.h"
#import "RH_LotteryInfoModel.h"

@class RH_GameListContentPageCell ;
@protocol GameListContentPageCellProtocol
-(void)gameListContentPageCellDidTouchCell:(RH_GameListContentPageCell*)gameListContentPageCell CellModel:(RH_LotteryInfoModel*)lotteryInfoModel ;
@end

@interface RH_GameListContentPageCell : RH_PageLoadContentPageCell
@property (nonatomic,weak) id<GameListContentPageCellProtocol> delegate ;

-(void)updateViewWithType:(NSDictionary*)typeModel
               SearchName:(NSString*)searchName
             APIInfoModel:(RH_LotteryAPIInfoModel*)lotteryApiInfo
                  Context:(CLPageLoadDatasContext*)context ;

@end
