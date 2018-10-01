//
//  CLBasicViewController.h
//  CoreLib
//
//  Created by jinguihua on 2017/2/8.
//  Copyright © 2017年 GIGA. All rights reserved.
//

#import "CLViewController.h"
#import "CLRefreshControl.h"
#import "CLBorderView.h"
#import "MacroDef.h"
#import "help.h"
#import "CLNavigationBar.h"

#define heighStatusBar          (GreaterThanIOS11System ? (MainScreenH==812||MainScreenH==896)?44.0:20.0 : 20.0f)
#define heighNavigationBar      44.0f
#define heighTabBar             (GreaterThanIOS11System ? (MainScreenH==812||MainScreenH==896)?82.0:49: 49.0f)

@interface CLBasicViewController : CLViewController
{
    @private
    CGRect _keyboardEndFrame ;
    NSTimeInterval _keyboardAnimationDuration       ;
    UIViewAnimationCurve _keyboardAnimationCurve    ;
    UIView *_adjustFrameBasicKeyboardView           ;
}
@property(nonatomic,strong,readonly) UIView *contentView ;
#pragma mark-navigation Bar
@property(nonatomic,strong,readonly) CLNavigationBar *navigationBar ;
@property(nonatomic,strong,readonly) UINavigationItem *navigationBarItem ;
@property(nonatomic,assign,getter=isHiddenNavigationBar) BOOL hiddenNavigationBar ;

+(void)configureNavigationBar:(UINavigationBar*)navigationBar ;
-(BOOL)hasNavigationBar ;

@end


//======================================
/**
 * topview
 */
//======================================
@interface CLBasicViewController (TopView)
@property(nonatomic,strong,readonly) CLBorderView *topView ;
-(BOOL)hasTopView ;
-(BOOL)topViewIncludeStatusBar ;
-(CGFloat)topViewHeight ;
-(void)updateTopView ;
@end

//======================================
/**
 * Bottom View
 */
//======================================
@interface CLBasicViewController (BottomView)
@property(nonatomic,strong,readonly) CLBorderView *bottomView ;
-(BOOL)hasBottomView ;
-(CGFloat)bottomViewHeight ;
-(void)updateBottomView ;
@end


//======================================
/**
 * contentTableView
 */
//======================================
@interface CLBasicViewController (ContentTableView)<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *contentTableView ;
-(UITableView*)createTableViewWithStyle:(UITableViewStyle)tableViewStyle
                          updateControl:(BOOL)bUpdateControl
                            loadControl:(BOOL)bLoadControl;
@end

//======================================
/**
 * contentCollectionView
 */
//======================================
@interface CLBasicViewController (ContentCollectionView)<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView *contentCollectionView ;
-(UICollectionView*)createCollectionViewWithLayout:(UICollectionViewLayout*)collectionViewLayout
                                     updateControl:(BOOL)bUpdateControl
                                       loadControl:(BOOL)bLoadControl ;
@end


//======================================
/**
 * refreshDataControl
 */
//======================================
@interface CLBasicViewController (RefreshDataControl)
@property(nonatomic,readonly,strong) CLRefreshControl *updateRefreshCtrl ;
@property(nonatomic,readonly,strong) CLRefreshControl *loadRefreshCtrl  ;
-(UIEdgeInsets)refreshControlLocationOffset ;

-(void)startUpdateHandle ;
-(void)endUpdateHandle ;

-(void)startLoadHandle ;
-(void)endLoadHandle ;

-(void)beginUpdateRefresh ;
@end

//======================================
/**
 * fullscreen Model
 */
//======================================
@interface CLBasicViewController (FullScreenModel)
@property(nonatomic,weak) UIScrollView *contentScrollView ;
@property(nonatomic,getter=isFullScreen) BOOL fullScreen ;

-(BOOL)isSupportFullScreenModel ;
-(BOOL)fullScreenIncludeTopView ;
-(BOOL)fullScreenIncludeBottomView ;


-(CGRect)contentScrollViewFrameWithFullScreenModel:(BOOL)fullScreen ;
-(UIEdgeInsets)contentScrollViewEdgeInsetsWithFullScreenModel:(BOOL)fullScreen ;
-(UIEdgeInsets)contentScrollViewIndicatorContentEdgeInsetsWithFullScreenModel:(BOOL)fullScreen ;

-(void)contentScrollViewWithFullScreenModel:(BOOL)fullScreen ;
@end

//======================================
/**
 * keyboard observer
 */
//======================================

@interface CLBasicViewController (Keyboard)
@property(nonatomic,assign) BOOL needObserverKeyboard ;
@property(nonatomic,readonly) CGRect keyboardEndFrame;
@property(nonatomic,readonly) NSTimeInterval keyboardAnimationDuration;
@property(nonatomic,readonly) UIViewAnimationCurve keyboardAnimationCurve;

- (void)keyboardFrameWillChange;
- (void)keyboardFrameDidChange;

//需要基于键盘改变frame的视图，需要needObserveKeyboardFrameChange不为NO
@property(nonatomic,weak) UIView * adjustFrameBasicKeyboardView;

//初始frmae,即无键盘时的frame
- (CGRect)adjustFrameViewInitFrame;

//
- (void)adjustViewFrameBasicKeyboard;

@end

//======================================
/**
 * UITapGestureRecognizer observer
 */
//======================================

@interface CLBasicViewController (TapGestureRecognizer)<UIGestureRecognizerDelegate>
@property(nonatomic,assign,getter=isNeedObserverTapGesture) BOOL needObserverTapGesture ;
-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer ;
@end

//======================================
/**
 * 帮助模块
 */
//======================================
@interface CLBasicViewController(Help)
//显示帮助视图
-(void)showHelpView ;
@end




