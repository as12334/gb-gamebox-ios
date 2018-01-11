//
//  RH_CapitalPulldownListView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalPulldownListView.h"
#import "RH_ServiceRequest.h"
#import "coreLib.h"
#import "RH_CapitalTypeModel.h"
@interface RH_CapitalPulldownListView()<UITableViewDelegate,UITableViewDataSource,RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property(nonatomic,strong)NSDictionary *dict;
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong)RH_CapitalTypeModel *typeModel;
@end
@implementation RH_CapitalPulldownListView
@synthesize serviceRequest = _serviceRequest;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.serviceRequest startV3DepositPulldownList];
        [self addSubview:self.tabelView];
    }
    return self;
}
-(UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tabelView;
}
-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest){
        _serviceRequest = [[RH_ServiceRequest alloc] init] ;
        _serviceRequest.delegate = self ;
    }
    
    return _serviceRequest ;
}

#pragma mark-
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dict.allValues.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
//    cell.textLabel.text  =  self.dict.allValues[indexPath.item];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
  
    [self.serviceRequest startV3DepositPulldownList] ;
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}
#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3DepositPullDownList){
        self.typeModel = ConvertToClassPointer(RH_CapitalTypeModel, data);
//        RH_CapitalTypeModel dataArrayWithDictInfo:<#(NSDictionary *)#>
        [_tabelView reloadData];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3DepositPullDownList){
        
    }
}
@end
