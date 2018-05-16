//
//  RH_MinePageLoginoutBannarCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
typedef void (^MinePageLoginoutBannarBlock)(void);

@interface RH_MinePageLoginoutBannarCell : CLTableViewCell
@property(nonatomic,copy)MinePageLoginoutBannarBlock block;
@end
