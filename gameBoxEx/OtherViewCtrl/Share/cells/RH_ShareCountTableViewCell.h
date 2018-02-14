//
//  RH_ShareCountTableViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"

@interface RH_ShareCountTableViewCell : CLTableViewCell
//我分享的好友数
@property(nonatomic , strong) UILabel *myShareFriendCountLab ;
//我的分享奖励
@property(nonatomic , strong) UILabel *myShareAwardLab ;
//好友互惠达成数
@property(nonatomic , strong) UILabel *friendReciprocalCountLab ;
//我的分享红利
@property(nonatomic , strong) UILabel *myShareBonusLab ;
@end
