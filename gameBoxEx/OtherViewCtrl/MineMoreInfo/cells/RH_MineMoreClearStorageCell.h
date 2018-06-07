//
//  RH_MineMoreClearStorageCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
typedef void (^clearStorageBlock)();
@interface RH_MineMoreClearStorageCell : CLTableViewCell
@property(nonatomic,copy)clearStorageBlock block;
@end
