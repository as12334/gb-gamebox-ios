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
#import "RH_LoadingIndicateTableViewCell.h"
#define NSNotiCenterSubmitSuccessNT  @"NSNotiCenterSubmitSuccess"
@interface RH_ApplyDiscountSiteSendCell ()<RH_ServiceRequestDelegate,RH_SiteSendMessageViewDelegate>
@property(nonatomic,strong,readonly)RH_SiteSendMessageView *sendView;
@property(nonatomic,strong,readonly)RH_SiteSendMessagePullDownView *listView;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@property(nonatomic,strong,readonly) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@property(nonatomic,copy)NSString  *typeStr;
@property(nonatomic,strong)RH_SendMessageVerityModel *sendMessageVerityModel;
@end
@implementation RH_ApplyDiscountSiteSendCell
{
    BOOL  keyboardMark;
    int   _keyboardHeight;
}
@synthesize sendView = _sendView;
@synthesize listView = _listView;
@synthesize serviceRequest = _serviceRequest;

@synthesize loadingIndicateTableViewCell = _loadingIndicateTableViewCell ;

-(void)updateViewWithType:(RH_DiscountActivityTypeModel*)typeModel  Context:(CLPageLoadDatasContext*)context
{
    [self.serviceRequest startV3AddApplyDiscountsVerify];
    __block RH_ApplyDiscountSiteSendCell *weakSelf = self;
    self.sendView.block = ^(CGRect frame){
        [weakSelf selectedSendViewdiscountType:frame];
    };
    self.sendView.submitBlock = ^(NSString *titleStr,NSString *contentStr,NSString *codeStr){
        if (weakSelf.typeStr==nil) {
            showMessage(weakSelf,@"发送失败", @"请选择问题类型");
        }
        else if (titleStr.length<4 || titleStr.length > 10) {
            showMessage(weakSelf,@"发送失败", @"标题在4-10个字");
        }
        else if (contentStr.length<10||contentStr.length>2000){
            showMessage(weakSelf, @"发送失败",@"内容在10个字以上2000字以内");
        }else if (self.sendMessageVerityModel.mIsOpenCaptcha == YES)
        {
           if([codeStr isEqualToString:@""])
            {
                showMessage(weakSelf,@"发送失败", @"请输入验证码");
            }
            else if (codeStr.length != 4)
            {
                showMessage(weakSelf,@"发送失败", @"请输入正确格式的验证码");
            }else
            {
                [weakSelf.serviceRequest startV3AddApplyDiscountsVerify];
                [weakSelf.serviceRequest startV3AddApplyDiscountsWithAdvisoryType:weakSelf.typeStr advisoryTitle:titleStr advisoryContent:contentStr code:codeStr];
                [UIView animateWithDuration:0.5 animations:^{
                    weakSelf.contentScrollView.contentOffset = CGPointMake(0, 0);
                }];
                [MBProgressHUD showHUDAddedTo:weakSelf animated:YES];
            }
        }
        else{
            [weakSelf.serviceRequest startV3AddApplyDiscountsVerify];
            [weakSelf.serviceRequest startV3AddApplyDiscountsWithAdvisoryType:weakSelf.typeStr advisoryTitle:titleStr advisoryContent:contentStr code:codeStr];
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.contentScrollView.contentOffset = CGPointMake(0, 0);
            }];
            [MBProgressHUD showHUDAddedTo:weakSelf animated:YES];
        }
    };
    if (self.contentTableView == nil) {
        self.contentTableView = [[UITableView alloc] initWithFrame:self.myContentView.bounds style:UITableViewStylePlain];
        self.contentTableView.delegate = self   ;
        self.contentTableView.dataSource = self ;
        self.contentTableView.sectionFooterHeight = 10.0f;
        self.contentTableView.sectionHeaderHeight = 10.0f ;
        self.contentTableView.backgroundColor = [UIColor clearColor];
        self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.myContentView.frameWidth, 0.1f)] ;
        self.contentScrollView = self.contentTableView;
        self.contentTableView.tableHeaderView = self.sendView ;
    }
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
-(RH_SiteSendMessageView *)sendView
{
    if (!_sendView) {
        _sendView = [RH_SiteSendMessageView createInstance];
        _sendView.frame = CGRectMake(0,50, self.frameWidth, self.frameHeigh);
        _sendView.delegate = self;
        _sendView.userInteractionEnabled = YES ;
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


-(void)selectedSendViewdiscountType:(CGRect )frame
{
    if (!self.listView.superview) {
        frame.origin.y +=frame.size.height;
        frame.size.width+=20;
        self.listView.frame = frame;
        [self addSubview:self.listView];
        [UIView animateWithDuration:.2f animations:^{
            CGRect framee = self.listView.frame;
            framee.size.height = 160;
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
        self.sendMessageVerityModel = sendModel;
    }
    else if (type==ServiceRequestTypeV3AddApplyDiscounts)
    {
        [MBProgressHUD hideHUDForView:self animated:YES];
        //发送成功弹出提示框
        showMessage(self, @"提示", @"消息提交成功！") ;
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotiCenterSubmitSuccessNT object:nil];
        self.sendView.typeLabel.text = @"请选择";
        self.typeStr =nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

-(void)siteSendMessageViewDidTouchCancelBtn:(RH_SiteSendMessageView *)siteSendMessageView
{
    self.typeStr = nil ;
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3AddApplyDiscountsVerify){
        showErrorMessage(nil, error, nil) ;
    }
    else if (type==ServiceRequestTypeV3AddApplyDiscounts)
    {
        [MBProgressHUD hideHUDForView:self animated:YES];
        showErrorMessage(nil, error, @"发送失败");
    }
}
-(void)selectedCodeTextFieldAndChangedKeyboardFrame:(CGRect)frame
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentScrollView.contentOffset = CGPointMake(0, 150);
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
    self.contentScrollView.contentOffset = CGPointMake(0, 0);
}


@end
