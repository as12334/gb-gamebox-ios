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
#import "RH_HomeChildCategoryCell.h"
#import "RH_HomeCategoryItemsCell.h"
#import "RH_HomePageModel.h"
#import "RH_V3SimpleWebViewController.h"
#import "RH_ActivithyView.h"
#import "RH_API.h"


@interface RH_FirstPageViewControllerEx ()<RH_ShowBannerDetailDelegate,HomeCategoryCellDelegate,HomeChildCategoryCellDelegate,ActivithyViewDelegate>
@property (nonatomic,strong,readonly) UILabel *labDomain ;
@property (nonatomic,strong,readonly) RH_DaynamicLabelCell *dynamicLabCell ;
@property (nonatomic,strong,readonly) RH_HomeCategoryCell *homeCategoryCell ;
@property (nonatomic,strong,readonly) RH_HomeChildCategoryCell *homeChildCatetoryCell  ;
@property (nonatomic,strong,readonly) RH_HomeCategoryItemsCell *homeCategoryItemsCell ;
@property (nonatomic,strong,readonly) RH_ActivithyView *activityView ;

//-
@property (nonatomic,strong,readonly) RH_LotteryCategoryModel *selectedCategoryModel ;
@property (nonatomic,strong,readonly) NSArray *currentCategoryItemsList;
@end

@implementation RH_FirstPageViewControllerEx
@synthesize  labDomain = _labDomain                         ;
@synthesize dynamicLabCell = _dynamicLabCell                ;
@synthesize homeCategoryCell = _homeCategoryCell            ;
@synthesize homeChildCatetoryCell = _homeChildCatetoryCell  ;
@synthesize homeCategoryItemsCell = _homeCategoryItemsCell  ;
@synthesize activityView = _activityView                    ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarItem.leftBarButtonItem = self.logoButtonItem      ;
    [self setNeedUpdateView] ;
    [self setupUI] ;
    self.needObserverTapGesture = YES ;
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
}

-(BOOL)hasTopView
{
    return YES ;
}

-(CGFloat)topViewHeight
{
    return 20.0f ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

#pragma mark-
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
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
        _labDomain.textColor = [UIColor whiteColor] ;
        _labDomain.translatesAutoresizingMaskIntoConstraints = NO ;
    }
    
    return _labDomain ;
}

#pragma mark- tap gesture
#pragma mark- observer Touch gesture
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return (self.userInfoView.superview?YES:NO) ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer
{
    [self userInfoButtonItemHandle] ;
}

#pragma mark-
-(void)setupUI
{
    [self.topView addSubview:self.labDomain] ;
    setCenterConstraint(self.labDomain, self.topView) ;
    self.topView.backgroundColor = RH_NavigationBar_BackgroundColor ;
    self.topView.borderMask = CLBorderMarkTop ;
    self.topView.borderColor = colorWithRGB(204, 204, 204) ;
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    [self.contentTableView registerCellWithClass:[RH_BannerViewCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DaynamicLabelCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_HomeCategoryCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_HomeChildCategoryCell class]] ;
    
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

-(void)updateView
{
    if (self.appDelegate.isLogin){
        self.navigationBarItem.rightBarButtonItems = @[self.userInfoButtonItem] ;
    }else{
        self.navigationBarItem.rightBarButtonItems = @[self.signButtonItem,self.loginButtonItem,self.tryLoginButtonItem] ;
    }
}

#pragma mark-
-(RH_DaynamicLabelCell *)dynamicLabCell
{
    if (!_dynamicLabCell){
        _dynamicLabCell = [RH_DaynamicLabelCell createInstance] ;
    }
    return _dynamicLabCell ;
}

#pragma mark- homeCategoryCell-
-(RH_HomeCategoryCell *)homeCategoryCell
{
    if (!_homeCategoryCell){
        _homeCategoryCell = [RH_HomeCategoryCell createInstance] ;
        _homeCategoryCell.delegate = self ;
    }
    
    return _homeCategoryCell ;
}

-(void)homeCategoryCellDidChangedSelectedIndex:(RH_HomeCategoryCell*)homeCategoryCell
{
    [self.contentTableView reloadData] ;
}

#pragma mark -homeChildCatetoryCell
-(RH_HomeChildCategoryCell *)homeChildCatetoryCell
{
    if (!_homeChildCatetoryCell){
        _homeChildCatetoryCell = [RH_HomeChildCategoryCell createInstance] ;
        _homeChildCatetoryCell.delegate = self ;
    }
    return _homeChildCatetoryCell ;
}

-(void)homeChildCategoryCellDidChangedSelectedIndex:(RH_HomeChildCategoryCell*)homeChildCategoryCell
{
    [self.contentTableView reloadData] ;
}


#pragma mark- homeCategoryItemsCell
-(RH_HomeCategoryItemsCell *)homeCategoryItemsCell
{
    if (!_homeCategoryItemsCell){
        _homeCategoryItemsCell = [RH_HomeCategoryItemsCell createInstance] ;
    }
    
    return _homeCategoryItemsCell ;
}

#pragma mark- selectedCategoryModel
-(RH_LotteryCategoryModel *)selectedCategoryModel
{
    RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
    if (homePageModel){
        return [homePageModel.mLotteryCategoryList objectAtIndex:self.homeCategoryCell.selectedIndex] ;
    }
    return nil ;
}

-(NSArray *)currentCategoryItemsList
{
    if (self.selectedCategoryModel.isExistSubCategory){
        NSInteger index = self.homeChildCatetoryCell.selectedIndex ;
        RH_LotteryAPIInfoModel *lotteryApiModel = self.selectedCategoryModel.mSiteApis[index] ;
        return lotteryApiModel.mGameItems ;
    }else{
        return self.selectedCategoryModel.mSiteApis ;
    }
}

#pragma mark-activityView
-(RH_ActivithyView *)activityView
{
    if (!_activityView){
        _activityView = [RH_ActivithyView createInstance] ;
        _activityView.frame = CGRectMake(self.view.frameWidth - activithyViewWidth -10,
                                         self.view.frameHeigh - activithyViewHeigh - TabBarHeight - 10,
                                         activithyViewWidth,
                                         activithyViewHeigh) ;
        _activityView.delegate = self ;
    }
    
    return _activityView ;
}
-(void)activithyViewDidTouchActivityView:(RH_ActivithyView*)activityView
{
    
}

-(void)activithyViewDidTouchCancel:(RH_ActivithyView*)activityView
{
    [self activityViewHide] ;
}

-(void)activityViewShowWith:(RH_ActivityModel*)activityModel
{
    if (self.activityView.superview) return ;
    
    self.activityView.alpha = 0.0 ;
    [self.view addSubview:self.activityView] ;
    [UIView animateWithDuration:1.0f animations:^{
        self.activityView.activityModel = activityModel ;
    } completion:^(BOOL finished) {
        self.activityView.alpha = 1.0f;
    }] ;
}

-(void)activityViewHide{
    if (self.activityView.superview){
        [UIView animateWithDuration:1.0f animations:^{
            [self.activityView removeFromSuperview] ;
        } completion:^(BOOL finished) {
            self.activityView.alpha = 0.0f;
        }] ;
    }
}

#pragma mark- netStatusChangedHandle
-(void)netStatusChangedHandle
{
    if (NetworkAvailable() && [self.pageLoadManager currentDataCount]==0){
        [self startUpdateData] ;
    }
}

#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3HomeInfo] ;
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
    if (type == ServiceRequestTypeV3HomeInfo){
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, data) ;
        [self loadDataSuccessWithDatas:homePageModel?@[homePageModel]:nil
                            totalCount:homePageModel?1:1] ;
        
        if (homePageModel.mActivityInfo){
            [self activityViewShowWith:homePageModel.mActivityInfo] ;
        }else{
            [self activityViewHide] ;
        }
    }else if (type == ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if ([data boolValue]){
                showSuccessMessage(self.view, @"试玩登入成功", nil) ;
                [self.appDelegate updateLoginStatus:true] ;
                
            }else{
                showAlertView(@"试玩登入失败", @"提示信息");
                [self.appDelegate updateLoginStatus:false] ;
            }
        }] ;
    }else if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
            if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
                [self.appDelegate updateLoginStatus:true] ;
            }else{
                [self.appDelegate updateLoginStatus:false] ;
            }
        }] ;
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3HomeInfo){
        [self loadDataFailWithError:error] ;
    }else if (type == ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showAlertView(@"试玩登入失败", @"提示信息");
        }] ;
    }else if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showAlertView(@"自动login失败", @"提示信息");
        }] ;
    }
}

#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MAX(1, self.pageLoadManager.currentDataCount?5:0) ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.pageLoadManager.currentDataCount){
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
        switch (section) {
            case 0: //bannel
                return homePageModel.mBannerList.count?1:0 ;
                break;
            
            case 1: //announcement
                return homePageModel.mAnnouncementList.count?1:0 ;
                break;
            
            case 2: //category
                return homePageModel.mLotteryCategoryList.count?1:0 ;
                break;
           
            case 3: //child category
                {
                    return self.selectedCategoryModel.isExistSubCategory?1:0 ;
                }
                break;
            
            case 4: // categoryitem
            {
                return 1 ;
            }
                break;
            default:
                break;
        }
        
    }else{
        return  1 ;
    }
    
    return  0 ;
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
            return [RH_HomeChildCategoryCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
        }else if (indexPath.section==4){
            return [RH_HomeCategoryItemsCell heightForCellWithInfo:nil tableView:tableView context:self.currentCategoryItemsList];
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
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
        if (indexPath.section==0){
            RH_BannerViewCell *bannerViewCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_BannerViewCell defaultReuseIdentifier]] ;
            bannerViewCell.delegate = self ;
            [bannerViewCell updateCellWithInfo:nil context:homePageModel.mBannerList];
            return bannerViewCell ;
        }else if (indexPath.section==1){
            [self.dynamicLabCell updateCellWithInfo:nil context:homePageModel.showAnnouncementContent];
            return self.dynamicLabCell ;
        }else if (indexPath.section==2){
            [self.homeCategoryCell updateCellWithInfo:nil context:homePageModel] ;
            return self.homeCategoryCell  ;
        }else if (indexPath.section==3){
            [self.homeChildCatetoryCell updateCellWithInfo:nil context:self.selectedCategoryModel.mSiteApis] ;
            return self.homeChildCatetoryCell  ;
        }else if (indexPath.section==4){
            [self.homeCategoryItemsCell updateCellWithInfo:nil context:self.currentCategoryItemsList] ;
            return self.homeCategoryItemsCell  ;
        }
    }else{
        return self.loadingIndicateTableViewCell ;
    }
    
    return nil ;
}

#pragma mark- Banner Cells Delegate
- (void)object:(id)object wantToShowBannerDetail:(id<RH_BannerModelProtocol>)bannerModel
{
    [self showViewController:[RH_V3SimpleWebViewController viewControllerWithContext:bannerModel.contentURL] sender:self] ;
}

@end
