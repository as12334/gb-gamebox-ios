//
//  RH_ AwardRuleCollectionViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AwardRuleCollectionViewCell.h"
#import "RH_RewardRuleTableViewCell.h"

@interface RH_AwardRuleCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RH_AwardRuleCollectionViewCell
-(void)updateViewWithType:(RH_SharePlayerRecommendModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    if (self.contentTableView == nil) {
        self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width/2., 200) style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.sectionFooterHeight = 10.0f;
        self.contentTableView.sectionHeaderHeight = 10.0f ;
        self.contentTableView.backgroundColor = colorWithRGB(242, 242, 242);
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        [self.contentTableView registerCellWithClass:[RH_RewardRuleTableViewCell class]] ;
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
        [self setupPageLoadManagerWithdatasContext:context1] ;
        
    }else {
        [self updateWithContext:context];
    }
}

#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return [RH_RewardRuleTableViewCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_RewardRuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_RewardRuleTableViewCell defaultReuseIdentifier]] ;
    
    return cell ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}






@end
