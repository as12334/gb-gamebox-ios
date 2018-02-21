//
//  RH_ AwardRuleCollectionViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/13.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AwardRuleCollectionPageCell.h"
#import "RH_RewardRuleTableViewCell.h"
#import "RH_RewardRuleBottomViewCell.h"
#import "RH_ServiceRequest.h"
#import "RH_SharePlayerRecommendModel.h"

@interface RH_AwardRuleCollectionPageCell ()<UITableViewDelegate,UITableViewDataSource,RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property(nonatomic,strong)RH_SharePlayerRecommendModel *model ;
@end

@implementation RH_AwardRuleCollectionPageCell
@synthesize serviceRequest = _serviceRequest ;
-(void)updateViewWithType:(RH_SharePlayerRecommendModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    if (self.contentTableView == nil) {
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.sectionFooterHeight = 10.0f;
        self.contentTableView.sectionHeaderHeight = 10.0f ;
        self.contentTableView.backgroundColor = colorWithRGB(242, 242, 242);
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        [self.contentTableView registerCellWithClass:[RH_RewardRuleTableViewCell class]] ;
        [self.contentTableView registerCellWithClass:[RH_RewardRuleBottomViewCell class]];
        self.contentScrollView = self.contentTableView;
        CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc] initWithDatas:nil context:nil];
        [self setupPageLoadManagerWithdatasContext:context1] ;        
    }else {
        [self updateWithContext:context];
    }
}
-(RH_SharePlayerRecommendModel *)model
{
    if (!_model) {
        _model = [[RH_SharePlayerRecommendModel alloc] init ];
    }
    return _model ;
}

-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc]init];
        _serviceRequest.delegate = self;
    }
    return _serviceRequest;
}

#pragma mark -
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3LoadSharePlayerRecommendStartTime:nil endTime:nil] ;
   
}

-(void)cancelLoadDataHandle
{
     [self.serviceRequest cancleAllServices] ;
}
#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3SharePlayerRecommend)
    {
        _model = ConvertToClassPointer(RH_SharePlayerRecommendModel, data);
        [self loadDataSuccessWithDatas:_model.mGradientListModel
                            totalCount:_model.mGradientListModel.count
                        completedBlock:nil];
    }
}


- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type==ServiceRequestTypeV3SharePlayerRecommend )
    {
        [self loadDataFailWithError:error] ;
    }
}

#pragma mark-tableView


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_model.mIsBonus) {
        return 2;
    }
    return 1 ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        if (_model.mIsBonus) {
             return MAX(1, self.pageLoadManager.currentDataCount) ;
        }
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_model.mIsBonus) {
              return  160.f ;
        }else{
            return  50.f;
        }
    }else if (indexPath.section ==1){
        if (_model.mIsBonus ) {
            return 30.f ;
        }else{
            return 0;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RH_RewardRuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_RewardRuleTableViewCell defaultReuseIdentifier]] ;
        [cell updateCellWithInfo:nil context:_model] ;
        return cell ;
    }else if(indexPath.section == 1){
        if (self.pageLoadManager.currentDataCount){
            if (_model.mIsBonus) {
                RH_RewardRuleBottomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_RewardRuleBottomViewCell defaultReuseIdentifier]] ;
                [self bringSubviewToFront:cell];
                [cell updateCellWithInfo:nil context:(RH_GradientTempArrayListModel *)_model.mGradientListModel] ;
                return cell ;
            }
        }else
        {
            return self.loadingIndicateView ;
        }
       
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}






@end
