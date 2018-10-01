//
//  RH_MineHeaderView.h
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RH_MineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *logonTime_label;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount_label;
@property (weak, nonatomic) IBOutlet UILabel *balance_label;
@property (weak, nonatomic) IBOutlet UILabel *userName_label;

@end

NS_ASSUME_NONNULL_END
