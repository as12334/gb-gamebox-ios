//
//  RH_PromoViewControllerEx.m
//  gameBoxEx
//
//  Created by luis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoViewControllerEx.h"
#import "RH_PromoTypeHeaderView.h"
#import "RH_PromoContentPageCell.h"
#import "coreLib.h"
#import "RH_DiscountActivityTypeModel.h"

@interface RH_PromoViewControllerEx ()<CLPageViewDelegate,CLPageViewDatasource>
@property(nonatomic,strong,readonly) CLPageView *pageView ;
@property(nonatomic,strong,readonly) RH_PromoTypeHeaderView *typeTopView  ;
@end

@implementation RH_PromoViewControllerEx
@synthesize typeTopView = _typeTopView ;
@synthesize pageView = _pageView ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarItem.leftBarButtonItem = self.logoButtonItem      ;
    [self setNeedUpdateView] ;
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    
    //初始化 优惠类别信息
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:@"数据请求中" detailText:@"请稍等..."] ;
    [self.serviceRequest startV3LoadDiscountActivityType] ;
}

-(BOOL)hasTopView{
    return YES ;
}

-(CGFloat)topViewHeight
{
    return self.typeTopView.viewHeight ;
}

-(void)setupInfo
{
    [self.topView addSubview:self.typeTopView] ;
    //分页视图
//    [self.contentView addSubview:self.pageView];
    //注册复用
//    [self.pageView registerCellForPage:[RH_PromoContentPageCell class] andReuseIdentifier:[RH_PromoContentPageCell defaultReuseIdentifier]] ;
//
//    //设置索引
//    self.pageView.dispalyPageIndex = self.typeTopView.selectedType;
}

-(void)updateView
{
    if (self.appDelegate.isLogin){
        self.navigationBarItem.rightBarButtonItems = @[self.userInfoButtonItem] ;
    }else{
        self.navigationBarItem.rightBarButtonItems = @[self.signButtonItem,self.loginButtonItem] ;
    }
}

-(void)adjuestTopViewHeight
{
    CGRect oldFrame = self.topView.frame ;
    CGRect newFrame = CGRectMake(0,oldFrame.origin.y,oldFrame.size.width,[self topViewHeight]);
    
    if (CGRectEqualToRect(oldFrame, newFrame)){
        [UIView animateWithDuration:0.1f animations:^{
            self.topView.frame = newFrame ;
        } completion:^(BOOL finished) {
            [self setupInfo] ;
        }] ;
    }
}

#pragma mark-
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
}

#pragma mark - type header View
-(RH_PromoTypeHeaderView *)typeTopView
{
    if (!_typeTopView){
        _typeTopView = [RH_PromoTypeHeaderView createInstance] ;
        _typeTopView.frame = self.topView.bounds ;
        _typeTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
        _typeTopView.backgroundColor = [UIColor redColor] ;
    }
    
    return _typeTopView ;
}

#pragma mark -pageView
-(CLPageView*)pageView
{
    if (!_pageView){
        _pageView = [[CLPageView alloc] initWithFrame:self.contentView.bounds];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        _pageView.delegate = self ;
        _pageView.dataSource = self ;
        _pageView.pageMargin = 5.0f;
    }
    
    return _pageView ;
}

- (NSUInteger)numberOfPagesInPageView:(CLPageView *)pageView
{
    return self.typeTopView.allTypes  ;
}

- (UICollectionViewCell *)pageView:(CLPageView *)pageView cellForPageAtIndex:(NSUInteger)pageIndex
{
    RH_PromoContentPageCell * cell = [pageView dequeueReusableCellWithReuseIdentifier:[RH_PromoContentPageCell defaultReuseIdentifier] forPageIndex:pageIndex];

    [cell updateViewWithType:nil Context:nil] ;
    return cell;
}

- (void)pageView:(CLPageView *)pageView didDisplayPageAtIndex:(NSUInteger)pageIndex
{
    self.typeTopView.selectedType = pageIndex ;
}

- (void)pageView:(CLPageView *)pageView didEndDisplayPageAtIndex:(NSUInteger)pageIndex {
}

- (void)pageViewWillReloadPages:(CLPageView *)pageView {
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3PromoActivityType){
        NSArray *typeList = ConvertToClassPointer(NSArray , data) ;
        [self.typeTopView updateView:typeList] ;
        [self.contentLoadingIndicateView hiddenView] ;
        [self adjuestTopViewHeight] ;
//        [self updateTopView] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3PromoActivityType){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

@end
