//
//  RH_ApplyDiscountSitePageCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_DiscountActivityTypeModel.h"
#import "RH_ApplyDiscountSiteSendCell.h"
@interface RH_ApplyDiscountSitePageCell : CLScrollContentPageCell
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context andSelectedIndex:(NSInteger)selectedIndex;
@property(nonatomic,strong) UILabel *sysBadge;
@property(nonatomic,strong)RH_ApplyDiscountSiteSendCell* siteSendCell;
@end
