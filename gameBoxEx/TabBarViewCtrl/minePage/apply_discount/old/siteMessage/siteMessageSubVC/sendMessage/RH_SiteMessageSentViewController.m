//
//  RH_SiteMessageSentViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteMessageSentViewController.h"
#import "RH_SiteSendMessageView.h"
#import "RH_SiteSendMessagePullDownView.h"
#import "RH_ServiceRequest.h"
#import "RH_SendMessageVerityModel.h"
@interface RH_SiteMessageSentViewController ()<RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)RH_SiteSendMessageView *sendView;
@property(nonatomic,strong,readonly)RH_SiteSendMessagePullDownView *listView;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@end

@implementation RH_SiteMessageSentViewController
@synthesize sendView = _sendView;
@synthesize listView = _listView;
@synthesize serviceRequest = _serviceRequest;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.hidden = YES;
}
-(RH_SiteSendMessageView *)sendView
{
    if (!_sendView) {
        _sendView = [RH_SiteSendMessageView createInstance];
        _sendView.frame = CGRectMake(0,0, self.view.frameWidth, self.view.frameHeigh);
    }
    return _sendView;
}
-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest  =[[RH_ServiceRequest alloc]init];
        _serviceRequest.delegate = self;
    }
    return _serviceRequest;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.sendView];
    __block RH_SiteMessageSentViewController *weakSelf = self;
    self.sendView.block = ^(CGRect frame){
        [weakSelf selectedSendViewdiscountType:frame];
    };
    self.needObserverTapGesture = YES ;
    [self.serviceRequest startV3AddApplyDiscountsVerify];
}
#pragma mark 下拉列表
#pragma mark 点击headerview的游戏类型
-(RH_SiteSendMessagePullDownView *)listView
{
    if (!_listView) {
        _listView = [[RH_SiteSendMessagePullDownView alloc]init];
        __block RH_SiteMessageSentViewController *weakSelf = self;
        _listView.block = ^(){
            if (weakSelf.listView.superview){
                [UIView animateWithDuration:0.2f animations:^{
                    CGRect framee = weakSelf.listView.frame;
                    framee.size.height = 0;
                    weakSelf.listView.frame = framee;
                } completion:^(BOOL finished) {
                    [weakSelf.listView removeFromSuperview];
                }];
                weakSelf.sendView.typeLabel.text = weakSelf.listView.gameTypeString;
            }
        };
    }
    return _listView;
}
#pragma mark- observer Touch gesture
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.listView.superview?YES:NO ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (self.listView.superview){
        [UIView animateWithDuration:0.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }
}
-(void)selectedSendViewdiscountType:(CGRect )frame
{
    if (!self.listView.superview) {
        frame.origin.y +=frame.size.width;
        frame.size.width+=20;
        self.listView.frame = frame;
        [self.view addSubview:self.listView];
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 200;
            self.listView.frame = framee;
        }];
    }
    else
    {
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 0;
            self.listView.frame = framee;
        } completion:^(BOOL finished) {
            [self.listView removeFromSuperview];
        }];
    }
}
#pragma mark 数据请求

#pragma mark-
-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"您暂无相关数据记录"] ;
    return YES ;
    
}
#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}
//#pragma mark- 请求回调
//-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
//{
//    [self.serviceRequest startV3AddApplyDiscountsVerify];
//}
//-(void)cancelLoadDataHandle
//{
//    [self.serviceRequest cancleAllServices] ;
//}
//
//#pragma mark-
//- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
//{
//    [self startUpdateData] ;
//}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3AddApplyDiscountsVerify){
    
        RH_SendMessageVerityModel *sendModel = ConvertToClassPointer(RH_SendMessageVerityModel, data);
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3AddApplyDiscountsVerify){
        [self loadDataFailWithError:error] ;
    }
}

@end
