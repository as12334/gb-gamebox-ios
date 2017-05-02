//
//  CustomVC.h
//  webViewtest
//
//  Created by deve dawoo on 2017/3/25.
//  Copyright © 2017年 牛奶哈哈的小屋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface CustomVC : BaseVC<UIWebViewDelegate>

@property(nonatomic,strong)NSString *url;

@end
