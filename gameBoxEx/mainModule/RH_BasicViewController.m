//
//  RH_BasicViewController.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_BasicViewController.h"
#import <objc/runtime.h>
#import "RH_ImagePickerViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "RH_SlideMenuViewController.h"
#import "RH_NavigationUserInfoView.h"
#import "RH_UserInfoSubViewControler.h"

@interface RH_BasicViewController ()<RH_ServiceRequestDelegate,CLLoadingIndicateViewDelegate>
@property (nonatomic,strong,readonly) RH_NavigationUserInfoView *navigationUserInfoView ;
@property (nonatomic,strong,readonly) RH_UserInfoSubViewControler *userInfoSubViewCtrl ;
@end

@implementation RH_BasicViewController
@synthesize serviceRequest = _serviceRequest                ;
@synthesize backButtonItem = _backButtonItem                ;
@synthesize mainMenuButtonItem = _mainMenuButtonItem        ;
@synthesize loginButtonItem = _loginButtonItem              ;
@synthesize tryLoginButtonItem = _tryLoginButtonItem        ;
@synthesize signButtonItem  = _signButtonItem               ;
@synthesize logoButtonItem  = _logoButtonItem               ;
@synthesize userInfoButtonItem = _userInfoButtonItem        ;
@synthesize navigationUserInfoView = _navigationUserInfoView ;
@synthesize userInfoSubViewCtrl = _userInfoSubViewCtrl      ;

-(BOOL)hasNavigationBar
{
    return YES ;
}

-(CLViewControllerDesignatedShowWay)viewControllerDesignatedShowWay
{
    return CLViewControllerDesignatedShowWayPush ;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        return UIStatusBarStyleDefault ;
    }
    return UIStatusBarStyleLightContent ;
}

+(void)configureNavigationBar:(UINavigationBar *)navigationBar
{
    navigationBar.barStyle = UIBarStyleDefault ;
    UIView *backgroundView = [[UIView alloc] initWithFrame:navigationBar.bounds] ;
    [navigationBar insertSubview:backgroundView atIndex:0] ;
    backgroundView.backgroundColor = [UIColor clearColor] ;
//    navigationBar.titleTextAttributes = @{NSFontAttributeName:RH_NavigationBarTitleFontSize,
//                                          NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    
//    UINavigationBar *bar = [super navigationBar];
//    if (bar) {
//        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//        [bar.layer insertSublayer:gradientLayer atIndex:1];
//        gradientLayer.frame = CGRectMake(0, -20, bar.bounds.size.width, 64);
//        gradientLayer.locations = @[@(0.2), @(0.5), @(0.8)];
//
//        gradientLayer.colors =  @[(__bridge id)[UIColor redColor].CGColor,
//                                  (__bridge id)[UIColor blueColor].CGColor,
//                                  (__bridge id)[UIColor purpleColor].CGColor,
//                                  (__bridge id)[UIColor orangeColor].CGColor];
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1, 1);
//
//    }
//    return bar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    
    self.needObserveNetStatusChanged = YES ;
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        self.view.backgroundColor = RH_View_DefaultBackgroundColor ;
    }else{
        self.view.backgroundColor = ColorWithNumberRGB(0xf2f2f2) ;
    }
    self.navigationBarItem.leftBarButtonItem = nil ;
    self.navigationBarItem.rightBarButtonItems = nil ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitle:(NSString *)title
{
    self.navigationBarItem.title = title ;
}

-(void)dealloc
{
    [_serviceRequest cancleAllServices] ;
    _serviceRequest.delegate = nil ;
    _serviceRequest = nil ;
}

-(UIBarButtonItem*)backButtonItem
{
    if (!_backButtonItem){
        _backButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageWithName(@"ic_back")
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(backBarButtonItemHandle)] ;
    }

    return  _backButtonItem ;
}


-(void)backBarButtonItemHandle
{
    //do nothing ;
}

#pragma mark-
-(UIBarButtonItem *)mainMenuButtonItem
{
    if (!_mainMenuButtonItem){
        UIImage *menuImage = ImageWithName(@"ic_navigationBar_home");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, menuImage.size.width, menuImage.size.height);
        [button setBackgroundImage:menuImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(mainMenuButtonItemHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _mainMenuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
    }
    
    return  _mainMenuButtonItem ;
}

-(void)mainMenuButtonItemHandle
{
    [self cw_showDrawerViewController:[RH_SlideMenuViewController viewController]
                        animationType:CWDrawerAnimationTypeDefault
                        configuration:nil] ;
}

#pragma mark-
-(UIBarButtonItem *)tryLoginButtonItem
{
    if (!_tryLoginButtonItem){
        CLButton *button = [CLButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40,30);
        [button setBackgroundColor:colorWithRGB(18, 121, 217) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [button setTitle:@"试玩" forState:UIControlStateNormal] ;
        button.layer.cornerRadius = 4.0f ;
        button.layer.masksToBounds = YES ;
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]] ;
        [button addTarget:self action:@selector(_tryLoginButtonItemHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _tryLoginButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
    }
    
    return  _tryLoginButtonItem ;
}

-(void)_tryLoginButtonItemHandle
{
    
}

#pragma mark-
-(UIBarButtonItem *)loginButtonItem
{
    if (!_loginButtonItem){
        CLButton *button = [CLButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40,30);
        [button setBackgroundColor:colorWithRGB(29, 194, 142) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [button setTitle:@"登录" forState:UIControlStateNormal] ;
        [button addTarget:self action:@selector(_loginButtonItemHandle) forControlEvents:UIControlEventTouchUpInside] ;
        button.layer.cornerRadius = 4.0f ;
        button.layer.masksToBounds = YES ;
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]] ;
        _loginButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
    }
    
    return  _loginButtonItem ;
}

-(void)_loginButtonItemHandle
{
    
}

#pragma mark-
-(UIBarButtonItem *)signButtonItem
{
    if (!_signButtonItem){
        CLButton *button = [CLButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 40,30);
        [button setBackgroundColor:colorWithRGB(240, 175, 1) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [button setTitle:@"注册" forState:UIControlStateNormal] ;
        [button addTarget:self action:@selector(_signButtonItemHandle) forControlEvents:UIControlEventTouchUpInside] ;
        button.layer.cornerRadius = 4.0f ;
        button.layer.masksToBounds = YES ;
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]] ;
        _signButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
    }
    
    return  _signButtonItem ;
}

-(void)_signButtonItemHandle
{
    
}

#pragma mark-
-(UIBarButtonItem *)logoButtonItem
{
    if (!_logoButtonItem){
        NSString *logoName = [NSString stringWithFormat:@"app_logo_%@",SID] ;
        UIImage *menuImage = ImageWithName(logoName);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:menuImage];
        
        imageView.frame = CGRectMake(0, 0, menuImage.size.width, menuImage.size.height);
        _logoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView] ;
    }
    
    return  _logoButtonItem ;
}

#pragma mark-
-(RH_NavigationUserInfoView *)navigationUserInfoView
{
    if (!_navigationUserInfoView){
        _navigationUserInfoView = [RH_NavigationUserInfoView createInstance] ;
//        [_navigationUserInfoView addTarget:self
//                                    action:@selector(userInfoButtonItemHandle)
//                          forControlEvents:UIControlEventTouchUpInside] ;
        [_navigationUserInfoView.buttonCover addTarget:self
                                                action:@selector(userInfoButtonItemHandle) forControlEvents:UIControlEventTouchUpInside] ;
        _navigationUserInfoView.frame = CGRectMake(0, 0, 40.0f, 60.0f) ;
    }
    
    return _navigationUserInfoView ;
}

-(UIBarButtonItem *)userInfoButtonItem
{
    if (!_userInfoButtonItem){
        _userInfoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navigationUserInfoView] ;
    }
    
    return  _userInfoButtonItem ;
}

-(RH_UserInfoSubViewControler *)userInfoSubViewCtrl
{
    if (!_userInfoSubViewCtrl){
        _userInfoSubViewCtrl = [RH_UserInfoSubViewControler viewController] ;
        _userInfoSubViewCtrl.view.frame = self.view.bounds ;
    }
    
    return _userInfoSubViewCtrl ;
}

-(void)userInfoButtonItemHandle
{
    if (self.userInfoSubViewCtrl.parentViewController != self) {
        //加入成为子控制器
        [self addChildViewController:self.userInfoSubViewCtrl];
        //开始显示
        [self.userInfoSubViewCtrl beginAppearanceTransition:YES animated:YES];
        [self.contentView addSubview:self.userInfoSubViewCtrl.view];
        [self.userInfoSubViewCtrl endAppearanceTransition];
        
    }else {
        //移除显示
        [self.userInfoSubViewCtrl beginAppearanceTransition:YES animated:YES];
        [self.userInfoSubViewCtrl.view removeFromSuperview];
        [self.userInfoSubViewCtrl endAppearanceTransition];
        [self.userInfoSubViewCtrl removeFromParentViewController] ;
    }
}

#pragma mark-
-(RH_ServiceRequest*)serviceRequest
{
    if (!_serviceRequest){
        _serviceRequest = [[RH_ServiceRequest alloc] init] ;
        _serviceRequest.delegate = self ;
    }

    return _serviceRequest ;
}

-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    if (!_contentLoadingIndicateView){
        _contentLoadingIndicateView = [[RH_LoadingIndicateView alloc] initWithFrame:self.contentView.bounds];

        _contentLoadingIndicateView.marginValue = UIEdgeInsetsMake(([self hasNavigationBar] ? CGRectGetHeight(self.navigationBar.frame) : StatusBarHoldHeight) + [self topViewHeight], 0.f, self.hiddenTabBar ? 0.f : TabBarHeight, 0.f);

        _contentLoadingIndicateView.contentOffset = [self contentLoadingIndicateViewAdditionalOffset];
        _contentLoadingIndicateView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        _contentLoadingIndicateView.delegate = self;
        [self.contentView addSubview:_contentLoadingIndicateView];

        [self configureContentLoadingIndicateView:_contentLoadingIndicateView] ;
    }

    return _contentLoadingIndicateView ;
}

-(RH_LoadingIndicateTableViewCell *)loadingIndicateTableViewCell
{
    if (!_loadingIndicateTableViewCell) {
        _loadingIndicateTableViewCell = [[RH_LoadingIndicateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _loadingIndicateTableViewCell.backgroundColor = [UIColor clearColor];
        _loadingIndicateTableViewCell.contentInset = UIEdgeInsetsMake(5.f, 0.f, 5.f, 0.f);
        _loadingIndicateTableViewCell.loadingIndicateView.backgroundColor = [UIColor whiteColor];
        _loadingIndicateTableViewCell.loadingIndicateView.delegate = self;
    }

    return _loadingIndicateTableViewCell;
}

-(CGPoint)contentLoadingIndicateViewAdditionalOffset
{
    return CGPointZero ;
}

-(void)configureContentLoadingIndicateView:(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    //do nothing
}

@end


@implementation RH_BasicViewController (ShowCalendar)
static char CALENDARBACKGROUNDVIEW ;
static char CALENDARBACKGROUNDVIEWTAPGESTURE ;
-(UITapGestureRecognizer*)calendarBackgroupViewTapGesture
{
    UITapGestureRecognizer *backgroundViewTapGesture = objc_getAssociatedObject(self, &CALENDARBACKGROUNDVIEWTAPGESTURE) ;
    if (!backgroundViewTapGesture){
        backgroundViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_calendarBackgroupViewTapGestureHandle)] ;

        objc_setAssociatedObject(self, &CALENDARBACKGROUNDVIEWTAPGESTURE, backgroundViewTapGesture, OBJC_ASSOCIATION_RETAIN) ;
    }

    return backgroundViewTapGesture ;
}

-(UIView*)calendarBackgroundView
{
    UIView *backgroundView = objc_getAssociatedObject(self, &CALENDARBACKGROUNDVIEW) ;
    if (!backgroundView){
        backgroundView = [[UIView alloc] initWithFrame:self.view.bounds] ;
        [backgroundView addGestureRecognizer:self.calendarBackgroupViewTapGesture] ;

        backgroundView.backgroundColor = ColorWithNumberRGBA(0x000000, 0.3) ;
        objc_setAssociatedObject(self, &CALENDARBACKGROUNDVIEW, backgroundView, OBJC_ASSOCIATION_RETAIN) ;
    }

    return backgroundView ;
}


-(void)_calendarBackgroupViewTapGestureHandle
{
    [self hideCalendarViewWithAnimated:YES] ;
}

-(void)showCalendarView:(NSString*)title
         initDateString:(NSString*)dateStr
           comfirmBlock:(CalendaCompleteBlock)completeBlock;
{
    if (!dateStr.length){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"] ;
        dateStr = [dateFormatter stringFromDate:[NSDate date]] ;
    }

    CLCalendarView *shareCalendarView = [CLCalendarView shareCalendarView:title defaultDate:dateStr] ;
    [self hideCalendarViewWithAnimated:NO] ;

    _calendarCompleteBlock = completeBlock ;
    shareCalendarView.delegate = self ;


    [self.calendarBackgroundView removeFromSuperview] ;
    [shareCalendarView removeFromSuperview] ;


    shareCalendarView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height -shareCalendarView.boundHeigh-(self.isHiddenTabBar?0.0f:TabBarHeight),
                                         shareCalendarView.boundWidth, shareCalendarView.boundHeigh) ;

    if (!shareCalendarView.superview){
        [self.calendarBackgroundView addSubview:shareCalendarView] ;
//        shareCalendarView.center = self.calendarBackgroundView.center ;
    }

    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                     animations:^{
                         [self.view addSubview:self.calendarBackgroundView] ;
                         [self.view bringSubviewToFront:self.calendarBackgroundView] ;
                     } completion:^(BOOL finished) {
                     }] ;
}

-(void)hideCalendarViewWithAnimated:(BOOL)bAnimated
{
    if (!self.calendarBackgroundView.superview) return ;

    if (bAnimated){
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                         animations:^{
                             [self.calendarBackgroundView removeFromSuperview] ;
        } completion:^(BOOL finished) {
        }] ;
    }else{
        [self.calendarBackgroundView removeFromSuperview] ;
    }
}

-(void)calendarViewTouchConfirmButton:(CLCalendarView*)calendarView SelectDate:(NSDate *)date
{
    if (_calendarCompleteBlock){
        _calendarCompleteBlock(date) ;
        _calendarCompleteBlock = nil ;
    }
    [self hideCalendarViewWithAnimated:YES] ;
}

-(void)calendarViewTouchCancelButton:(CLCalendarView*)calendarView
{
    [self hideCalendarViewWithAnimated:YES] ;
}

@end


@implementation RH_BasicViewController (ImagePickerViewController)

- (UIActionSheet *)showImagePickerActionSheetWithTitle:(NSString *)title {
    return [self showImagePickerActionSheetWithTitle:title selectedImageCount:1 showMultipleImagePicker:NO];
}

- (UIActionSheet *)showImagePickerActionSheetWithTitle:(NSString *)title
                                    selectedImageCount:(NSUInteger)selectedImageCount
                               showMultipleImagePicker:(BOOL)showMultipleImagePicker
{

    UIActionSheet * actionSheet = [UIActionSheet actionViewWithCallBackBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {

        if (buttonIndex != actionSheet.cancelButtonIndex) {

            //从相册选取
            if ([actionSheet firstOtherButtonIndex] == buttonIndex && (showMultipleImagePicker || selectedImageCount != 1)) {

                [RH_MultipleImagePickerController showImagePickerViewControllerWithSelectedImageCount:selectedImageCount
                                                                                           filterType:DNImagePickerFilterTypePhotos
                                                                                  canSelecteFullImage:NO
                                                                                  basicViewController:self
                                                                                             delegate:self
                                                                                             animated:YES
                                                                                       completedBlock:nil];

            }else {

                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                if([actionSheet firstOtherButtonIndex] != buttonIndex){
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                }

                //获取照片
                RH_ImagePickerViewController * imagePickerViewController = [RH_ImagePickerViewController imagePickerViewControllerForSourceType:sourceType delegate:self];
                imagePickerViewController.allowsEditing = [self allowsImagePickerEditing];

                if (imagePickerViewController) {
                    [self showViewControllerWithDesignatedWay:imagePickerViewController
                                                     animated:YES
                                               completedBlock:nil];
                }
            }
        }
    }
                                                                       title:title
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"从相册中选取",nil];

    if ([RH_ImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"拍照"];
    }

    [actionSheet showInView:self.view];

    return actionSheet;

}

- (BOOL)allowsImagePickerEditing {
    return NO;
}
@end


@implementation RH_BasicViewController (IntervalAnimation)

- (void)startDefaultShowIntervalAnimation {
    [self startIntervalAnimationWithDirection:CLMoveAnimtedDirectionLeft delay:0.f completedBlock:nil];
}

- (void)startDefaultShowIntervalAnimation_async:(void(^)())block;
{
    dispatch_async(dispatch_get_main_queue(), ^{

        [self startDefaultShowIntervalAnimation];

        if (block) {
            block();
        }
    });
}

- (void)startIntervalAnimationWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                             completedBlock:(void(^)(BOOL finished))completedBlock
{
    [self startIntervalAnimationWithDirection:moveAnimtedDirection
                                        delay:0.f
                               completedBlock:completedBlock];
}

- (void)startIntervalAnimationWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                      delay:(NSTimeInterval)delay
                             completedBlock:(void(^)(BOOL finished))completedBlock
{
    [self startCommitIntervalAnimatedWithDirection:moveAnimtedDirection
                                          duration:[self defaultIntervalAnimationDuration]
                                             delay:delay
                                           forShow:YES
                                           context:nil
                                    completedBlock:completedBlock];
}

- (NSTimeInterval)defaultIntervalAnimationDuration {
    return 1.f;
}

- (NSArray *)needAnimatedObjectsWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                      forShow:(BOOL)show
                                      context:(id)context
{
    if (self.contentTableView.superview) {
        return self.contentTableView.visibleCells;
    }else if (self.contentCollectionView.superview){
        return @[self.contentCollectionView];
    }else{
        return @[self.contentView];
    }
}

- (NSTimeInterval)animationIntervalForDuration:(NSTimeInterval)duration forShow:(BOOL)show {
    return 0.1f;
}

@end


//------------------------------------------------------------

@implementation RH_BasicViewController (ImageScan)

#pragma mark -
- (CLScanImageView *)scanImageView {
    return _scanImageView;
}

- (BOOL)canShowScanImageViewWithContext:(id)context
{
    return (self.interfaceOrientation == UIInterfaceOrientationPortrait &&
            [self willScanImageWithContext:context] &&
            !_scanImageView.isScanning);
}

- (BOOL)willScanImageWithContext:(id)context {
    return YES;
}

#pragma mark -

- (BOOL)object:(id)object wantToScanImage:(CLScanImageData *)image {
    return [self startScanImage:image configureBlock:nil];
}

- (BOOL)object:(id)object wantToScanImage:(CLScanImageData *)image configureBlock:(void(^)(CLScanImageView * scanImageView))configureBlock
{
    return [self startScanImage:image configureBlock:configureBlock];
}

- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToScanImageAtIndex:(NSUInteger)index withContext:(id)context
{
    return [self startScanImagesWithDataSource:object
                                    beginIndex:index
                                       context:context
                                configureBlock:nil];
}

- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToScanImageAtIndex:(NSUInteger)index withContext:(id)context configureBlock:(void (^)(CLScanImageView *))configureBlock
{
    return [self startScanImagesWithDataSource:object
                                    beginIndex:index
                                       context:context
                                configureBlock:configureBlock];
}

#pragma mark -

- (BOOL)startScanImage:(CLScanImageData *)image configureBlock:(void(^)(CLScanImageView * scanImageView))configureBlock
{
    if ([self canShowScanImageViewWithContext:nil]) {

        CLScanImageView * scanImageView = [[CLScanImageView alloc] init];
        scanImageView.delegate = self;
        _scanImageView = scanImageView;

        //配置
        if (configureBlock) {
            configureBlock(scanImageView);
        }

        //开始浏览图片
        [scanImageView startScanImage:image
                           baseWindow:self.view.window
                             animated:YES
                       completedBlock:nil];

        return YES;
    }

    return NO;
}

- (BOOL)startScanImagesWithDataSource:(id<CLScanImageViewDataSource>)dataSource beginIndex:(NSUInteger)beginIndex context:(id)context configureBlock:(void (^)(CLScanImageView *))configureBlock
{
    if ([self canShowScanImageViewWithContext:context]) {

        CLScanImageView * scanImageView = [[CLScanImageView alloc] init];
        scanImageView.delegate = self;
        _scanImageView = scanImageView;

        //配置
        if (configureBlock) {
            configureBlock(self.scanImageView);
        }

        //开始浏览
        [self.scanImageView startScanImageAtIndex:beginIndex
                                   withDataSource:dataSource
                                          context:context
                                       baseWindow:self.view.window
                                         animated:YES
                                   completedBlock:nil];

        return YES;
    }

    return NO;
}

#pragma mark -

- (BOOL)_isScanningImageWithDataSource:(id<CLScanImageViewDataSource>)dataSource context:(id)context
{
    CLScanImageView * scanImageView = self.scanImageView;
    return scanImageView.isScanning && scanImageView.dataSource == dataSource &&
    (scanImageView.scanContext == context || [scanImageView.scanContext isEqual:context]);
}

- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToEndScanImageWithContex:(id)context
{
    if ([self _isScanningImageWithDataSource:object context:context]) {
        [self.scanImageView endScanImageWithAnimated:NO completedBlock:nil];
        return YES;
    }

    return NO;
}

- (BOOL)object:(id<CLScanImageViewDataSource>)object wantToReloadScanImagesWithContex:(id)context
{
    if ([self _isScanningImageWithDataSource:object context:context]) {
        [self.scanImageView reloadImages:YES];
        return YES;
    }

    return NO;
}

#pragma mark -

- (void)scanImageViewDidStartScan:(CLScanImageView *)scanImageView
{
    if (scanImageView == self.scanImageView) {
        [self statusBarAppearanceUpdate];
    }
}

- (void)scanImageViewDidEndScan:(CLScanImageView *)scanImageView
{
    if (scanImageView == self.scanImageView) {
        [self statusBarAppearanceUpdate];
        _scanImageView = nil;
    }
}

- (BOOL)preferredStatusBarHidden {
    return _scanImageView.isScanning;
}

@end

//------------------------------------------------------------

//------------------------------------------------------------

@implementation RH_BasicViewController (SavaData)

- (void)setSupportSavaData:(BOOL)supportSavaData
{
    if (_supportSavaData != supportSavaData) {

        if (_supportSavaData && _observeForSavaData) {
            [[NSNotificationCenter defaultCenter] removeObserver:_observeForSavaData];
            _observeForSavaData = nil;
        }

        _supportSavaData = supportSavaData;

        if (_supportSavaData) {

            //弱引用
            WEAK_REFRENCE(self,weak_self);

            //观察通知
            _observeForSavaData =
            [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                              object:nil
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:^(NSNotification *note) {
                                                              [weak_self _startTrySavaData];
                                                          }];
        }
    }
}

- (void)_startTrySavaData
{
    //储存数据
    for (NSString * key in _needSavaDataKeys) {
        [self saveDataForKey:key];
    }

    [_needSavaDataKeys removeAllObjects];
}


_ACCESSOR(isSupportSavaData, BOOL, _supportSavaData);

//设置某一key标识的数据需要被储存
- (void)setNeedSavaDataForKey:(NSString *)key
{
    if (!_needSavaDataKeys) {
        _needSavaDataKeys = [NSMutableSet set];
    }

    if (key.length) {
        [_needSavaDataKeys addObject:key];
    }else {
        DefaultDebugLog(@"标识需要储存数据的key不能为nil");
    }
}

-(NSString *)_genNewSaveKey:(NSString*)key
{
    return nil ;
}

- (void)saveDataForKey:(NSString *)key
{
    assert(key.length);

    id<NSCoding> data = [self needSaveDataForKey:key];

    CLDocumentCachePool * cachePool = [self needTempSaveDataForKey:key] ? [CLDocumentCachePool shareTempCachePool] : [CLDocumentCachePool sharePool];

    //基于 app 必须等入才能使用，在存储前增加 key + userID

    if (data != nil) {
        [cachePool cacheKeyedArchiverDataWithRootObject:data forKey:key async:YES];
    }else {
        [cachePool removeCacheFileForKey:key async:YES];
    }
}

- (id<NSCoding>)needSaveDataForKey:(NSString *)key {
    return nil;
}

- (BOOL)needTempSaveDataForKey:(NSString *)key {
    return YES;
}

@end


//@implementation UIViewController (MainTabBarControllerEx)
//- (RH_MainTabBarControllerEx *)myTabBarControllerEx
//{
//    if ([self isKindOfClass:[RH_MainTabBarControllerEx class]]) {
//        return (RH_MainTabBarControllerEx *)self;
//    }else{
//        UIViewController *topViewCtrl = self.navigationController.viewControllers[0] ;
//        return [topViewCtrl myTabBarControllerEx];
//    }
//}
//@end

