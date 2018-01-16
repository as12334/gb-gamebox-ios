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
@interface RH_SiteMessageSentViewController ()
@property(nonatomic,strong,readonly)RH_SiteSendMessageView *sendView;
@property(nonatomic,strong,readonly)RH_SiteSendMessagePullDownView *listView;
@end

@implementation RH_SiteMessageSentViewController
@synthesize sendView = _sendView;
@synthesize listView = _listView;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.sendView];
    __block RH_SiteMessageSentViewController *weakSelf = self;
    self.sendView.block = ^(CGRect frame){
        [weakSelf selectedSendViewdiscountType:frame];
    };
    self.needObserverTapGesture = YES ;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
