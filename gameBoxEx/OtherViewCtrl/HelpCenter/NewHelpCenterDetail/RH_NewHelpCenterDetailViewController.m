//
//  RH_NewHelpCenterDetailViewController.m
//  gameBoxEx
//
//  Created by richard on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_NewHelpCenterDetailViewController.h"
#import "RH_HelpCenterSecondModel.h"  //传值model
#import "RH_HelpCenterDetailModel.h"
#import "RH_NewHelpCenterDetaliViewCell.h"
#import "RH_NewHelpCenterDetailHeaderView.h"
#import "coreLib.h"


@interface RH_NewHelpCenterDetailViewController ()
{
    RH_HelpCenterSecondModel *_helpCenterScondModel ;
    NSArray *_dataSource ;
}
@end

@implementation RH_NewHelpCenterDetailViewController

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
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    [self.contentView addSubview:self.contentTableView];
    [self.contentTableView registerCellWithClass:[RH_NewHelpCenterDetaliViewCell class]] ;
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0) ;
    }] ;
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
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
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
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
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
            }else if ([THEMEV3 isEqualToString:@"blue"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Blue ;
            }else if ([THEMEV3 isEqualToString:@"orange"]){
                backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor_Orange ;
            }else if ([THEMEV3 isEqualToString:@"red_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Red_White ;
            }else if ([THEMEV3 isEqualToString:@"green_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Green_White ;
            }else if ([THEMEV3 isEqualToString:@"orange_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Orange_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_White ;
            }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
                navigationBar.barTintColor = RH_NavigationBar_BackgroundColor_Coffee_Black ;
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
        _dataSource = ConvertToClassPointer(NSArray, data) ;
        [self loadDataSuccessWithDatas:_dataSource?_dataSource:nil
                            totalCount:_dataSource?_dataSource.count:1] ;
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3HelpDetail) {
        [self loadDataFailWithError:error] ;
    }
}

#pragma mark-tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
     return MAX(1, self.pageLoadManager.currentDataCount) ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RH_HelpCenterDetailModel *model = _dataSource[section] ;
    return model.isExpanded ? 1:0 ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RH_HelpCenterDetailModel *model = _dataSource[indexPath.section] ;
    return model.cellHeight ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RH_NewHelpCenterDetaliViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_NewHelpCenterDetaliViewCell defaultReuseIdentifier]];
    
    if (!cell) {
        cell = [[RH_NewHelpCenterDetaliViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[RH_NewHelpCenterDetaliViewCell defaultReuseIdentifier]];
    }
    [cell updateCellWithInfo:nil context:_dataSource[indexPath.section]] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    RH_NewHelpCenterDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[RH_NewHelpCenterDetailHeaderView defaultReuseIdentifier]];
    
    if (!headerView) {
        headerView = [[RH_NewHelpCenterDetailHeaderView alloc] initWithReuseIdentifier:[RH_NewHelpCenterDetailHeaderView defaultReuseIdentifier]];
    }
    headerView.sectionModel = _dataSource[section] ;
    headerView.HeaderClickedBack = ^(BOOL isExpand){
        
        [tableView reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return  headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  34.5f*WIDTH_PERCENT;
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
