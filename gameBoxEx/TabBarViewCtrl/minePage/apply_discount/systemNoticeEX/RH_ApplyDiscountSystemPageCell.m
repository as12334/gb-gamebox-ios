//
//  RH_ApplyDiscountSystemPageCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountSystemPageCell.h"

@implementation RH_ApplyDiscountSystemPageCell
-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    //    self.typeModel = ConvertToClassPointer(RH_DiscountActivityTypeModel, typeModel) ;
    self.backgroundColor = [UIColor redColor];
//    if (self.contentTableView == nil) {
//        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStyleGrouped];
//        self.contentTableView.delegate = self   ;
//        self.contentTableView.dataSource = self ;
//        self.contentTableView.sectionFooterHeight = 10.0f;
//        self.contentTableView.sectionHeaderHeight = 10.0f ;
//        self.contentTableView.backgroundColor = [UIColor clearColor];
//        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
//        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
//
//        [self.contentTableView registerCellWithClass:[RH_MPGameNoticeCell class]] ;
//        self.contentScrollView = self.contentTableView;
//        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
//        [self setupPageLoadManagerWithdatasContext:context1] ;
//
//    }else {
//        [self updateWithContext:context];
//    }
}
@end
