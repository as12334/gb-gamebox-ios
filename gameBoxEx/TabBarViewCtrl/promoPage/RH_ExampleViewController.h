//
//  RH_ExampleViewController.h
//  gameBoxEx
//
//  Created by barca on 2018/9/29.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_BasicPageLoadViewController.h"
#import "RH_DiscountActivityTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RH_ExampleViewController : RH_BasicPageLoadViewController
- (void)initWithIndex:(NSInteger)index ActivityTypeModel:(RH_DiscountActivityTypeModel *)activityTypeModel;
@end

NS_ASSUME_NONNULL_END
