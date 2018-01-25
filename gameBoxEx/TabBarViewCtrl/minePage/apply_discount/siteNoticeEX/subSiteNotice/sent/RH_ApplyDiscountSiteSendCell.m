//
//  RH_ApplyDiscountSiteGameCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ApplyDiscountSiteSendCell.h"
#import "RH_SiteSendMessageView.h"
#import "RH_SiteSendMessagePullDownView.h"
#import "RH_ServiceRequest.h"
#import "RH_SendMessageVerityModel.h"
#import "MBProgressHUD.h"
@interface RH_ApplyDiscountSiteSendCell ()<RH_ServiceRequestDelegate,RH_SiteSendMessageViewDelegate>
@property(nonatomic,strong,readonly)RH_SiteSendMessageView *sendView;
@property(nonatomic,strong,readonly)RH_SiteSendMessagePullDownView *listView;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property(nonatomic,strong,readonly)UIScrollView *scrollView;
@property(nonatomic,copy)NSString  *typeStr;
@end
@implementation RH_ApplyDiscountSiteSendCell
{
    BOOL  keyboardMark;
    int   _keyboardHeight;
}
@synthesize sendView = _sendView;
@synthesize listView = _listView;
@synthesize serviceRequest = _serviceRequest;
@synthesize scrollView = _scrollView;

-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.sendView];
    __block RH_ApplyDiscountSiteSendCell *weakSelf = self;
    self.sendView.block = ^(CGRect frame){
        [weakSelf selectedSendViewdiscountType:frame];
    };
    self.sendView.submitBlock = ^(NSString *titleStr,NSString *contentStr,NSString *codeStr){
        [weakSelf.serviceRequest startV3AddApplyDiscountsVerify];
        [weakSelf.serviceRequest startV3AddApplyDiscountsWithAdvisoryType:weakSelf.typeStr advisoryTitle:titleStr advisoryContent:contentStr code:codeStr];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
        }];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
    };
    [self.serviceRequest startV3AddApplyDiscountsVerify];
    CLPageLoadDatasContext *context1 = [[CLPageLoadDatasContext alloc]initWithDatas:nil context:nil];
    [self setupPageLoadManagerWithdatasContext:context1] ;
    [self.loadingIndicateView hiddenView] ;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification
                                                   object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(0, 1000);
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
-(RH_SiteSendMessageView *)sendView
{
    if (!_sendView) {
        _sendView = [RH_SiteSendMessageView createInstance];
        _sendView.frame = CGRectMake(0,0, self.frameWidth, self.frameHeigh);
        _sendView.delegate = self;
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
#pragma mark 下拉列表
#pragma mark 点击headerview的游戏类型
-(RH_SiteSendMessagePullDownView *)listView
{
    if (!_listView) {
        _listView = [[RH_SiteSendMessagePullDownView alloc]init];
        __block RH_ApplyDiscountSiteSendCell *weakSelf = self;
        _listView.block = ^(NSString *typeString,NSString *typeName){
            if (weakSelf.listView.superview){
                [UIView animateWithDuration:0.2f animations:^{
                    CGRect framee = weakSelf.listView.frame;
                    framee.size.height = 0;
                    weakSelf.listView.frame = framee;
                } completion:^(BOOL finished) {
                    [weakSelf.listView removeFromSuperview];
                }];
                weakSelf.sendView.typeLabel.text = typeName;
                weakSelf.typeStr =typeString;
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
        frame.origin.y +=frame.size.height;
        frame.size.width+=20;
        self.listView.frame = frame;
        [self addSubview:self.listView];
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
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self loadDataSuccessWithDatas:@[] totalCount:0 completedBlock:nil] ;
}
#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}
-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3AddApplyDiscountsVerify){
        
        RH_SendMessageVerityModel *sendModel = ConvertToClassPointer(RH_SendMessageVerityModel, data);
        self.listView.sendModel = sendModel;
        self.sendView.sendModel = sendModel;
    }
    else if (type==ServiceRequestTypeV3AddApplyDiscounts)
    {
        [MBProgressHUD hideHUDForView:self animated:YES];
        //发送成功弹出提示框
        UIAlertView *alertView = [UIAlertView alertWithCallBackBlock:nil title:@"消息提交成功" message:nil cancelButtonName:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3AddApplyDiscountsVerify){
        [self loadDataFailWithError:error] ;
    }
    else if (type==ServiceRequestTypeV3AddApplyDiscounts)
    {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self loadDataFailWithError:error] ;
        showErrorMessage(nil, error, @"发送失败");
    }
}
-(void)selectedCodeTextFieldAndChangedKeyboardFrame:(CGRect)frame
{
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 150);
    }];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
}
-(void)keyboardWillHide:(NSNotification *)aNotification
{
    self.scrollView.contentOffset = CGPointMake(0, 0);
}
@end
