//
//  CLTableViewManagement.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/15.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class  CLTableViewManagement ;
@protocol CLTableViewManagementDelegate <NSObject>
@optional
- (id)tableViewManagement:(CLTableViewManagement *)tableViewManagement cellContextAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement canDeleteCustomCellAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)tableViewManagement:(CLTableViewManagement *)tableViewManagement titleForDeleteConfirmationButtonForCustomRowAtIndexPath:(NSIndexPath *)indexPath;
//生成的cell 回调，
-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell ;


//点击了删除自定义cell
- (void)tableViewManagement:(CLTableViewManagement *)contentViewCellController commitDeleteCustomCellAtIndexPath:(NSIndexPath *)indexPath ;

@end

@interface CLTableViewManagement : NSObject
@property(nonatomic,weak) id<CLTableViewManagementDelegate> delegate ;

-(id)initWithTableView:(UITableView*)tableView configureFileName:(NSString*)plist bundle:(NSBundle*)bundleOrNil ;
-(void)reloadData ;
-(NSDictionary*)cellExtraInfo:(NSIndexPath*)indexPath ;
-(id)cellContext:(NSIndexPath*)indexPath ;
-(UITableViewCell*)cellViewAtIndexPath:(NSIndexPath*)indexPath ;
@end


@interface NSDictionary (CLTableViewManagement)
-(NSArray*)sectionsInfo ;
-(NSArray*)rowsInfo ;
-(NSDictionary*)cellsExtraInfo ;
- (CGFloat)sectionHeaderHeight:(CGFloat)defaultValue ;
- (CGFloat)sectionFooterHeight:(CGFloat)defaultValue ;
- (BOOL)isCustomHeight  ;
- (NSString *)cellClassName ;
- (Class)tableViewCellClass ;

@end
