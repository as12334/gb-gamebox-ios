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
#import "RH_BannerViewCell.h"
#import "RH_DaynamicLabelCell.h"
#import "RH_HomeCategoryCell.h"
#import "RH_HomeCategoryItemsCell.h"
#import "RH_API.h"

@interface RH_FirstPageViewControllerEx ()<RH_ShowBannerDetailDelegate>
@property (nonatomic,strong,readonly) UILabel *labDomain ;
@property (nonatomic,strong,readonly) RH_DaynamicLabelCell *dynamicLabCell ;
@property (nonatomic,strong,readonly) RH_HomeCategoryCell *homeCategoryCell ;
@property (nonatomic,strong,readonly) RH_HomeCategoryItemsCell *homeCategoryItemsCell ;

@end

@implementation RH_FirstPageViewControllerEx
@synthesize  labDomain = _labDomain                         ;
@synthesize dynamicLabCell = _dynamicLabCell                ;
@synthesize homeCategoryCell = _homeCategoryCell            ;
@synthesize homeCategoryItemsCell = _homeCategoryItemsCell  ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarItem.leftBarButtonItems = @[self.mainMenuButtonItem,self.logoButtonItem] ;
    self.navigationBarItem.rightBarButtonItems = @[self.signButtonItem,self.loginButtonItem,self.tryLoginButtonItem] ;
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO direction:CWDrawerTransitionDirectionLeft transitionBlock:^{
        [weakSelf mainMenuButtonItemHandle];
    }];
    
    [self setupUI] ;
}

-(BOOL)hasTopView
{
    return YES ;
}

-(CGFloat)topViewHeight
{
    return 20.0f ;
}

#pragma mark-
-(UILabel*)labDomain
{
    if (!_labDomain){
        _labDomain = [[UILabel alloc] init] ;
        if ([self.appDelegate.domain containsString:@"//"]){
            NSArray *tmpArray = [self.appDelegate.domain componentsSeparatedByString:@"//"] ;
            _labDomain.text = [NSString stringWithFormat:@"易记域名:%@",tmpArray.count>1?tmpArray[1]:tmpArray[0]] ;
        }else{
            _labDomain.text = [NSString stringWithFormat:@"易记域名:%@",self.appDelegate.domain] ;
        }
        _labDomain.font = [UIFont systemFontOfSize:12.0f] ;
        _labDomain.textColor = RH_Label_DefaultTextColor ;
        _labDomain.translatesAutoresizingMaskIntoConstraints = NO ;
    }
    
    return _labDomain ;
}

#pragma mark-
-(void)setupUI
{
    [self.topView addSubview:self.labDomain] ;
    setCenterConstraint(self.labDomain, self.topView) ;
    self.topView.backgroundColor = colorWithRGB(226, 226, 226) ;
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    [self.contentTableView registerCellWithClass:[RH_BannerViewCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DaynamicLabelCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_HomeCategoryCell class]] ;
    
    [self.contentView addSubview:self.contentTableView] ;
    self.contentTableView.backgroundColor = RH_View_DefaultBackgroundColor ;
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
-(RH_DaynamicLabelCell *)dynamicLabCell
{
    if (!_dynamicLabCell){
        _dynamicLabCell = [RH_DaynamicLabelCell createInstance] ;
    }
    return _dynamicLabCell ;
}

#pragma mark-
-(RH_HomeCategoryCell *)homeCategoryCell
{
    if (!_homeCategoryCell){
        _homeCategoryCell = [RH_HomeCategoryCell createInstance] ;
    }
    
    return _homeCategoryCell ;
}

#pragma mark-
-(RH_HomeCategoryItemsCell *)homeCategoryItemsCell
{
    if (!_homeCategoryItemsCell){
        _homeCategoryItemsCell = [RH_HomeCategoryItemsCell createInstance] ;
    }
    
    return _homeCategoryItemsCell ;
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
    [self loadDataSuccessWithDatas:@[@"",@"",@"",@""] totalCount:4] ;
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
    if (self.pageLoadManager.currentDataCount){
        if (indexPath.section==0){
            return [RH_BannerViewCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
        }else if (indexPath.section==1){
            return [RH_DaynamicLabelCell heightForCellWithInfo:nil tableView:tableView context:nil];
        }else if (indexPath.section==2){
            return [RH_HomeCategoryCell heightForCellWithInfo:nil tableView:tableView context:nil];
        }else if (indexPath.section==3){
            return [RH_HomeCategoryItemsCell heightForCellWithInfo:nil tableView:tableView context:nil];
        }else{
            return 0.0f ;
        }
    }else{
        return tableView.boundHeigh - tableView.contentInset.top - tableView.contentInset.bottom ;
    }
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        if (indexPath.section==0){
            RH_BannerViewCell *bannerViewCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_BannerViewCell defaultReuseIdentifier]] ;
            bannerViewCell.delegate = self ;
            [bannerViewCell updateCellWithInfo:nil context:@[@"",@""]];
            return bannerViewCell ;
        }else if (indexPath.section==1){
            [self.dynamicLabCell updateCellWithInfo:nil context:nil];
            return self.dynamicLabCell ;
        }else if (indexPath.section==2){
            [self.homeCategoryCell updateCellWithInfo:nil context:nil] ;
            return self.homeCategoryCell  ;
        }else if (indexPath.section==3){
            [self.homeCategoryItemsCell updateCellWithInfo:nil context:nil] ;
            return self.homeCategoryItemsCell  ;
        }
    }else{
        return self.loadingIndicateTableViewCell ;
    }
    
    return nil ;
}

#pragma mark- cells Delegate
- (void)object:(id)object wantToShowBannerDetail:(id<RH_BannerModelProtocol>)bannerModel
{
    NSLog(@"") ;
}

@end
