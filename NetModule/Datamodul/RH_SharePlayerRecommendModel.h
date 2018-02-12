//
//  RH_SharePlayerRecommendModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
@interface RH_RemmendModel : RH_BasicModel

//获取奖励次数
@property(nonatomic,assign,readonly)NSInteger  mCount ;
//分享好有数量
@property(nonatomic,assign,readonly)NSInteger  mUser ;
@end

@interface RH_SharePlayerRecommendModel : RH_BasicModel
/**
 //满足存款条件后谁获利：1 表示双方获取奖励 2表示你将会得到 其他表示你推荐的好友会获取到
 */
@property(nonatomic,strong,readonly)NSString *mReward;
//"￥
@property(nonatomic,strong,readonly)NSString *mSigin;//查询推荐人数 获取奖励 红利
//查询推荐人数 获取奖励 红利
@property(nonatomic,strong,readonly)RH_RemmendModel *mRemmendModel;
//分享码
@property(nonatomic,strong,readonly)NSString *mCode;
//如果这个参数有值，表示有单次推荐奖励
@property(nonatomic,strong,readonly)NSString *mTheWay;
//将会获取到的金额值
@property(nonatomic,strong,readonly)NSString *mMoney;
//有红利奖励显示分享红利标志，没有不显示
@property(nonatomic,strong,readonly)NSString *mBonus;
@end



