//
//  RH_ AwardRuleCollectionViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"
#import "RH_SharePlayerRecommendModel.h"

@interface RH_AwardRuleCollectionViewCell : RH_PageLoadContentPageCell

-(void)updateViewWithType:(RH_SharePlayerRecommendModel*)typeModel  Context:(CLPageLoadDatasContext*)context ;
@end
