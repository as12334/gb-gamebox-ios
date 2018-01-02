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
-(UITableViewCell*)tableViewManagement:(CLTableViewManagement *)tableViewManagement customCellAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement canDeleteCustomCellAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)tableViewManagement:(CLTableViewManagement *)tableViewManagement titleForDeleteConfirmationButtonForCustomRowAtIndexPath:(NSIndexPath *)indexPath;
//生成的cell 回调，
-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement IndexPath:(NSIndexPath *)indexPath Cell:(UITableViewCell*)cell ;

//生成section header&footer view 回调，
-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement Section:(NSInteger)section HeaderView:(UIView*)headerView ;
-(void)tableViewManagement:(CLTableViewManagement *)tableViewManagement Section:(NSInteger)section FooterView:(UIView*)footerView ;

//点击了删除自定义cell
- (void)tableViewManagement:(CLTableViewManagement *)contentViewCellController commitDeleteCustomCellAtIndexPath:(NSIndexPath *)indexPath ;

//滑动UItableview调用的方法
-(void)tableviewManagement:(CLTableViewManagement *)tableViewManagement scrollView:(UIScrollView *)scrollView;

@end

@interface CLTableViewManagement : NSObject
@property(nonatomic,weak) id<CLTableViewManagementDelegate> delegate ;

-(id)initWithTableView:(UITableView*)tableView configureFileName:(NSString*)plist bundle:(NSBundle*)bundleOrNil ;
-(void)reloadData ;
-(void)reloadDataWithPlistName:(NSString*)plistFile;
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
- (BOOL)isCustomCell    ;
- (BOOL)isPixelUnit     ;
- (NSString *)cellClassName ;
- (Class)tableViewCellClass ;

- (NSString *)sectionHeaderViewClassName ;
- (Class)tableViewSectionHeaderViewClass ;
- (NSString *)sectionFooterViewClassName ;
- (Class)tableViewSectionFooterViewClass ;
@end

