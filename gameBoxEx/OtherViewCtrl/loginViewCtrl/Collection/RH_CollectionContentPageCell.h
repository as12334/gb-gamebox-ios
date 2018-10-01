//
//  RH_CollectionContentPageCell.h
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_PageLoadContentPageCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol RH_CollectionContentPageCellDelegate <NSObject>

-(void)tableViewCellDidSelected:(NSString*)url;

@end
@interface RH_CollectionContentPageCell : RH_PageLoadContentPageCell
@property (nonatomic,weak)id<RH_CollectionContentPageCellDelegate>delegate;
-(void)updateViewWithType:(NSInteger)typeModel  Context:(CLPageLoadDatasContext*)context;
@end

NS_ASSUME_NONNULL_END
