//
//  CLUserGuidePageManager.h
//  TaskTracking
//
//  Created by apple pro on 2017/4/16.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUserGuideView.h"

//----------------------------------------------------------

@class CLUserGuidePageManager;

//----------------------------------------------------------

@protocol CLUserGuidePageManagerDelegate <CLUserGuideViewDelegate>

@optional

- (void)userGuidePageManager:(CLUserGuidePageManager *)manager
        startShowPageAtIndex:(NSUInteger)pageIndex
             fromPageAtIndex:(NSUInteger)fromPageIndex;

- (void)userGuidePageManager:(CLUserGuidePageManager *)manager
          showingPageAtIndex:(NSUInteger)pageIndex
             fromPageAtIndex:(NSUInteger)fromPageIndex
                withProgress:(CGFloat)progress;

- (void)userGuidePageManager:(CLUserGuidePageManager *)manager
          didShowPageAtIndex:(NSUInteger)index
             fromPageAtIndex:(NSUInteger)fromPageIndex;

- (void)userGuidePageManager:(CLUserGuidePageManager *)manager
       cancleShowPageAtIndex:(NSUInteger)index
             fromPageAtIndex:(NSUInteger)fromPageIndex;

@end


//----------------------------------------------------------

@interface CLUserGuidePageManager : NSObject
- (id)initWithPageInfosFileName:(NSString *)infoFileName bundle:(NSBundle *)bundleOrNil;
- (id)initWithPageInfos:(NSArray *)pageInfos;

@property(nonatomic,strong,readonly) UIView * contentView;

@property(nonatomic,readonly) NSUInteger pageCount;
@property(nonatomic,readonly) NSUInteger currentPageIndex;
- (NSDictionary *)pageInfoAtIndex:(NSUInteger)index;

@property(nonatomic) BOOL bounces;

@property(nonatomic,weak) id<CLUserGuidePageManagerDelegate> delegate;

@end

//----------------------------------------------------------

@interface NSDictionary (MyUserGuidePage)

- (CLUserGuideView *)userGuidePageView;

@end
