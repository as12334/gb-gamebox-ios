//
//  RH_BasicViewController.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "coreLib.h"
#import "CLImagePickerViewController.h"
#import "RH_ServiceRequest.h"
#import "RH_LoadingIndicateView.h"
#import "RH_LoadingIndicateTableViewCell.h"
#import "RH_LoadingIndicaterCollectionViewCell.h"
#import "RH_ErrorCode.h"
#import "RH_APPDelegate.h"
#import "RH_userInfoView.h"

typedef void(^CalendaCompleteBlock)(NSDate *returnDate) ;

@interface RH_BasicViewController : CLBasicViewController
{
    @private
    CalendaCompleteBlock _calendarCompleteBlock ;
    RH_LoadingIndicateView *_contentLoadingIndicateView ;
    RH_LoadingIndicateTableViewCell *_loadingIndicateTableViewCell ;
    RH_LoadingIndicaterCollectionViewCell *_loadingIndicateCollectionViewCell ;

    CLScanImageView __weak * _scanImageView;

    //数据存储
    BOOL _supportSavaData  ;
    id _observeForSavaData ;
    NSMutableSet           * _needSavaDataKeys;
}

@property(nonatomic,readonly,strong) RH_ServiceRequest *serviceRequest ;
@property(nonatomic,readonly,strong) RH_LoadingIndicateView *contentLoadingIndicateView ;
@property(nonatomic,readonly,strong) RH_LoadingIndicateTableViewCell *loadingIndicateTableViewCell ;
@property(nonatomic,readonly,strong) RH_LoadingIndicaterCollectionViewCell *loadingIndicateCollectionViewCell ;
@property(nonatomic,readonly,weak)  RH_APPDelegate *appDelegate ;

@property(nonatomic,readonly,strong) UIBarButtonItem *backButtonItem       ;
@property(nonatomic,readonly,strong) UIBarButtonItem *loginButtonItem       ;
@property(nonatomic,readonly,strong) UIBarButtonItem *tryLoginButtonItem    ;
@property(nonatomic,readonly,strong) UIBarButtonItem *signButtonItem        ;
@property(nonatomic,readonly,strong) UIBarButtonItem *logoButtonItem        ;
@property(nonatomic,readonly,strong) UIBarButtonItem *userInfoButtonItem    ;
@property (nonatomic,strong,readonly) RH_userInfoView *userInfoView ;

-(void)mainMenuButtonItemHandle ;

-(CGPoint)contentLoadingIndicateViewAdditionalOffset ;
-(void)configureContentLoadingIndicateView:(RH_LoadingIndicateView*)contentLoadingIndicateView ;
-(void)backBarButtonItemHandle      ;
-(void)userInfoButtonItemHandle ;

#pragma mark-
-(void)tryLoginButtonItemHandle ;
-(void)loginButtonItemHandle    ;
-(void)signButtonItemHandle     ;
@end


@interface RH_BasicViewController (ShowCalendar)<CLCalendarViewDelegate>
-(void)showCalendarView:(NSString*)title
         initDateString:(NSString*)dateStr
           comfirmBlock:(CalendaCompleteBlock)completeBlock;

-(void)hideCalendarViewWithAnimated:(BOOL)bAnimated ;

@end


@interface RH_BasicViewController (ImagePickerViewController)<CLImagePickerControllerDelegate,DNImagePickerControllerDelegate>
- (UIActionSheet *)showImagePickerActionSheetWithTitle:(NSString *)title ;
- (UIActionSheet *)showImagePickerActionSheetWithTitle:(NSString *)title
                                    selectedImageCount:(NSUInteger)selectedImageCount
                               showMultipleImagePicker:(BOOL)showMultipleImagePicker  ;
@end



//======================================
/**
 * 间隔动画
 */
//======================================

@interface RH_BasicViewController(IntervalAnimation)

- (void)startDefaultShowIntervalAnimation;
- (void)startDefaultShowIntervalAnimation_async:(void(^)(void))block;

- (void)startIntervalAnimationWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                             completedBlock:(void(^)(BOOL finished))completedBlock;

- (void)startIntervalAnimationWithDirection:(CLMoveAnimtedDirection)moveAnimtedDirection
                                      delay:(NSTimeInterval)delay
                             completedBlock:(void(^)(BOOL finished))completedBlock;

- (NSTimeInterval)defaultIntervalAnimationDuration;

@end


//======================================
/**
 * 浏览图片
 */
//======================================
@interface RH_BasicViewController (ImageScan) < CLScanImageDelegate,CLScanImageViewDelegate >

//浏览图片的视图
@property(nonatomic,weak,readonly) CLScanImageView * scanImageView;

//是否可以显示图片浏览视图
- (BOOL)canShowScanImageViewWithContext:(id)context;
//将要开始浏览图片，返回YES则开始
- (BOOL)willScanImageWithContext:(id)context;

//开始浏览图片（单图）
- (BOOL)startScanImage:(CLScanImageData *)image configureBlock:(void(^)(CLScanImageView * scanImageView))configureBlock;
//开始浏览图片（多图）
- (BOOL)startScanImagesWithDataSource:(id<CLScanImageViewDataSource>)dataSource
                           beginIndex:(NSUInteger)beginIndex
                              context:(id)context
                       configureBlock:(void(^)(CLScanImageView * scanImageView))configureBlock;

@end



//======================================
/**
 * 数据储存
 */
//======================================

@interface RH_BasicViewController (SavaData)
//是否支持储存数据，默认为NO，
@property(nonatomic,getter = isSupportSavaData) BOOL supportSavaData;

//设置某一key标识的数据需要被储存
- (void)setNeedSavaDataForKey:(NSString *)key;

//储存某一key的数据，调用了setNeedSavaDataForKey方法后，会在应用变为未激活时调用该方法进行数据储存，默认实现是通过needSaveDataForKey方法返回需要储存的数据并通过MyDocumentCachePool进行数据的临时储存,可重载进行自定义储存
- (void)saveDataForKey:(NSString *)key;
//返回标识为key的需要储存的数据,默认返回nil
- (id<NSCoding>)needSaveDataForKey:(NSString *)key;
//数据是否需要临时缓存，临时缓存的数据会在某些特定情况被自动清除，默认为YES
- (BOOL)needTempSaveDataForKey:(NSString *)key;

@end


/*
 */
//@interface UIViewController (MainTabBarControllerEx)
//- (RH_MainTabBarControllerEx *)myTabBarControllerEx ;
//@end

