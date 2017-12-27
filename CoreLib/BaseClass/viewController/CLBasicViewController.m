//
//  CLBasicViewController.m
//  CoreLib
//
//  Created by jinguihua on 2017/2/8.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import "CLBasicViewController.h"
#import "UIView+FrameSize.h"
#import <objc/runtime.h>
#import "MacroDef.h"

@interface CLBasicViewController ()

@end

@implementation CLBasicViewController
@synthesize contentView     = _contentView          ;
@synthesize navigationBar   = _navigationBar        ;
@synthesize navigationBarItem = _navigationBarItem  ;
@synthesize hiddenNavigationBar = _hiddenNavigationBar ;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.contentView] ;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;

    if ([self hasNavigationBar]){
        _hiddenNavigationBar = NO ;
        self.navigationBar.frame = CGRectMake(0,
                                              0,
                                              self.view.frameWidth ,
                                              (self.isHiddenStatusBar?0.0:heighStatusBar) + (_hiddenNavigationBar?0.0f:heighNavigationBar)
                                              ) ;

        self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin ;
        [self.view addSubview:self.navigationBar] ;

        [self.navigationBar pushNavigationItem:self.navigationBarItem animated:NO] ;
    }

    [self updateTopView] ;
    [self updateBottomView] ;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;

    if (self.needObserverKeyboard) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_keyboardWillChangeFrameNotification:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_keyboardDidChangeFrameNotification:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;

    if (self.needObserverKeyboard){

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillChangeFrameNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidChangeFrameNotification
                                                      object:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;

    //显示帮助视图
    [self showHelpView] ;
}

#pragma mark-
- (void)_keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    _keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardEndFrame = [self.view convertRect:_keyboardEndFrame fromView:self.view.window];

    if (_keyboardEndFrame.origin.y >= CGRectGetHeight(self.view.window.bounds)) {
        _keyboardEndFrame = CGRectZero;
    }

    _keyboardAnimationCurve = (UIViewAnimationCurve)[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    _keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self keyboardFrameWillChange];
}

- (void)_keyboardDidChangeFrameNotification:(NSNotification *)notification
{
    if (self.needObserverKeyboard){
        [self adjustViewFrameBasicKeyboard];
    }

    [self keyboardFrameDidChange];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
    [self endUpdateHandle] ;
    [self endLoadHandle]   ;
    self.needObserverTapGesture = NO ;
}


-(void)setHiddenTabBar:(BOOL)hiddenTabBar
{
    [super setHiddenTabBar:hiddenTabBar] ;
    [self updateBottomView] ;
}

#pragma mark-
-(UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init] ;
        _contentView.backgroundColor = [UIColor clearColor] ;
        _contentView.frame = self.view.bounds ;
        _contentView.translatesAutoresizingMaskIntoConstraints = YES ;

    }

    return _contentView ;
}

-(UINavigationBar*)navigationBar
{
    if (!_navigationBar){
        _navigationBar = [[CLNavigationBar alloc] init] ;
        _navigationBar.tintColor = [UIColor whiteColor] ;
    }

    [[self class] configureNavigationBar:_navigationBar] ;

    return _navigationBar ;
}

-(UINavigationItem*)navigationBarItem
{
    if (!_navigationBarItem){
        _navigationBarItem = [[UINavigationItem alloc] initWithTitle:self.title] ;
    }

    return _navigationBarItem ;
}

-(BOOL)isHiddenNavigationBar
{
    return [self hasNavigationBar]?_hiddenNavigationBar:YES ;
}


-(void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar
{
    [self setHiddenNavigationBar:hiddenNavigationBar animation:YES] ;
}

+(void)configureNavigationBar:(UINavigationBar*)navigationBar
{
    if (navigationBar){
        navigationBar.backgroundColor = [UIColor blackColor] ;
        navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:26],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]} ;
    }

    return ;
}

-(BOOL)hasNavigationBar
{
    return YES ;//default value ;
}


-(void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar animation:(BOOL)animation
{
    if (![self hasNavigationBar]) return ;

    if (hiddenNavigationBar!=_hiddenNavigationBar){
        _hiddenNavigationBar = hiddenNavigationBar ;
        [self _updateNavigationBar:animation] ;
    }
}

-(void)_updateNavigationBar:(BOOL)animation
{
    if (animation){
        self.navigationBar.hidden = NO ;

        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                         animations:^{
                             self.navigationBar.frame = CGRectMake(0,
                                                                   0,
                                                                   self.view.frameWidth ,
                                                                   (self.isHiddenStatusBar?0.0:heighStatusBar) + (_hiddenNavigationBar?0.0f:heighNavigationBar)
                                                                   ) ;
                         }
                         completion:^(BOOL finished) {
                             self.navigationBar.hidden = _hiddenNavigationBar ;
                         }] ;

    }else{
        self.navigationBar.frame = CGRectMake(0,
                                              0,
                                              self.view.frameWidth ,
                                              (self.isHiddenStatusBar?0.0:heighStatusBar) + (_hiddenNavigationBar?0.0f:heighNavigationBar)
                                              ) ;

        self.navigationBar.hidden = _hiddenNavigationBar ;
    }
}

-(void)setHiddenStatusBar:(BOOL)hiddenStatusBar
{
    if (self.isHiddenStatusBar!=hiddenStatusBar){
        [super setHiddenStatusBar:hiddenStatusBar] ;
        [self _updateNavigationBar:NO] ;
        [self updateTopView] ;
    }
}
@end


@implementation CLBasicViewController (TopView)
static char TOPVIEW ;
-(CLBorderView*)topView
{
    CLBorderView *topView = objc_getAssociatedObject(self, &TOPVIEW) ;
    if (!topView){
        topView = [[CLBorderView alloc] initWithFrame:CGRectMake(0, 0, self.view.boundWidth, [self topViewHeight])] ;
        topView.backgroundColor = [UIColor clearColor] ;
        objc_setAssociatedObject(self, &TOPVIEW, topView, OBJC_ASSOCIATION_RETAIN) ;
    }

    return topView ;
}

-(BOOL)hasTopView
{
    return NO ;
}

-(CGFloat)topViewHeight
{
    return 0.0 ;
}

-(void)updateTopView
{
    if ([self hasTopView]){
        CGFloat height = MAX(0, [self topViewHeight]) ;
        CGRect frame = CGRectMake(0,
                                 (self.isHiddenStatusBar?0.0:heighStatusBar)+(self.isHiddenNavigationBar?0.0:heighNavigationBar),
                                 self.view.frameWidth, height) ;

        self.topView.frame = frame ;
        [self.view addSubview:self.topView] ;
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin ;
    }else{
        UIView *topView = objc_getAssociatedObject(self, &TOPVIEW) ;
        if (topView){
            [topView removeFromSuperview] ;
            objc_setAssociatedObject(self, &TOPVIEW, nil, OBJC_ASSOCIATION_RETAIN) ;
        }
    }
}
@end


@implementation CLBasicViewController (BottomView)
static char BOTTOMVIEW ;
-(CLBorderView*)bottomView
{
    CLBorderView *bottomView = objc_getAssociatedObject(self, &BOTTOMVIEW) ;
    if (!bottomView){
        bottomView = [[CLBorderView alloc] init] ;
//        bottomView.translatesAutoresizingMaskIntoConstraints = NO ;
        bottomView.backgroundColor = [UIColor clearColor] ;
        objc_setAssociatedObject(self, &BOTTOMVIEW, bottomView, OBJC_ASSOCIATION_RETAIN) ;
    }

    return bottomView ;
}

-(BOOL)hasBottomView
{
    return NO ;
}

-(CGFloat)bottomViewHeight
{
    return 0.0f ;
}

-(void)updateBottomView
{
    if ([self hasBottomView]){
        CGFloat height = MAX(0, [self bottomViewHeight]) ;
        CGRect frame = CGRectMake(0,
                                  self.view.frameHeigh - (self.isHiddenTabBar?0.0:heighTabBar) - [self bottomViewHeight],
                                  self.view.frameWidth, height) ;

        self.bottomView.frame = frame ;
        [self.view addSubview:self.bottomView] ;
        self.bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    }else{
        UIView *bottomView = objc_getAssociatedObject(self, &BOTTOMVIEW) ;
        if (bottomView){
            [bottomView removeFromSuperview] ;
            objc_setAssociatedObject(self, &BOTTOMVIEW, nil, OBJC_ASSOCIATION_RETAIN) ;
        }
    }
}
@end


@implementation CLBasicViewController (ContentTableView)
static char CONTENTTABLEVIEW ;
-(UITableView*)contentTableView
{
    return objc_getAssociatedObject(self, &CONTENTTABLEVIEW) ;
}

-(void)setContentTableView:(UITableView *)contentTableView
{
    objc_setAssociatedObject(self, &CONTENTTABLEVIEW, contentTableView, OBJC_ASSOCIATION_RETAIN) ;
}

-(UITableView*)createTableViewWithStyle:(UITableViewStyle)tableViewStyle
                          updateControl:(BOOL)bUpdateControl
                            loadControl:(BOOL)bLoadControl
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:tableViewStyle] ;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.backgroundColor = [UIColor clearColor] ;
    tableView.contentInset = UIEdgeInsetsMake((self.isHiddenStatusBar?0:heighStatusBar) +
                                              (self.isHiddenNavigationBar?0:heighNavigationBar) +
                                              ([self hasTopView]?MAX(0, [self topViewHeight]):0),
                                              0,
                                              (self.isHiddenTabBar?0:heighTabBar) +
                                              ([self hasBottomView]?MAX(0, [self bottomViewHeight]):0),
                                              0) ;
    tableView.scrollIndicatorInsets = tableView.contentInset ;

    if (tableViewStyle==UITableViewStyleGrouped){
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, 0.1)] ;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, 0.1)] ;
    }

    if (bUpdateControl){
        [tableView addSubview:self.updateRefreshCtrl] ;
    }

    if (bLoadControl){
        [tableView addSubview:self.loadRefreshCtrl] ;
    }

    return tableView ;
}

#pragma mark-tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil ;
}
@end


@implementation CLBasicViewController (ContentCollectionView)
static char CONTENTCOLLECTIONVIEW ;
-(UICollectionView*)contentCollectionView
{
    return objc_getAssociatedObject(self, &CONTENTCOLLECTIONVIEW) ;
}

-(void)setContentCollectionView:(UICollectionView *)contentCollectionView
{
    objc_setAssociatedObject(self, &CONTENTCOLLECTIONVIEW, contentCollectionView, OBJC_ASSOCIATION_RETAIN) ;
}

-(UICollectionView*)createCollectionViewWithLayout:(UICollectionViewLayout*)collectionViewLayout
                                     updateControl:(BOOL)bUpdateControl
                                       loadControl:(BOOL)bLoadControl
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:collectionViewLayout] ;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ;
    collectionView.delegate = self ;
    collectionView.dataSource = self ;
    collectionView.backgroundColor = [UIColor clearColor] ;
    collectionView.contentInset = UIEdgeInsetsMake((self.isHiddenStatusBar?0:heighStatusBar) +
                                                   (self.isHiddenNavigationBar?0:heighNavigationBar) +
                                                   ([self hasTopView]?MAX(0, [self topViewHeight]):0),
                                                   0,
                                                   (self.isHiddenTabBar?0:heighTabBar) +
                                                   ([self hasBottomView]?MAX(0, [self bottomViewHeight]):0),
                                                   0) ;

    if (bUpdateControl){
        [collectionView addSubview:self.updateRefreshCtrl] ;
    }

    if (bLoadControl){
        [collectionView addSubview:self.loadRefreshCtrl] ;
    }

    return collectionView ;
}

#pragma mark-collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0 ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil ;
}
@end

@implementation CLBasicViewController (RefreshDataControl)
static char UPDATEREFRESHCTRL   ;
static char LOADREFRESHCTRL     ;

-(CLRefreshControl*)updateRefreshCtrl
{
    CLRefreshControl *updateRefreshCtrl = objc_getAssociatedObject(self, &UPDATEREFRESHCTRL) ;
    if (!updateRefreshCtrl){
        updateRefreshCtrl = [[CLRefreshControl alloc] initWithType:CLRefreshControlTypeTop style:CLRefreshControlStyleProgress] ;
        [updateRefreshCtrl addTarget:self action:@selector(startUpdateHandle)
                 forControlEvents:UIControlEventValueChanged] ;
        updateRefreshCtrl.locationOffset = CGPointMake(0, -self.refreshControlLocationOffset.top) ;
        objc_setAssociatedObject(self, &UPDATEREFRESHCTRL, updateRefreshCtrl, OBJC_ASSOCIATION_RETAIN) ;
    }

    return updateRefreshCtrl ;
}

-(CLRefreshControl*)loadRefreshCtrl
{
    CLRefreshControl *loadRefreshCtrl = objc_getAssociatedObject(self, &LOADREFRESHCTRL) ;
    if (!loadRefreshCtrl){
        loadRefreshCtrl = [[CLRefreshControl alloc] initWithType:CLRefreshControlTypeBottom style:CLRefreshControlStyleProgress] ;
        [loadRefreshCtrl addTarget:self action:@selector(startLoadHandle)
                    forControlEvents:UIControlEventValueChanged] ;
        loadRefreshCtrl.locationOffset = CGPointMake(0, self.refreshControlLocationOffset.bottom) ;
        objc_setAssociatedObject(self, &LOADREFRESHCTRL, loadRefreshCtrl, OBJC_ASSOCIATION_RETAIN) ;
    }

    return loadRefreshCtrl ;
}

-(UIEdgeInsets)refreshControlLocationOffset
{
    return UIEdgeInsetsZero ;
}

-(void)startUpdateHandle
{
    //do nothing
}

-(void)endUpdateHandle
{
    CLRefreshControl *updateRefreshCtrl = objc_getAssociatedObject(self, &UPDATEREFRESHCTRL) ;
    if (updateRefreshCtrl){
        [updateRefreshCtrl endRefreshing] ;
    }
}

-(void)startLoadHandle
{
    //do nothing
}


-(void)endLoadHandle
{
    CLRefreshControl *loadRefreshCtrl = objc_getAssociatedObject(self, &LOADREFRESHCTRL) ;
    if (loadRefreshCtrl){
        [loadRefreshCtrl endRefreshing] ;
    }
}

-(void)beginUpdateRefresh
{
    [self.updateRefreshCtrl beginRefreshing_e:YES] ;
    [self startUpdateHandle] ;
}
@end

@implementation CLBasicViewController (FullScreenModel)
static char CONTENTSCROLLVIEW   ;
static char FULLSCREEN          ;

-(UIScrollView*)contentScrollView
{
    return objc_getAssociatedObject(self, &CONTENTSCROLLVIEW) ;
}

-(void)setContentScrollView:(UIScrollView *)contentScrollView
{
    objc_setAssociatedObject(self, &CONTENTSCROLLVIEW, contentScrollView, OBJC_ASSOCIATION_ASSIGN) ;
}

-(BOOL)isFullScreen
{
    return [objc_getAssociatedObject(self, &FULLSCREEN) boolValue] ;
}

-(void)setFullScreen:(BOOL)fullScreen
{
    [self setScrollViewFullScreenModel:fullScreen] ;
}

-(BOOL)isSupportFullScreenModel
{
    return NO ;
}

-(BOOL)fullScreenIncludeTopView
{
    return YES ;
}

-(BOOL)fullScreenIncludeBottomView
{
    return YES ;
}

-(CGRect)contentScrollViewFrameWithFullScreenModel:(BOOL)fullScreen
{
    return self.contentView.bounds ;
}

-(UIEdgeInsets)contentScrollViewEdgeInsetsWithFullScreenModel:(BOOL)fullScreen
{
    UIEdgeInsets contentInsets  ;
    if (fullScreen){
        contentInsets = UIEdgeInsetsMake((self.isHiddenStatusBar?0:heighStatusBar) +
                                         ([self fullScreenIncludeTopView]?0.0:([self hasTopView]?MAX(0, [self topViewHeight]):0)),
                                         0,
                                         ([self fullScreenIncludeBottomView]?0.0:([self hasBottomView]?MAX(0, [self bottomViewHeight]):0)),
                                         0) ;
    }else{
        contentInsets = UIEdgeInsetsMake((self.isHiddenStatusBar?0:heighStatusBar) +
                         (self.isHiddenNavigationBar?0:heighNavigationBar) +
                         ([self hasTopView]?MAX(0, [self topViewHeight]):0),
                         0,
                         (self.isHiddenTabBar?0:heighTabBar) +
                         ([self hasBottomView]?MAX(0, [self bottomViewHeight]):0),
                         0) ;
    }

    return contentInsets ;
}

-(UIEdgeInsets)contentScrollViewIndicatorContentEdgeInsetsWithFullScreenModel:(BOOL)fullScreen
{
    return [self contentScrollViewEdgeInsetsWithFullScreenModel:fullScreen] ;
}


-(void)setScrollViewFullScreenModel:(BOOL)fullScreenModel
{
    if ([self isSupportFullScreenModel] && self.isFullScreen!=fullScreenModel){
        objc_setAssociatedObject(self, &FULLSCREEN, fullScreenModel?@(YES):nil, OBJC_ASSOCIATION_RETAIN) ;

        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                         animations:^{
                             [self contentScrollViewWithFullScreenModel:fullScreenModel] ;
                         }
                         completion:^(BOOL finished) {

                         }] ;
    }
}

-(void)contentScrollViewWithFullScreenModel:(BOOL)fullScreen
{
    self.contentScrollView.frame = [self contentScrollViewFrameWithFullScreenModel:fullScreen] ;
    self.contentScrollView.contentInset = [self contentScrollViewEdgeInsetsWithFullScreenModel:fullScreen] ;
    self.contentScrollView.scrollIndicatorInsets = [self contentScrollViewIndicatorContentEdgeInsetsWithFullScreenModel:fullScreen] ;

    self.navigationBar.alpha = fullScreen?0.0:1.0   ;
    if ([self fullScreenIncludeTopView])
        self.topView.alpha = fullScreen?0.0:1.0         ;

    if ([self fullScreenIncludeBottomView])
        self.bottomView.alpha = fullScreen?0.0:1.0      ;

    self.hiddenTabBar = fullScreen?YES :NO      ;
    return ;
}

@end


@implementation CLBasicViewController (Keyboard)
_ACCESSOR(keyboardAnimationCurve, UIViewAnimationCurve, _keyboardAnimationCurve)
_ACCESSOR(keyboardEndFrame, CGRect, _keyboardEndFrame)
_ACCESSOR(keyboardAnimationDuration, NSTimeInterval, _keyboardAnimationDuration)
_ACCESSOR(adjustFrameBasicKeyboardView, UIView *, _adjustFrameBasicKeyboardView)

static char NEEDOBSERVERKEYBOARD ;
-(BOOL)needObserverKeyboard
{
    BOOL observerKeyboard = [objc_getAssociatedObject(self, &NEEDOBSERVERKEYBOARD) boolValue] ;
    return observerKeyboard ;
}

-(void)setNeedObserverKeyboard:(BOOL)needObserverKeyboard
{
    if (self.needObserverKeyboard != needObserverKeyboard){
        objc_setAssociatedObject(self, &NEEDOBSERVERKEYBOARD, needObserverKeyboard?@(YES):nil, OBJC_ASSOCIATION_RETAIN) ;
    }
}

#pragma mark-
- (void)setAdjustFrameBasicKeyboardView:(UIView *)adjustFrameBasicKeyboardView
{
    if (_adjustFrameBasicKeyboardView != adjustFrameBasicKeyboardView) {

        if (_adjustFrameBasicKeyboardView) {
            _adjustFrameBasicKeyboardView.frame = [self adjustFrameViewInitFrame];
        }

        _adjustFrameBasicKeyboardView = adjustFrameBasicKeyboardView;

        if (_adjustFrameBasicKeyboardView) {
            [self adjustViewFrameBasicKeyboard];
        }
    }
}

- (CGRect)adjustFrameViewInitFrame {
    return self.adjustFrameBasicKeyboardView.superview.bounds;
}

- (void)adjustViewFrameBasicKeyboard
{
    UIView * adjustFrameBasicKeyboardView = self.adjustFrameBasicKeyboardView;

    if (adjustFrameBasicKeyboardView) {

        if (CGRectIsEmpty(self.keyboardEndFrame)) {
            adjustFrameBasicKeyboardView.frame = [self adjustFrameViewInitFrame];
//            printf("\n1 adjustFrameBasicKey: origin(%f,%f) size(%f,%f)",adjustFrameBasicKeyboardView.frameX,
//                  adjustFrameBasicKeyboardView.frameY,adjustFrameBasicKeyboardView.frameWidth,adjustFrameBasicKeyboardView.frameHeigh) ;

        }else{

            CGFloat keyboardOriginY = [adjustFrameBasicKeyboardView.superview convertPoint:self.keyboardEndFrame.origin fromView:self.view].y;

            CGRect initFrame = [self adjustFrameViewInitFrame];
            if (CGRectGetMaxY(initFrame) > keyboardOriginY) {
                initFrame.size.height -= (CGRectGetMaxY(initFrame) - keyboardOriginY);
                initFrame.size.height = MAX(0.f, initFrame.size.height);
            }

            adjustFrameBasicKeyboardView.frame = initFrame;
//            printf("\n2 adjustFrameBasicKey: origin(%f,%f) size(%f,%f)",adjustFrameBasicKeyboardView.frameX,
//                  adjustFrameBasicKeyboardView.frameY,adjustFrameBasicKeyboardView.frameWidth,adjustFrameBasicKeyboardView.frameHeigh) ;
        }
    }

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)keyboardFrameWillChange
{
    //do nothing
}
- (void)keyboardFrameDidChange
{
    //do nothing ;
}

@end


@implementation CLBasicViewController (TapGestureRecognizer)
static char NEEDOBSERVERTAPGESTURE ;
static char TAPGESTURERECOGNIZER   ;
-(UITapGestureRecognizer*)tapGestureRecognizer
{
    UITapGestureRecognizer *tapGesture = objc_getAssociatedObject(self, &TAPGESTURERECOGNIZER) ;
    if (!tapGesture){
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)] ;
        tapGesture.delegate = self ;
        objc_setAssociatedObject(self, &TAPGESTURERECOGNIZER, tapGesture, OBJC_ASSOCIATION_RETAIN) ;
    }

    return tapGesture ;
}

-(BOOL)isNeedObserverTapGesture
{
    id value = objc_getAssociatedObject(self, &NEEDOBSERVERTAPGESTURE) ;
    return (value?[value boolValue]:FALSE) ;
}

-(void)setNeedObserverTapGesture:(BOOL)needObserverTapGesture
{
    if (self.isNeedObserverTapGesture !=needObserverTapGesture){
        if (self.isNeedObserverTapGesture)//存在旧的 ,则清除旧的手势
        {
            UITapGestureRecognizer *tapGesture = objc_getAssociatedObject(self, &TAPGESTURERECOGNIZER) ;
            if (tapGesture){
                [self.contentView removeGestureRecognizer:tapGesture] ;
                objc_setAssociatedObject(self, &TAPGESTURERECOGNIZER, nil, OBJC_ASSOCIATION_RETAIN) ;
            }
        }

        objc_setAssociatedObject(self, &NEEDOBSERVERTAPGESTURE, needObserverTapGesture?@(YES):nil, OBJC_ASSOCIATION_RETAIN) ;

        if (self.isNeedObserverTapGesture){//设置为yes
            [self.contentView addGestureRecognizer:self.tapGestureRecognizer];
        }
    }
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer
{
    //do nothing
}

@end


@implementation CLBasicViewController (Help)
-(void)showHelpView
{
    //do nothing
}
@end
