//
//  CLTableViewManagement.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/15.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLTableViewManagement.h"
#import "MacroDef.h"
#import "NSDictionary+CLCategory.h"
#import "UITableViewCell+ShowContent.h"
#import "ScreenAdaptation.h"
#import "UITableView+Register.h"
#import "UIView+Instance.h"

@interface CLTableViewManagement()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong,readonly) UITableView *tableView ;
@property (nonatomic,strong) NSArray *sectionsInfo           ;
@property (nonatomic,strong) NSDictionary *cellsExtraInfo    ;
@end

@implementation CLTableViewManagement
@synthesize tableView = _tableView ;

-(id)initWithTableView:(UITableView*)tableView configureFileName:(NSString*)fileName bundle:(NSBundle*)bundleOrNil
{
    self = [super init] ;
    if (self){
        _tableView = ConvertToClassPointer(UITableView, tableView) ;
        if (!_tableView) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"contentScrollView必须为UITableView及其子类的实例"
                                         userInfo:nil];
        }
        
        _tableView.delegate = self      ;
        _tableView.dataSource = self    ;
        [self _initTableViewWithPlistName:fileName bundle:bundleOrNil] ;
    }
    
    return self ;
}

-(void)_initTableViewWithPlistName:(NSString*)plistFile bundle:(NSBundle*)bundleOrNil
{
    NSDictionary * configurationInfo = [NSDictionary dictionaryWithContentsOfFile:PlistResourceFilePathInBundle(bundleOrNil,plistFile)];
    _sectionsInfo = configurationInfo.sectionsInfo ;
    _cellsExtraInfo = configurationInfo.cellsExtraInfo ;
    
    //将cellClass注册为复用
    
    if (_cellsExtraInfo.tableViewCellClass){
        [_tableView registerClass:_cellsExtraInfo.tableViewCellClass forCellReuseIdentifier:_cellsExtraInfo.cellClassName] ;
    }
    
    for (int i=0; i<_sectionsInfo.count; i++)
    {
        NSDictionary *sectionInfo = [self _sectionInfoInSection:i] ;
        //增加注册 headerview,footer view
        if (sectionInfo.tableViewSectionHeaderViewClass){
            [_tableView registerHeaderFooterViewWithClass:sectionInfo.tableViewSectionHeaderViewClass
                                       andReuseIdentifier:sectionInfo.sectionHeaderViewClassName] ;
        }
        
        if (sectionInfo.tableViewSectionFooterViewClass){
            [_tableView registerHeaderFooterViewWithClass:sectionInfo.tableViewSectionFooterViewClass
                                       andReuseIdentifier:sectionInfo.sectionFooterViewClassName] ;
        }
        
        NSArray *rows = sectionInfo.rowsInfo ;
        for (int m=0; m<rows.count; m++) {
            NSDictionary *rowInfo = [self _rowInfoForIndexPath:[NSIndexPath indexPathForItem:m inSection:i]] ;
            Class cellClass = rowInfo.tableViewCellClass ;
            if (cellClass){
                [_tableView registerCellWithClass:cellClass nibNameOrNil:rowInfo.cellClassName bundleOrNil:nil
                               andReuseIdentifier:rowInfo.cellClassName] ;
                
            }
        }
    }
}

-(void)reloadDataWithPlistName:(NSString*)plistFile
{
    [self _initTableViewWithPlistName:plistFile bundle:nil];
    [self.tableView reloadData] ;
}

-(void)dealloc
{
    _tableView.delegate = nil ;
    _tableView.dataSource = nil ;
    _tableView = nil ;
    
    _sectionsInfo = nil ;
    _cellsExtraInfo = nil ;
}

-(void)reloadData
{
    [self.tableView reloadData] ;
}

-(NSDictionary*)cellExtraInfo:(NSIndexPath*)indexPath
{
    return [self _rowInfoForIndexPath:indexPath] ;
}

-(id)cellContext:(NSIndexPath*)indexPath
{
    UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath] ;
    ifRespondsSelector(tableCell, @selector(cellContext)){
        return [tableCell cellContext] ;
    }
    
    return nil ;
}

-(UITableViewCell*)cellViewAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.tableView cellForRowAtIndexPath:indexPath] ;
}

#pragma mark-tableView delegate & datasource
-(NSDictionary*)_sectionInfoInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = ConvertToClassPointer(NSDictionary, [self.sectionsInfo objectAtIndex:section]) ;
    
    NSMutableDictionary *tmpSectionInfo = [[NSMutableDictionary alloc] init] ;
    if (self.cellsExtraInfo){
        [tmpSectionInfo addEntriesFromDictionary:self.cellsExtraInfo] ;
    }
    
    if (sectionInfo){
        [tmpSectionInfo addEntriesFromDictionary:sectionInfo] ;
    }
    
    return [NSDictionary dictionaryWithDictionary:tmpSectionInfo];
}

-(NSDictionary*)_rowInfoForIndexPath:(NSIndexPath*)indexPath
{
    NSArray *rows = [self _sectionInfoInSection:indexPath.section].rowsInfo ;
    NSDictionary *rowInfo = ConvertToClassPointer(NSDictionary, rows[indexPath.item]) ;
    
    NSMutableDictionary *dictRows = [NSMutableDictionary dictionary] ;
    if (self.cellsExtraInfo){
        [dictRows addEntriesFromDictionary:self.cellsExtraInfo] ;
    }
    
    if (rowInfo){
        [dictRows addEntriesFromDictionary:rowInfo] ;
    }
    
    return dictRows ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsInfo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self _sectionInfoInSection:section].rowsInfo.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat tmp = [[self _sectionInfoInSection:section] sectionHeaderHeight:tableView.sectionHeaderHeight] ;
    if ([[self _sectionInfoInSection:section] isPixelUnit]){
        tmp = PixelToPoint(tmp) ;
    }

    return (tableView.style==UITableViewStylePlain?MAX(0,tmp):MAX(0.1, tmp));
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    CGFloat tmp = [[self _sectionInfoInSection:section] sectionFooterHeight:tableView.sectionFooterHeight] ;
    return (tableView.style==UITableViewStylePlain?MAX(0,tmp):MAX(0.1, tmp)) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* rowInfo = [self _rowInfoForIndexPath:indexPath] ;
    if ([self _rowInfoForIndexPath:indexPath].isCustomHeight) {//自定义高度cell 返回
        Class cellClass = [rowInfo tableViewCellClass];
        id context = nil ;
        ifRespondsSelector(self.delegate, @selector(tableViewManagement:cellContextAtIndexPath:)){
            context = [self.delegate tableViewManagement:self cellContextAtIndexPath:indexPath] ;
        }
    
        if (cellClass==nil){
            ifRespondsSelector(self.delegate, @selector(tableViewManagement:customCellHeightAtIndexPath:)){
                return [self.delegate tableViewManagement:self customCellHeightAtIndexPath:indexPath] ;
            }
            
            return 0.0f ;
        }else{
            return  [cellClass heightForCellWithInfo:rowInfo tableView:tableView context:context];
        }
        
    }else {
        return rowInfo.height;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionDict = ConvertToClassPointer(NSDictionary, [self.sectionsInfo objectAtIndex:section]) ;
    if (sectionDict.sectionHeaderViewClassName){
        UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionDict.sectionHeaderViewClassName] ;
        if (headerView){
            ifRespondsSelector(self.delegate, @selector(tableViewManagement:Section:HeaderView:)){
                [self.delegate tableViewManagement:self Section:section HeaderView:headerView];
            }
        }
        
        return headerView ;
    }
    return nil ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *sectionDict = ConvertToClassPointer(NSDictionary, [self.sectionsInfo objectAtIndex:section]) ;
    if (sectionDict.sectionFooterViewClassName){
        UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionDict.sectionFooterViewClassName] ;
        if (footerView){
            ifRespondsSelector(self.delegate, @selector(tableViewManagement:Section:FooterView:)){
                [self.delegate tableViewManagement:self Section:section FooterView:footerView] ;
            }
        }
        
        return footerView ;
    }
    return nil ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* rowInfo = [self _rowInfoForIndexPath:indexPath] ;
    UITableViewCell *cell = nil ;
    
    //通过 cellClass 生成
    NSString *reuseIdentifier = rowInfo.cellClassName ;
    MyAssert(reuseIdentifier.length !=0) ;
    
    id cellContent = nil ;
    ifRespondsSelector(self.delegate, @selector(tableViewManagement:cellContextAtIndexPath:)){
        cellContent = [self.delegate tableViewManagement:self cellContextAtIndexPath:indexPath];
    }
    
    if (rowInfo.isCustomCell){
        ifRespondsSelector(self.delegate, @selector(tableViewManagement:customCellAtIndexPath:)){
            cell = [self.delegate tableViewManagement:self customCellAtIndexPath:indexPath];
        }
    }
    
    if (cell==nil){ //生成实例
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    ifRespondsSelector(cell, @selector(updateCellWithInfo:context:)){
        [cell updateCellWithInfo:rowInfo context:cellContent] ;
    }
    
    if (![cell isKindOfClass:[UITableViewCell class]]){
        @throw [[NSException alloc] initWithName:NSInternalInconsistencyException
                                          reason:@"UITableViewCell类与reuseIdentifier匹配有误,请检查配置文件"
                                        userInfo:nil];
    }
    
    ifRespondsSelector(self.delegate, @selector(tableViewManagement:IndexPath:Cell:)){
        [self.delegate tableViewManagement:self IndexPath:indexPath Cell:cell] ;
    }
    
    return cell ;
}

- (BOOL)_didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL selected = NO;
    ifRespondsSelector(self.delegate, @selector(tableViewManagement:didSelectCellAtIndexPath:)){
        selected = [self.delegate tableViewManagement:self didSelectCellAtIndexPath:indexPath] ;
    }
    
    return selected;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self _didSelectCellAtIndexPath:indexPath]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(tableViewManagement:canDeleteCustomCellAtIndexPath:)) {
        if ([self.delegate tableViewManagement:self canDeleteCustomCellAtIndexPath:indexPath]) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    
    return UITableViewCellEditingStyleNone;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(tableViewManagement:titleForDeleteConfirmationButtonForCustomRowAtIndexPath:)) {
        return [self.delegate tableViewManagement:self titleForDeleteConfirmationButtonForCustomRowAtIndexPath:indexPath];
    }
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ifRespondsSelector(self.delegate, @selector(tableViewManagement:commitDeleteCustomCellAtIndexPath:)) {
            return [self.delegate tableViewManagement:self commitDeleteCustomCellAtIndexPath:indexPath];
        }
    }
}

/**
 滑动tableview调用
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ifRespondsSelector(self.delegate, @selector(tableviewManagement:scrollView:)){
        [self.delegate tableviewManagement:self scrollView:self.tableView];
    }
}
@end




#pragma mark-
@implementation NSDictionary (CLTableViewManagement)
-(NSArray*)sectionsInfo
{
    return [self arrayValueForKey:@"sectionsInfo"] ;
}

-(NSArray*)rowsInfo
{
    return [self arrayValueForKey:@"rowsInfo"] ;
}

-(NSDictionary*)cellsExtraInfo
{
    return [self dictionaryValueForKey:@"cellsExtraInfo"] ;
}

- (CGFloat)sectionHeaderHeight:(CGFloat)defaultValue {
    return [self adaptationFloatValueForKey:@"sectionHeaderHeight" defaultValue:defaultValue];
}
- (CGFloat)sectionFooterHeight:(CGFloat)defaultValue {
    return [self adaptationFloatValueForKey:@"sectionFooterHeight" defaultValue:defaultValue];
}

- (BOOL)isCustomHeight {
    return [self boolValueForKey:@"isCustomHeight" defaultValue:NO];
}

- (BOOL)isCustomCell
{
    return [self boolValueForKey:@"isCustomCell" defaultValue:NO];
}

- (BOOL)isPixelUnit
{
    return [self boolValueForKey:@"isPixelUnit" defaultValue:NO];
}

- (NSString *)cellClassName {
    return [self stringValueForKey:@"cellClass"];
}

- (Class)tableViewCellClass
{
    Class class = NSClassFromString([self cellClassName]);
    return [class isSubclassOfClass:[UITableViewCell class]] ? class : nil;
}


- (NSString *)sectionHeaderViewClassName
{
    return [self stringValueForKey:@"sectionHeaderViewClass"];
}

- (Class)tableViewSectionHeaderViewClass
{
    Class class = NSClassFromString([self sectionHeaderViewClassName]);
    return [class isSubclassOfClass:[UIView class]] ? class : nil;
}

- (NSString *)sectionFooterViewClassName
{
    return [self stringValueForKey:@"sectionFooterViewClass"];
}

- (Class)tableViewSectionFooterViewClass
{
    Class class = NSClassFromString([self sectionFooterViewClassName]);
    return [class isSubclassOfClass:[UIView class]] ? class : nil;
}

@end

