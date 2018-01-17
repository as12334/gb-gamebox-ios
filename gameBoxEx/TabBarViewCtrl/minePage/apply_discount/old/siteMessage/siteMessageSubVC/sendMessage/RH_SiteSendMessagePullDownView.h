//
//  RH_SiteSendMessagePullDownView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_SendMessageVerityModel.h"
typedef void (^SiteSendMessagePullDownViewBlock)(void);
@interface RH_SiteSendMessagePullDownView : UIView
//@property(nonatomic,strong)NSArray<ApiSelectModel *> *modelArray;
@property(nonatomic,strong)SiteSendMessagePullDownViewBlock block;
@property (nonatomic,copy)NSString *gameTypeString;
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong)NSArray<AdvisoryTypeModel *>*verityModelArray;
@end
