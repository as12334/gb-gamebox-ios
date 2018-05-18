//
//  RH_SiteMyMessageModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#define RHNT_AlreadyReadStatusChangeNotificationSiteMineMessage @"ChangeNotificationSiteMineMessage"
@interface RH_SiteMyMessageModel : RH_BasicModel
@property(nonatomic,strong,readonly)NSString   *mAdvisoryContent; //内容
@property(nonatomic,strong,readonly)NSDate     *mAdvisoryTime;  //时间
@property(nonatomic,strong,readonly)NSString   *mAdvisoryTitle; //标题
@property(nonatomic,assign,readonly)NSInteger  mId; //主键
@property(nonatomic,strong,readonly)NSString   *mReplyTitle;  //回复标题
@property(nonatomic,assign,readonly)BOOL       mIsRead;

//---extend
@property(nonatomic,readonly,assign)  BOOL selectedFlag ;
-(void)updateSelectedFlag:(BOOL)bFlag ; //更新是否勾选状态
-(void)updataReadStatus:(BOOL)bflag ; //更新是否已读
@end
