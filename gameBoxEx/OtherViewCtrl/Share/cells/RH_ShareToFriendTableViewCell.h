//
//  RH_ShareToFriendTableViewCell.h
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
@class RH_ShareToFriendTableViewCell;
@protocol RH_ShareToFriendTableViewCellDelegate <NSObject>
@optional
-(void)shareToFriendTableViewCellDidTouchCopyButton:(RH_ShareToFriendTableViewCell*)shareToFriendTableViewCell ;

@end
@interface RH_ShareToFriendTableViewCell : CLTableViewCell
@property(nonatomic,weak) id<RH_ShareToFriendTableViewCellDelegate> delegate ;
@end
