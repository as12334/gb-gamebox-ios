//
//  RH_CollectionHeaderView.h
//  gameBoxEx
//
//  Created by paul on 2018/9/30.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RH_CollectionHeaderViewDelegate <NSObject>
-(void)collectionButtonClick:(UIButton*)sender;
@end
@interface RH_CollectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *collection_button;
@property (weak, nonatomic) IBOutlet UIButton *recentCollection_button;
@property (nonatomic,weak)id<RH_CollectionHeaderViewDelegate>delegate;
+(instancetype)instanceCreateCollectionHeaderView;
@end

NS_ASSUME_NONNULL_END
