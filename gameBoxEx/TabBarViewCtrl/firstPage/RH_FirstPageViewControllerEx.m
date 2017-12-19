//
//  RH_FirstPageViewControllerEx.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_FirstPageViewControllerEx.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"
#import "RH_API.h"

@interface RH_FirstPageViewControllerEx ()
@end

@implementation RH_FirstPageViewControllerEx
//@synthesize loginBarButtonItem = _loginBarButtonItem ;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarItem.leftBarButtonItem = self.loginBarButtonItem ;
    
    [self setupUI] ;
}

#pragma mark-
-(void)setupUI
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
//    [self.contentTableView registerCellWithClass:[RH_BannerViewCell class]] ;
//    [self.contentTableView registerCellWithClass:[RH_LotteryHallViewCell class]] ;
//    [self.contentTableView registerCellWithClass:[RH_DaynamicLabelCell class]] ;
    
    [self.contentView addSubview:self.contentTableView] ;
//    self.contentTableView.backgroundColor = RH_View_DefaultBackgroundColor ;
    [self setupPageLoadManager] ;
}

-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:[CLSectionArrayPageLoadController class]
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1] ;
}

#pragma mark-
//-(UIBarButtonItem*)loginBarButtonItem
//{
//    if (!_loginBarButtonItem){
//        _loginBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登入/注册"
//                                                               style:UIBarButtonItemStyleDone
//                                                              target:self
//                                                              action:@selector(loginBarButtonItemHandke)];
//    }
//
//    return  _loginBarButtonItem ;
//}

-(void)loginBarButtonItemHandke
{
//    [self showViewController:[RH_LoginViewController viewController] sender:self] ;
}

#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}

#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
#if 0
    //    [self.serviceRequest startGetOpenCode:nil isHistory:NO] ;
#else
    [self loadDataSuccessWithDatas:@[@"",@"",@"",@"",@"",@""] totalCount:6] ;
#endif
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    //    if (type == ServiceRequestTypeStaticOpenCode){
    //        NSDictionary *dictTmp = ConvertToClassPointer(NSDictionary, data) ;
    //        [self loadDataSuccessWithDatas:dictTmp.allValues totalCount:dictTmp.allValues.count] ;
    //    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    //    if (type == ServiceRequestTypeStaticOpenCode){
    //        [self loadDataFailWithError:error] ;
    //    }
}

#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.pageLoadManager.currentDataCount){
//        if (indexPath.section==0){
//            return [RH_BannerViewCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
//        }else if (indexPath.section==1){
//            return [RH_DaynamicLabelCell heightForCellWithInfo:nil tableView:tableView context:nil];
//        }else if (indexPath.section>1){
//            return [RH_LotteryHallViewCell heightForCellWithInfo:@{RH_LotteryHall_Expand:[indexPath isEqual:self.expandIndexPath]?@(YES):@(NO),
//                                                                   RH_LotteryHall_ExpandLeft:@(self.expandIndexPathLeft)
//                                                                   }
//                                                       tableView:tableView context:nil] ;
//        }else{
//            return 0.0f ;
//        }
//    }else{
//        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
//    }
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.pageLoadManager.currentDataCount){
//        if (indexPath.section==0){
//            RH_BannerViewCell *bannerViewCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_BannerViewCell defaultReuseIdentifier]] ;
//            bannerViewCell.delegate = self ;
//            [bannerViewCell updateCellWithInfo:nil context:@[@"",@""]];
//            return bannerViewCell ;
//        }else if (indexPath.section==1){
//            RH_DaynamicLabelCell *dynamicLabCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DaynamicLabelCell defaultReuseIdentifier]] ;
//            [dynamicLabCell updateCellWithInfo:nil context:nil] ;
//            return dynamicLabCell ;
//        }else if (indexPath.section>1){
//            RH_LotteryHallViewCell *lotteryHallCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_LotteryHallViewCell defaultReuseIdentifier]] ;
//            lotteryHallCell.delegate = self ;
//            [lotteryHallCell updateCellWithInfo:@{RH_LotteryHall_Expand:[indexPath isEqual:self.expandIndexPath]?@(YES):@(NO),
//                                                  RH_LotteryHall_ExpandLeft:@(self.expandIndexPathLeft)
//                                                  }
//                                        context:nil];
//            return lotteryHallCell ;
//        }
//    }else{
//        return self.loadingIndicateTableViewCell ;
//    }
    
    return nil ;
}

//#pragma mark- cells Delegate
//- (void)object:(id)object wantToShowBannerDetail:(id<RH_BannerModelProtocol>)bannerModel
//{
//    NSLog(@"") ;
//}
//
//-(void)lotteryHallViewCellTouchExpend:(RH_LotteryHallViewCell*)lotteryHallViewCell isLeft:(BOOL)bLeft
//{
//    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:lotteryHallViewCell] ;
//    if ([indexPath isEqual:self.expandIndexPath] && self.expandIndexPathLeft==bLeft){
//        //收起扩展显示
//        self.expandIndexPath = nil ;
//    }else{
//        self.expandIndexPath = indexPath ;
//        self.expandIndexPathLeft = bLeft ;
//    }
//
//    [self.contentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic] ;
//}

@end
