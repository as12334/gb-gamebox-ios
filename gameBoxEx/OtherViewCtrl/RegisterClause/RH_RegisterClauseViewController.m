//
//  RH_RegisterClauseViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegisterClauseViewController.h"
#import "RH_RegisterClauseViewCell.h"
#import "RH_RegisterClauseModel.h"

@interface RH_RegisterClauseViewController ()

@end

@implementation RH_RegisterClauseViewController

-(BOOL)isSubViewController
{
    return YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册条款" ;
    [self setupInfo];
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
}

- (void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO];
    self.contentTableView.sectionHeaderHeight = 9.0f ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    
    [self.contentTableView registerCellWithClass:[RH_RegisterClauseViewCell class]] ;
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
            backgroundView.backgroundColor = RH_NavigationBar_BackgroundColor ;
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
    CGFloat cellHeigh = [RH_RegisterClauseViewCell heightForCellWithInfo:nil tableView:nil context:nil] ;
    return floorf(contentHeigh/cellHeigh) ;
    
}


#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3RegisetTerm] ;
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
    if (type == ServiceRequestTypeV3RegiestTerm) {
        RH_RegisterClauseModel *model = ConvertToClassPointer(RH_RegisterClauseModel, data) ;
        [self loadDataSuccessWithDatas:model?@[model]:nil
                            totalCount:model?1:1] ;
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3RegiestTerm) {
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
        return [RH_RegisterClauseViewCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_RegisterClauseViewCell *registerClauseCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_RegisterClauseViewCell defaultReuseIdentifier]] ;
        [registerClauseCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
        return registerClauseCell ;
    }else{
        return self.loadingIndicateTableViewCell ;
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
