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
#import "MBProgressHUD.h"
@interface RH_CapitalPulldownListView()<UITableViewDelegate,UITableViewDataSource,RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong)RH_CapitalTypeModel *typeModel;
@property(nonatomic,strong,readonly)MBProgressHUD *HUD ;

@end
@implementation RH_CapitalPulldownListView
@synthesize serviceRequest = _serviceRequest;


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.typeNameArray =[NSMutableArray array];
        self.typeIdArray = [NSMutableArray array];
        [self.typeIdArray addObject:@"all"];
        [self.typeNameArray addObject:@"所有"];
        [self.serviceRequest startV3DepositPulldownList];
        self.layer.cornerRadius = 10.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tabelView];
        _HUD = [[MBProgressHUD alloc]initWithFrame:self.bounds];
        _HUD.progress = 0.4;
        [self addSubview:_HUD];
        [_HUD show:YES];
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
    return self.typeNameArray.count ;
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
    cell.textLabel.text  =  self.typeNameArray[indexPath.item];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.typeString = self.typeNameArray[indexPath.item];
    self.block();
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
        for (RH_CapitalTypeModel *tymodel in data) {
            self.typeModel = tymodel;
            [self.typeNameArray addObject:self.typeModel.mTypeName];
            [self.typeIdArray addObject:self.typeModel.mTypeId];
        }
        [self.tabelView reloadData];
        [self.HUD hide:YES];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3DepositPullDownList){
//        [self.activityIndicator stopAnimating];
        self.HUD.labelColor = [UIColor whiteColor];
        self.HUD.labelFont = [UIFont systemFontOfSize:13];
        self.HUD.labelText = @"数据加载失败";
        [self.HUD hide:YES afterDelay:1];
    }
}


@end
