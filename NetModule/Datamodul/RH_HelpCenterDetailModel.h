//
//  RH_HelpCenterDetailModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"
#import <UIKit/UIKit.h>



@interface RH_HelpCenterDetailModel :RH_BasicModel
@property (nonatomic , strong , readonly) NSString              * helpContent;
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , strong , readonly) NSString              * helpTitle;
@property (nonatomic , strong , readonly) NSString              * local;
@property (nonatomic , assign , readonly) NSInteger              helpDocumentId;

/**
 是否展开
 */
@property (nonatomic, assign) BOOL isExpanded;

/**
 cell高度
 */
@property(nonatomic,assign)CGFloat cellHeight ;

@end

