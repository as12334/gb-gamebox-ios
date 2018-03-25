//
//  RH_AboutUsViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AboutUsViewController.h"
#import "RH_AboutUsTableViewCell.h"

@interface RH_AboutUsViewController ()
@property(nonatomic,strong,readonly)UIWebView *webView ;

@end

@implementation RH_AboutUsViewController

-(BOOL)isSubViewController
{
    return YES ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们" ;
    [self setupInfo];
    self.contentView.backgroundColor = colorWithRGB(239, 239, 239);
}

- (void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO];
    self.contentTableView.sectionHeaderHeight = 9.0f ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    
    [self.contentTableView registerCellWithClass:[RH_AboutUsTableViewCell class]] ;
    [self.contentView addSubview:self.contentTableView];
    [self setupPageLoadManager] ;
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
    CGFloat cellHeigh = [RH_AboutUsTableViewCell heightForCellWithInfo:nil tableView:nil context:nil] ;
    return floorf(contentHeigh/cellHeigh) ;
    
}


#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.serviceRequest startV3AboutUs] ;
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
    if (type == ServiceRequestTypeV3AboutUs) {
        NSDictionary *dictTemp = [data objectForKey:@"data"] ;
        self.title = [dictTemp objectForKey:@"title"] ;
        [self loadDataSuccessWithDatas:dictTemp?dictTemp:@[]
                            totalCount:dictTemp?dictTemp.count:0] ;
        
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3AboutUs) {
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
        return [RH_AboutUsTableViewCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        CGFloat height = MainScreenH - tableView.contentInset.top - tableView.contentInset.bottom ;
        return height ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_AboutUsTableViewCell *aboutUsCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_AboutUsTableViewCell defaultReuseIdentifier]] ;
        [aboutUsCell updateCellWithInfo:nil context:[self.pageLoadManager dataAtIndexPath:indexPath]];
        return aboutUsCell ;
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
