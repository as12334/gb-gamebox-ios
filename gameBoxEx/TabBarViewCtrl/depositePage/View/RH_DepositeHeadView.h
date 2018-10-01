//
//  RH_DepositeHeadView.h
//  gameBoxEx
//
//  Created by jun on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RH_DepositeHeadViewDelegate <NSObject>

-(void)closeBtnClick;

@end
@interface RH_DepositeHeadView : UIView
@property(nonatomic,weak)id<RH_DepositeHeadViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
