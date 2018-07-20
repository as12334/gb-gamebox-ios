//
//  RH_StartPageADView.h
//  gameBoxEx
//
//  Created by shin on 2018/6/20.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GBShowADViewComplete)(void);

@interface RH_StartPageADView : UIView

@property (nonatomic, strong) NSString *adImageUrl;

- (void)show:(GBShowADViewComplete)complete;

@end
