//
//  RH_CapitalPulldownListView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CapitalPulldownListViewBlock)(NSString *str);
@interface RH_CapitalPulldownListView : UIView
@property (nonatomic,copy)CapitalPulldownListViewBlock block;
@end
