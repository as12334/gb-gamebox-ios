//
//  RH_TypeSelectView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RH_TypeSelectView;
@class RH_LotteryCategoryModel;
@protocol RH_TypeSelectViewDelegate

@required
- (void)typeSelectView:(RH_TypeSelectView *)view didSelect:(NSInteger)index;

@end

@interface RH_TypeSelectView : UIView

@property (nonatomic, strong) RH_LotteryCategoryModel *categoryModel;
@property (nonatomic, weak) id <RH_TypeSelectViewDelegate> delegate;

@end
