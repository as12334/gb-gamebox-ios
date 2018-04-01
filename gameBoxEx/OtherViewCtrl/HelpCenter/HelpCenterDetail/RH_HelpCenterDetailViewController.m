

//
//  RH_HelpCenterDetailViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_HelpCenterDetailViewController.h"
#import "RH_HelpCenterSecondModel.h"  //传值model

#import "RH_HelpCenterDetailViewCell.h"
#import "RH_HelpCenterDetailModel.h"
#import "coreLib.h"


@interface RH_HelpCenterDetailViewController ()<helpCenterDetailViewCellDelegate>
{
    RH_HelpCenterSecondModel *_helpCenterScondModel ;
}

@end

@implementation RH_HelpCenterDetailViewController


-(void)setupViewContext:(id)context
{
    _helpCenterScondModel = ConvertToClassPointer(RH_HelpCenterSecondModel, context) ;
}

-(BOOL)isSubViewController
{
    return YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _helpCenterScondModel.mName ;
    [self setupInfo];
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
    
}

- (void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO];
    self.contentTableView.sectionHeaderHeight = 9.0f ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    
    [self.contentTableView registerCellWithClass:[RH_HelpCenterDetailViewCell class]] ;
    [self.contentView addSubview:self.contentTableView];
    [self setupPageLoadManager] ;
}

+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] ){
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            if ([THEMEV3 isEqualToString:@"green"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                navigationBar.barTintColor = ColorWithNumberRGB(0x1766bb) ;
            }else{
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor ;
            }
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            if ([THEMEV3 isEqualToString:@"green"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Green ;
            }else if ([THEMEV3 isEqualToString:@"red"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Red ;
            }else if ([THEMEV3 isEqualToString:@"black"]){
                backgroundView.backgroundColor = ColorWithNumberRGB(0x1766bb) ;
            }else{
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
            }
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBar_TitleFontSize,
                                              NSForegroundColorAttributeName:RH_NavigationBar_ForegroundColor} ;
    }else{
        navigationBar.barStyle = UIBarStyleDefault ;
        if (GreaterThanIOS11System){
            navigationBar.barTintColor = [UIColor blackColor];
        }else
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
            [navigationBar insertSubview:backgroundView atIndex:0] ;
            backgroundView.backgroundColor = [UIColor blackColor] ;
        }
        
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }
}


-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:nil
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1] ;
}

-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"您暂无相关数据"] ;
    return YES ;
    
}

#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}
-(NSUInteger)defaultPageSize
{
    CGFloat contentHeigh =  self.contentTableView.frameHeigh - self.contentTableView.contentInset.top - self.contentTableView.contentInset.bottom ;
    CGFloat cellHeigh = [RH_HelpCenterDetailViewCell heightForCellWithInfo:nil tableView:nil context:nil] ;
    return floorf(contentHeigh/cellHeigh) ;
    
}


#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3HelpDetailTypeWithSearchId:_helpCenterScondModel.mId] ;
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
    if (type == ServiceRequestTypeV3HelpDetail) {
        NSArray *dataArr = ConvertToClassPointer(NSArray, data) ;
        [self loadDataSuccessWithDatas:dataArr?dataArr:nil
                            totalCount:dataArr?dataArr.count:1] ;
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3HelpDetail) {
        [self loadDataFailWithError:error] ;
    }
}

#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.pageLoadManager.currentDataCount) ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
         return [RH_HelpCenterDetailViewCell heightForCellWithInfo:nil tableView:tableView context:[self.pageLoadManager dataAtIndexPath:indexPath]] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_HelpCenterDetailViewCell *helpCenterCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_HelpCenterDetailViewCell defaultReuseIdentifier]] ;
        [helpCenterCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
        helpCenterCell.delegate = self ;
        if (indexPath.row == 0) {
            helpCenterCell.isOpen = NO ;
        }else
        {
            helpCenterCell.isOpen = YES ;
        }
        return helpCenterCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
    }
}
#pragma mark - helpCenterDetailViewCellDelegate
-(void)helpCenterDetailViewCellDidTouchTitleBtn:(RH_HelpCenterDetailViewCell *)helpCenterDetailViewCell
{
    
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
