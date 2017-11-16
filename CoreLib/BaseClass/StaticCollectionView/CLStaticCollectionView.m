//
//  CLStaticCollectionView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/9.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLStaticCollectionView.h"
#import "CLLineLayer.h"
#import "MacroDef.h"
#import "UIView+FrameSize.h"
//----------------------------------------------------------

@interface _CLStaticCollectionViewSectionItem : NSObject

- (id)initWithIndexPath:(NSIndexPath*)indexPath
                   cell:(CLStaticCollectionViewCell *)cell;

@property(nonatomic,strong,readonly) NSIndexPath *indexPath ;
@property(nonatomic,strong,readonly) CLStaticCollectionViewCell * cell;
@property(nonatomic) CGRect cellFrame;

@end

//----------------------------------------------------------

@implementation _CLStaticCollectionViewSectionItem
- (id)initWithIndexPath:(NSIndexPath*)indexPath
                   cell:(CLStaticCollectionViewCell *)cell
{
    self = [super init];

    if (self) {
        _indexPath = indexPath ;
        _cell = cell    ;
    }

    return self;
}

-(id)initWithIndexPath:(NSIndexPath *)indexPath cell:(CLStaticCollectionViewCell *)cell frame:(CGRect)frame
{
    self = [super init];

    if (self) {
        _indexPath = indexPath ;
        _cell = cell    ;
        _cellFrame = frame ;
    }

    return self;
}

-(void)replaceCell:(CLStaticCollectionViewCell*)cell
{
    _cell = cell ;
}

- (void)dealloc
{
    _cell = nil ;
    _indexPath = nil ;
}

@end

//----------------------------------------------------------
#pragma MARK-
@interface CLStaticCollectionView ()
@property(nonatomic,strong,readonly) NSMutableArray  *sectionItemList ;
@property(nonatomic,strong,readonly) NSMutableArray  *highLightItemList ;
@property(nonatomic,strong) _CLStaticCollectionViewSectionItem  *selectedItemCell;
@property(nonatomic,strong,readonly) NSMutableDictionary *reusedCellPool             ;
@end

@implementation CLStaticCollectionView
{
    CALayer  *_separationLineLayer ;
    BOOL   _needMathCellframe ;

}
@synthesize sectionItemList = _sectionItemList          ;
@synthesize highLightItemList = _highLightItemList      ;
@synthesize selectedItemCell = _selectedItemCell        ;
@synthesize reusedCellPool = _reusedCellPool            ;

@synthesize separationLineWidth = _separationLineWidth ;
@synthesize separationLineInset = _separationLineInset ;
@synthesize separationLineColor = _separationLineColor ;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self){
        [self _initInfo] ;
    }

    return self ;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder] ;
    if (self){
        [self _initInfo] ;
    }

    return self ;
}

-(void)_initInfo
{
    _allowSelection = YES ;
    _allowCellSeparationLine = YES ;
    _allowSectionSeparationLine = YES ;
    _averageCellWidth = YES ;

    _separationLineWidth = PixelToPoint(1.0) ;
    [self _registerForKVO] ;
}

-(void)dealloc
{
    [self _unregisterFromKVO] ;
    [self clearAllCells] ;

    [_reusedCellPool removeAllObjects] ;
}

#pragma mark-

-(NSMutableArray*)sectionItemList
{
    if (!_sectionItemList){
        _sectionItemList = [[NSMutableArray alloc] init] ;
    }

    return _sectionItemList ;
}

-(NSMutableArray*)highLightItemList
{
    if (!_highLightItemList){
        _highLightItemList = [[NSMutableArray alloc] init] ;
    }

    return _highLightItemList ;
}

-(void)setSelectedItemCell:(_CLStaticCollectionViewSectionItem *)selectedItemCell
{
//    if (_selectedItemCell !=selectedItemCell)
    {
        if (_selectedItemCell){//存在旧的
            _selectedItemCell.cell.selected = NO ;
            [_selectedItemCell.cell setSelected:NO animated:YES] ;

            ifRespondsSelector(self.delegate, @selector(staticCollectionView:didDeselectItemAtIndexPath:)){
                [self.delegate staticCollectionView:self didDeselectItemAtIndexPath:_selectedItemCell.indexPath] ;
            }
        }

        if (selectedItemCell) //存在新的
        {
            BOOL shouldSelectedResult = YES ;
            ifRespondsSelector(self.delegate, @selector(staticCollectionView:shouldSelectItemAtIndexPath:)){
                shouldSelectedResult = [self.delegate staticCollectionView:self shouldSelectItemAtIndexPath:selectedItemCell.indexPath] ;
            }

            _selectedItemCell = selectedItemCell ;
            [_selectedItemCell.cell setSelected:YES animated:YES] ;

            if (shouldSelectedResult){
                selectedItemCell.cell.selected = YES ;
                ifRespondsSelector(self.delegate, @selector(staticCollectionView:didSelectItemAtIndexPath:)){
                    [self.delegate staticCollectionView:self didSelectItemAtIndexPath:selectedItemCell.indexPath] ;
                }
            }
        }

        _selectedItemCell = selectedItemCell ;
    }

    return  ;
}

#pragma MARK-
-(CGFloat)separationLineWidth{
    return MAX(_separationLineWidth, 0) ;
}

-(void)setSeparationLineWidth:(CGFloat)separationLineWidth
{
    if (_separationLineWidth!=separationLineWidth){
        _separationLineWidth = separationLineWidth ;

        [self setNeedsLayout] ;
    }
}

-(UIEdgeInsets)separationLineInset
{
    return _separationLineInset ;
}

-(void)setSeparationLineInset:(UIEdgeInsets)separationLineInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_separationLineInset, separationLineInset)){
        _separationLineInset = separationLineInset ;

        [self setNeedsLayout] ;
    }
}

-(UIColor *)separationLineColor
{
    return _separationLineColor?:[UIColor grayColor] ;
}

-(void)setSeparationLineColor:(UIColor *)separationLineColor
{
    if (separationLineColor){
        _separationLineColor = separationLineColor ;

        [self setNeedsLayout] ;
    }
}

#pragma mark-
- (NSIndexPath *)indexPathForSelectedItem {
    return _selectedItemCell.indexPath?:nil;
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if (self.allowSelection) {
        if (![_selectedItemCell.indexPath isEqual:indexPath]){//没有选中
            _selectedItemCell.cell.selected = NO ; //de selected old
            
            //选择
            _selectedItemCell = [self _sectionItemAtIndexPath:indexPath];
            [_selectedItemCell.cell setSelected:YES animated:animated];
        }
    }
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if ([_selectedItemCell.indexPath isEqual:indexPath]){//选中
        [_selectedItemCell.cell setSelected:NO animated:animated] ;
        _selectedItemCell = nil ;
    }
}

- (void)deselectAllItem:(BOOL)animated
{
    for (_CLStaticCollectionViewSectionItem *item in self.sectionItemList) {
        [item.cell setSelected:NO animated:animated];
    }
    
    _selectedItemCell = nil ;
}


#pragma mark-
-(void)clearAllCells
{
    for (_CLStaticCollectionViewSectionItem *item in _sectionItemList) {
        if (item.cell){
            [item.cell removeFromSuperview] ;

            //在移除前，cell 加入复用池
            [self _addReusedPool:item.cell] ;
        }
    }

    [_sectionItemList removeAllObjects]     ;
    [_highLightItemList removeAllObjects]   ;
    _selectedItemCell = nil ;
}

-(void)reloadData
{
    [self clearAllCells] ;

    NSInteger totalSections = [self countSecions] ;
    for (int m=0; m<totalSections; m++) {
        NSInteger totalItems = [self countItemsWithSection:m] ;
        for (int n=0; n<totalItems; n++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:n inSection:m] ;
            CLStaticCollectionViewCell *cell = [self genCellViewByIndexPath:indexPath] ;
            [self.sectionItemList addObject:[[_CLStaticCollectionViewSectionItem alloc] initWithIndexPath:indexPath
                                                                                                     cell:cell
                                                                                                    frame:[self _mathCellFrame:indexPath]]] ;
        }
    }

    [self setNeedsLayout] ;
}

-(void)reloadDataAtIndexPath:(NSIndexPath*)indexPath
{
    CLStaticCollectionViewCell *cell = [self genCellViewByIndexPath:indexPath] ;

    NSInteger index = [self _matchIndexPath:indexPath] ;
    if (index<self.sectionItemList.count){ //存在 则用新的替换
        _CLStaticCollectionViewSectionItem *item = [self.sectionItemList objectAtIndex:index] ;
        [item replaceCell:cell] ;
    }else{
        [self.sectionItemList addObject:[[_CLStaticCollectionViewSectionItem alloc] initWithIndexPath:indexPath
                                                                                                 cell:cell
                                                                                                frame:[self _mathCellFrame:indexPath]]] ;
    }

    [self layoutSubviews] ;
}

-(CLStaticCollectionViewCell*)cellAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger index = [self _matchIndexPath:indexPath] ;

    _CLStaticCollectionViewSectionItem *sectionItem = nil ;
    if (index<self.sectionItemList.count){
        sectionItem = [self.sectionItemList objectAtIndex:index] ;
    }

    return sectionItem.cell ;
}

-(_CLStaticCollectionViewSectionItem*)_sectionItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger index = [self _matchIndexPath:indexPath] ;
    
    _CLStaticCollectionViewSectionItem *sectionItem = nil ;
    if (index<self.sectionItemList.count){
        sectionItem = [self.sectionItemList objectAtIndex:index] ;
    }
    
    return sectionItem ;
}

-(NSInteger)_matchIndexPath:(NSIndexPath*)indexPath
{
    NSInteger index = 0 ;
    for (int i=0; i<indexPath.section; i++) {
        index += [self countItemsWithSection:i] ;
    }
    
    index += indexPath.item ;
    return index ;
}

#pragma mark- KVO
- (void)_registerForKVO
{
    for (NSString *keyPath in [self _observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)_unregisterFromKVO
{
    for (NSString *keyPath in [self _observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)_observableKeypaths {
    return @[@"bounds"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self == object &&![change[@"old"] isEqual:change[@"new"]]) {
        _needMathCellframe = YES ;
    }
}

- (void)_updateUIForKeypath:(NSString *)keyPath {
    [self setNeedsLayout];
}


#pragma MARK-
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _updateSectionCellLayout] ;
    [self _updateSeparationLineLayoutEx] ;
}

-(_CLStaticCollectionViewSectionItem*)_itemCellAtIndexPath:(NSIndexPath*)indexPath
{
    _CLStaticCollectionViewSectionItem *rtnItemCell ;
    if (!indexPath) return rtnItemCell ;

    for (_CLStaticCollectionViewSectionItem *itemCell in _sectionItemList) {
        if (itemCell.indexPath.section == indexPath.section &&
            itemCell.indexPath.item == indexPath.item)
        {
            rtnItemCell = itemCell ;
            break ;
        }
    }

    return rtnItemCell ;
}

-(void)_updateSeparationLineLayoutEx
{
    NSInteger sections = [self countSecions] ;
    //清除旧的
    _separationLineLayer.sublayers = nil;
    [_separationLineLayer removeFromSuperlayer];

    if (sections<1) return ;

    if (!_separationLineLayer) {
        _separationLineLayer = [CALayer layer];
    }

    [self.layer addSublayer:_separationLineLayer];

    ///绘制 section 间分隔线
    for (int i=0; i<sections ; i++) {
        if (i ){//section 分隔线从第二个section开始
            if (_allowSectionSeparationLine){
                _CLStaticCollectionViewSectionItem *firstItem = [self _itemCellAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]] ;
                if (firstItem){
                    CGPoint startPoint = firstItem.cellFrame.origin ;
                    CGPoint endPoint = CGPointMake(self.frameWidth - ((self.borderMask & CLBorderMarkRight)?self.borderWidth + self.borderLineInset.right :0.0f), startPoint.y) ;

                    startPoint.x += self.separationLineInset.left ;
                    endPoint.x -= self.separationLineInset.right ;

                    CLLineLayer *lineLayer = [CLLineLayer layer] ;
                    lineLayer.lineStyle = CLLineStyleNormal     ;
                    lineLayer.lineWidth = self.separationLineWidth    ;
                    lineLayer.lineColor = self.separationLineColor;
                    lineLayer.startPoint = startPoint;
                    lineLayer.endPoint = endPoint;
                    [_separationLineLayer addSublayer:lineLayer];
                }
            }
        }

        //绘制 竖向 分隔线
        NSInteger items = [self countItemsWithSection:i] ;
        if (items<1) continue ;

        if (_allowCellSeparationLine) {
            for (int m = 1; m<items; m++) { //第一个 item 绘制分隔线 从1 开始
                _CLStaticCollectionViewSectionItem *itemCell = [self _itemCellAtIndexPath:[NSIndexPath indexPathForItem:m inSection:i]] ;
                if (itemCell){
                    CGPoint startPoint = itemCell.cellFrame.origin ;
                    CGPoint endPoint = CGPointMake(startPoint.x, CGRectGetMaxY(itemCell.cellFrame)) ;
                    startPoint.y += self.separationLineInset.top ;
                    endPoint.y -= self.separationLineInset.bottom ;

                    CLLineLayer *lineLayer = [CLLineLayer layer] ;
                    lineLayer.lineStyle = CLLineStyleNormal     ;
                    lineLayer.lineWidth = self.separationLineWidth    ;
                    lineLayer.lineColor = self.separationLineColor;
                    lineLayer.startPoint = startPoint;
                    lineLayer.endPoint = endPoint;
                    [_separationLineLayer addSublayer:lineLayer];
                }
            }
        }
    }

}


-(void)_updateSeparationLineLayout
{
    NSInteger sections = [self countSecions] ;
    //清除旧的
    _separationLineLayer.sublayers = nil;
    [_separationLineLayer removeFromSuperlayer];

    if (sections<1) return ;

    if (!_separationLineLayer) {
        _separationLineLayer = [CALayer layer];
    }

    [self.layer addSublayer:_separationLineLayer];

    CGFloat validHeigh = self.frameHeigh ;
    validHeigh -= ((self.borderMask & CLBorderMarkTop)?self.borderWidth + self.borderLineInset.top :0.0f) ;
    validHeigh -= ((self.borderMask & CLBorderMarkBottom)?self.borderWidth + self.borderLineInset.bottom :0.0f) ;
    CGFloat sectionHeigh = floorf(validHeigh/sections) ;

    CGFloat validWidth = self.frameWidth ;
    validWidth -= ((self.borderMask & CLBorderMarkLeft)?self.borderWidth + self.borderLineInset.left :0.0f) ;
    validWidth -= ((self.borderMask & CLBorderMarkRight)?self.borderWidth + self.borderLineInset.right :0.0f) ;

    //绘制 section 间分隔线
    for (int i=0; i<sections ; i++) {
        CGPoint startPoint1 = CGPointMake(self.borderMask&CLBorderMarkLeft?self.borderWidth+self.borderLineInset.left :0.0f,
                                         self.borderMask&CLBorderMarkTop?self.borderWidth+self.borderLineInset.top :0.0f) ;
        CGPoint endPoint1   = CGPointMake(self.frameWidth -  (self.borderMask&CLBorderMarkRight?self.borderWidth+self.borderLineInset.right :0.0f),
                                         self.borderMask&CLBorderMarkTop?self.borderWidth+self.borderLineInset.top :0.0f) ;


        startPoint1.x += self.separationLineInset.left ;
        startPoint1.y +=  i*sectionHeigh ;

        endPoint1.x -= self.separationLineInset.right ;
        endPoint1.y = startPoint1.y ;

        if (i && _allowSectionSeparationLine)//第一个 section 绘制分隔线 从1 开始
        {
            CLLineLayer *lineLayer = [CLLineLayer layer] ;
            lineLayer.lineStyle = CLLineStyleNormal     ;
            lineLayer.lineWidth = self.separationLineWidth    ;
            lineLayer.lineColor = self.separationLineColor;
            lineLayer.startPoint = startPoint1;
            lineLayer.endPoint = endPoint1;
            [_separationLineLayer addSublayer:lineLayer];
        }

        //绘制 竖向 分隔线
        NSInteger items = [self countItemsWithSection:i-1] ;
        if (items<1) continue ;

        if (_allowCellSeparationLine) {
            //计算该section每个cell 的平均宽度
            CGFloat cellsWidth =  floorf(validWidth/items) ;
//            CGFloat scale = 0.0f ;//width weight value
            for (int m = 1; m<items; m++) { //第一个 item 绘制分隔线 从1 开始
                CGPoint startPoint2 = startPoint1 ;
                CGPoint endPoint2   = CGPointMake(startPoint1.x,
                                                  startPoint1.y+sectionHeigh) ;

                if (_averageCellWidth){
                    startPoint2.x += cellsWidth*m ;
                }

                startPoint2.y += self.separationLineInset.top ;

                endPoint2.x = startPoint2.x ;
                endPoint2.y -= self.separationLineInset.bottom ;

                CLLineLayer *lineLayer = [CLLineLayer layer] ;
                lineLayer.lineStyle = CLLineStyleNormal     ;
                lineLayer.lineWidth = self.separationLineWidth    ;
                lineLayer.lineColor = self.separationLineColor;
                lineLayer.startPoint = startPoint2;
                lineLayer.endPoint = endPoint2;
                [_separationLineLayer addSublayer:lineLayer];
            }
        }
    }
}

#define currentWeightScale              @"CurrentWeightScale"
#define totalCurrentWeightScale                @"TotaltCurrentWeightScale"
-(NSDictionary*)_cellWeightValusForIndexPath:(NSIndexPath*)indexPath
{
    NSString *widthWeights = @"" ;
    ifRespondsSelector(self.dataSource, @selector(staticCollectionView:cellWidthWeightAtIndexPath:)){
        widthWeights = [self.dataSource staticCollectionView:self cellWidthWeightAtIndexPath:indexPath.section] ;
    }

    NSArray * widthScale = [widthWeights componentsSeparatedByString:@":"];
    CGFloat totalALLScale = 0.0f ;
    CGFloat currentScale = 0.0f ;
    CGFloat totalCurrentScale  = 0.0f ;
    for (int i=0; i<widthScale.count; i++) {
        totalALLScale += [widthScale[i] floatValue] ;
        if (indexPath.item==i) {
            currentScale = [widthScale[i] floatValue] ;
            totalCurrentScale = totalALLScale - currentScale ;
        }
    }
    currentScale =  currentScale/totalALLScale ;
    totalCurrentScale = totalCurrentScale/totalALLScale ;

    return @{currentWeightScale :@(currentScale) ,
             totalCurrentWeightScale :@(totalCurrentScale) } ;
}

-(void)_updateSectionCellLayout
{
    for (_CLStaticCollectionViewSectionItem *item in _sectionItemList) {
        CLStaticCollectionViewCell *cell = item.cell ;
        if (_needMathCellframe){
            item.cellFrame = [self _mathCellFrame:item.indexPath] ;
        }

        cell.frame = item.cellFrame ;
        if (cell){
            if (!cell.superview){
                [self addSubview:cell] ;
            }
        }
    }

    _needMathCellframe = NO ;
}

-(CGRect)_mathCellFrame:(NSIndexPath*)indexPath
{
    NSInteger sections = [self countSecions] ;
    if (indexPath.section>=sections) return CGRectZero;

    CGFloat validHeigh = self.frameHeigh ;
    validHeigh -= ((self.borderMask & CLBorderMarkTop)?self.borderWidth + self.borderLineInset.top :0.0f) ;
    validHeigh -= ((self.borderMask & CLBorderMarkBottom)?self.borderWidth + self.borderLineInset.bottom :0.0f) ;
    CGFloat sectionHeigh = sections<1?validHeigh:floorf(validHeigh/sections) ;

    CGFloat validWidth = self.frameWidth ;
    validWidth -= ((self.borderMask & CLBorderMarkLeft)?self.borderWidth + self.borderLineInset.left :0.0f)  ;
    validWidth -= ((self.borderMask & CLBorderMarkRight)?self.borderWidth + self.borderLineInset.right :0.0f) ;
    NSInteger items = [self countItemsWithSection: indexPath.section] ;

    if (indexPath.item>=items) return CGRectZero ;
    CGFloat cellsWidth =  items<1?validWidth:floorf(validWidth/items) ;
    CGRect cellFrame = CGRectZero ;

    if (_averageCellWidth){
        cellFrame = CGRectMake((self.borderMask&CLBorderMarkLeft?self.borderWidth+self.borderLineInset.left :0.0f)  +
                                      indexPath.item*(cellsWidth+self.separationLineWidth),
                                      self.borderMask&CLBorderMarkTop?self.borderWidth+self.borderLineInset.top :0.0f +
                                      indexPath.section*(sectionHeigh+self.separationLineWidth) ,
                                      cellsWidth,
                                      sectionHeigh) ;
    }else{
        NSDictionary *dict = [self _cellWeightValusForIndexPath:indexPath] ;
        CGFloat currentScale = [dict[currentWeightScale] floatValue] ;
        CGFloat totalCurrentScale = [dict[totalCurrentWeightScale] floatValue] ;

        cellFrame = CGRectMake((self.borderMask&CLBorderMarkLeft?self.borderWidth+self.borderLineInset.left :0.0f)  +
                                      ceilf(validWidth*totalCurrentScale),
                                      self.borderMask&CLBorderMarkTop?self.borderWidth+self.borderLineInset.top :0.0f,
                                      ceilf(validWidth * currentScale),
                                      sectionHeigh) ;
    }

//    NSLog(@"..section:%d item:%d...or(%f,%f),size(%f,%f).",indexPath.section,indexPath.item,
//          cellFrame.origin.x,cellFrame.origin.y,cellFrame.size.width,cellFrame.size.height) ;
    return cellFrame ;
}

#pragma MARK-
-(NSInteger)countSecions
{
    NSInteger sections = 1 ;//default value

    ifRespondsSelector(self.dataSource, @selector(numberOfSectionInStaticCollectionView:)){
        sections = [self.dataSource numberOfSectionInStaticCollectionView:self] ;
    }

    return MAX(sections, 0) ;
}

-(NSInteger)countItemsWithSection:(NSInteger)section
{
    NSInteger items = 0 ;//default 0

    ifRespondsSelector(self.dataSource, @selector(staticCollectionView:numberOfItemsInSection:)){
        items = [self.dataSource staticCollectionView:self numberOfItemsInSection:section] ;
    }

    return MAX(items, 0) ;
}

-(CLStaticCollectionViewCell*)genCellViewByIndexPath:(NSIndexPath*)indexPath
{
    id<CLStaticCollectionViewDataSource> dataSource = self.dataSource;
    if (![dataSource respondsToSelector:@selector(staticCollectionView:cellForItemAtIndexPath:)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"代理必须响应消息staticCollectionView:cellForItemAtIndexPath:"
                                     userInfo:nil];
    }

    CLStaticCollectionViewCell * cell = [dataSource staticCollectionView:self cellForItemAtIndexPath:indexPath];
    cell.highlighted = NO;
    cell.selected = NO;

    if (cell && ![cell isKindOfClass:[CLStaticCollectionViewCell class]]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"staticCollectionView:cellForItemAtIndexPath:返回的cell必须为MyStaticCollectionViewCell及其子类的实例子"
                                     userInfo:nil];
    }


    return cell ;
}

#pragma mark-Touch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.allowSelection) {
        for (UITouch * touch in touches) {
            _CLStaticCollectionViewSectionItem *itemCell = [self itemCellForPoint:[touch locationInView:self]] ;
            if (itemCell) {
                if (![self.highLightItemList containsObject:itemCell]){//不包括当前cell
                    ifRespondsSelector(self.delegate, @selector(staticCollectionView:shouldHighlightItemAtIndexPath:)){
                        if (![self.delegate staticCollectionView:self shouldHighlightItemAtIndexPath:itemCell.indexPath]){
                            continue ;
                        }
                    }

                    [self.highLightItemList addObject:itemCell] ;

                    [itemCell.cell setHighlighted:YES animated:YES] ;
                    ifRespondsSelector(self.delegate, @selector(staticCollectionView:didHighlightItemAtIndexPath:)){
                        [self.delegate staticCollectionView:self didHighlightItemAtIndexPath:itemCell.indexPath] ;
                    }
                }
            }
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.allowSelection) {
        for (UITouch * touch in touches) {
            _CLStaticCollectionViewSectionItem *itemCell = [self highLightItemForPoint:[touch locationInView:self]] ;
            if (itemCell) {
                [self unHighLightCell:itemCell] ;
            }

            //选择代理处理
            itemCell = [self itemCellForPoint:[touch locationInView:self]] ;
            if (itemCell.cell){
                self.selectedItemCell = itemCell ;
            }
        }
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        _CLStaticCollectionViewSectionItem *itemCell = [self.highLightItemList lastObject] ;
        if (itemCell) {
            if (!CGRectContainsPoint(itemCell.cellFrame, [touch locationInView:self])) { //触点移出
                [self unHighLightCell:itemCell];
            }
        }
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch * touch in touches) {
        _CLStaticCollectionViewSectionItem *itemCell = [self highLightItemForPoint:[touch locationInView:self]] ;
        if (itemCell) {
#if 0
            if (!CGRectContainsPoint(itemCell.cellFrame, [touch locationInView:self])) {
                 NSLog(@"3..touchesCancelled ") ;
                [self unHighLightCell:itemCell];
            }
#else
            [self unHighLightCell:itemCell] ;
#endif
        }
    }
    
}

-(void)unHighLightCell:(_CLStaticCollectionViewSectionItem*)itemCell
{
    if ([self.highLightItemList containsObject:itemCell]){
        [self.highLightItemList removeObject:itemCell] ;

        [itemCell.cell setHighlighted:NO animated:YES] ;
        ifRespondsSelector(self.delegate, @selector(staticCollectionView:didUnHighlightItemAtIndexPath:)){
            [self.delegate staticCollectionView:self didUnHighlightItemAtIndexPath:itemCell.indexPath] ;
        }
    }
}

-(_CLStaticCollectionViewSectionItem*)highLightItemForPoint:(CGPoint)point
{
    if (CGRectContainsPoint(self.bounds, point)){
        for (_CLStaticCollectionViewSectionItem *item in self.highLightItemList) {
            if (item.cell){
                if (CGRectContainsPoint(item.cellFrame, point)){
                    return item ;
                }
            }

        }
    }

    return nil;
}

- (_CLStaticCollectionViewSectionItem *)itemCellForPoint:(CGPoint)point //通过触摸点来获取cell
{
    if (CGRectContainsPoint(self.bounds, point)){
        for (_CLStaticCollectionViewSectionItem *item in self.sectionItemList) {
            if (item.cell){
                if (CGRectContainsPoint(item.cellFrame, point)){
                    return item ;
                }
            }

        }
    }

    return nil;
}

#pragma mark-reused
-(NSMutableDictionary*)reusedCellPool
{
    if (!_reusedCellPool){
        _reusedCellPool = [[NSMutableDictionary alloc] init] ;
    }

    return _reusedCellPool ;
}

-(void)_addReusedPool:(CLStaticCollectionViewCell*)cell
{
    if (cell && cell.reuseIdentifier.length){
        NSMutableArray *reusedCells = self.reusedCellPool[cell.reuseIdentifier] ;
        if (!reusedCells){
            reusedCells = [[NSMutableArray alloc] init] ;
            [self.reusedCellPool setValue:reusedCells forKey:cell.reuseIdentifier] ;
        }

        [reusedCells addObject:cell] ;
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    CLStaticCollectionViewCell * cell = nil;

    if (identifier.length) {

        NSMutableArray * reusableCells = self.reusedCellPool[identifier];
        if (reusableCells.count) { //取出最后一个cell
            cell = [reusableCells lastObject];
            [reusableCells removeLastObject];

            //准备复用
            [cell prepareForReuse];
        }

        //无cell后移除数组
        if (reusableCells && reusableCells.count == 0) {
            [self.reusedCellPool removeObjectForKey:identifier];
        }
    }

    return cell;
}

@end
