//
//  RH_MPGameNoticePulldownView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_GameNoticeModel.h"
typedef void (^GameNoticePulldownViewBlock)(void);
@interface RH_MPGameNoticePulldownView : UIView
@property(nonatomic,strong)NSArray<ApiSelectModel *> *modelArray;
@property(nonatomic,strong)GameNoticePulldownViewBlock block;
@property (nonatomic,copy)NSString *gameTypeString;
@end
