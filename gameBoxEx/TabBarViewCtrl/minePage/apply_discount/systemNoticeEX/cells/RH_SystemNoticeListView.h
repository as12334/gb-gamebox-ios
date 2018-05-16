//
//  RH_SystemNoticeListView.h
//  gameBoxEx
//
//  Created by lewis on 2018/1/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SystemNoticeListViewKuaixuanBlock)(NSInteger row);
@interface RH_SystemNoticeListView : UIView
@property(nonatomic,copy)SystemNoticeListViewKuaixuanBlock kuaixuanBlock;
@property(nonatomic,strong)UITableView *tabelView;
@end
