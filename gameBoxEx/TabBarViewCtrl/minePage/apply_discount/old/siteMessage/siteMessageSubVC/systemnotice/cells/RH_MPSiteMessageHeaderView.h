//
//  RH_MPSiteMessageHeaderView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_MPSiteMessageHeaderView;
@protocol MPSiteMessageHeaderViewDelegate<NSObject>
@optional
-(void)siteMessageHeaderViewDeleteCell:(RH_MPSiteMessageHeaderView*)view;
-(void)siteMessageHeaderViewAllChoseBtn:(BOOL)choseMark;
-(void)siteMessageHeaderViewReadBtn:(RH_MPSiteMessageHeaderView *)view;
@end
@interface RH_MPSiteMessageHeaderView : UIView
@property(nonatomic,weak)id<MPSiteMessageHeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *allChoseBtn;
@property (weak, nonatomic) IBOutlet UIButton *readConfigeBtn;
@end
