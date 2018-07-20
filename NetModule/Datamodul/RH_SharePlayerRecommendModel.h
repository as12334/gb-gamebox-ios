//
//  RH_SharePlayerRecommendModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
@interface RH_CommendModel : RH_BasicModel

@end


@interface RH_RemmendModel : RH_BasicModel

//我的奖励次数
@property(nonatomic,strong,readonly)NSString  *mCount ;
// 我分享的好友数
@property(nonatomic,strong,readonly)NSString  *mUser ;
// 我的分享红利
@property(nonatomic,strong,readonly)NSString  *mBonus;
//我的分享奖励
@property(nonatomic,strong,readonly)NSString  *mSingle;
@end

@interface RH_GradientTempArrayListModel : RH_BasicModel

@property(nonatomic,strong,readonly)NSString  *mId ;
// 1以上
@property(nonatomic,strong,readonly)NSString  *mPlayerNum ;
// 百分之多少  后面拼接%
@property(nonatomic,strong,readonly)NSString  *mProportion;

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
//显示分享红利的数据模型
@property(nonatomic,strong,readonly)NSArray<RH_GradientTempArrayListModel *>   * mGradientListModel;
//右边模型数据
@property(nonatomic,strong,readonly)NSArray<RH_CommendModel *> *mCommendModel ;
//分享码
@property(nonatomic,strong,readonly)NSString *mCode;
//如果这个参数有值，表示有单次推荐奖励
@property(nonatomic,strong,readonly)NSString *mTheWay;
//将会获取到的金额值
@property(nonatomic,strong,readonly)NSString *mMoney;
//有红利奖励显示分享红利标志，没有不显示
@property(nonatomic,assign,readonly)BOOL mIsBonus;
//将会获取到的金额值  推荐好友成功注册并存款满${witchWithdraw}元 <br>
// 双方各获${money}元奖励
@property(nonatomic,strong,readonly)NSString *mWitchWithdraw ;

@property(nonatomic,strong,readonly)NSString *mActivityRules;

@end



