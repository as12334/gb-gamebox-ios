//
//  RH_SelectedHelper.h
//  gameBoxEx
//
//  Created by jun on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RH_SelectedHelper : NSObject
@property(nonatomic,assign)NSInteger selectedIndex;
+(instancetype)shared;
@end

NS_ASSUME_NONNULL_END
