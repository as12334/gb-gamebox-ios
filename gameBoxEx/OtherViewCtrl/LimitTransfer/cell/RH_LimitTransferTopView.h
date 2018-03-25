//
//  RH_LimitTransferTopView.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RH_LimitTransferTopViewDelegate

- (void)RH_LimitTransferTopViewMineWalletDidTaped;
- (void)RH_LimitTransferTopViewTransforToDidTaped;
@end

@interface RH_LimitTransferTopView : UIView
@property (nonatomic, weak) id<RH_LimitTransferTopViewDelegate> delegate;
@end
