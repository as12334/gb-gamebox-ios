//
//  RH_FundsFooterView.h
//  gameBoxEx
//
//  Created by jun on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RH_FundsFooterViewDelegate <NSObject>
//tag = 0就是一键刷新 1为一键回收
-(void)oneKeyRefreshOrRecoveryByTag:(NSInteger)tag;
@end
@interface RH_FundsFooterView : UIView
@property(nonatomic,weak)id<RH_FundsFooterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
