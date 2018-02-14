//
//  CLPageView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/3/14.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLPageView.h"
#import "UICollectionView+register.h"
#import "MacroDef.h"

//----------------------------------------------------------

@interface CLPageView () < UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource >

@property(nonatomic,strong) UICollectionView * collectionView;

@end

//----------------------------------------------------------

@implementation CLPageView
{
    //数据是否有效
    BOOL _dataVaild;
    BOOL _ignoreScroll;
}

@synthesize pagesCount = _pagesCount;
@synthesize dispalyPageIndex = _dispalyPageIndex;

#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup_CLPageView];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame scrollDirection:CLPageViewScrollDirectionHorizontal];
}

- (id)initWithFrame:(CGRect)frame scrollDirection:(CLPageViewScrollDirection)scrollDirection
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollDirection = scrollDirection;
        [self _setup_CLPageView];
    }

    return self;
}

- (void)_setup_CLPageView
{
    self.clipsToBounds = YES;

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = (self.scrollDirection == CLPageViewScrollDirectionHorizontal) ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0.f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    if (self.scrollDirection == CLPageViewScrollDirectionHorizontal) {
        self.collectionView.alwaysBounceHorizontal = YES;
    }else {
        self.collectionView.alwaysBounceVertical = YES;
    }
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

#pragma mark -

- (void)_loadDataIfNeed
{
    if (!_dataVaild) {
        _dataVaild = YES;

        _pagesCount = 1;
        id<CLPageViewDatasource> dataSource = self.dataSource;
        ifRespondsSelector(dataSource, @selector(numberOfPagesInPageView:)) {
            _pagesCount = [dataSource numberOfPagesInPageView:self];
        }

        _dispalyPageIndex = _pagesCount ? 0 : NSNotFound;
    }
}

- (NSUInteger)pagesCount
{
    [self _loadDataIfNeed];
    return _pagesCount;
}

- (NSUInteger)dispalyPageIndex
{
    [self _loadDataIfNeed];
    return _dispalyPageIndex;
}

#define IndexPathForPageIndex(index) [NSIndexPath indexPathForItem:0 inSection:index]
#define PageIndexForIndexPath(indexPath) (indexPath.section)

- (void)setDispalyPageIndex:(NSUInteger)dispalyPageIndex
{
    //核对索引
    if (dispalyPageIndex >= self.pagesCount) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"dispalyPageIndex应小于页面总数"
                                     userInfo:nil];
    }

    //设置索引并移动到目标位置
    _dispalyPageIndex = dispalyPageIndex;

    //移动到显示
    _ignoreScroll = YES;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView scrollToItemAtIndexPath:IndexPathForPageIndex(dispalyPageIndex)
                                atScrollPosition:self.scrollDirection == CLPageViewScrollDirectionHorizontal ? UICollectionViewScrollPositionLeft : UICollectionViewScrollPositionTop
                                        animated:NO];
    self.collectionView.scrollEnabled = YES;
    _ignoreScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pagesCount && !_ignoreScroll) {

        //计算目标page
        NSInteger desPageIndex = 0;
        if (self.scrollDirection == CLPageViewScrollDirectionHorizontal) {
            desPageIndex = roundf(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
        }else {
            desPageIndex = roundf(scrollView.contentOffset.y / CGRectGetHeight(scrollView.frame));
        }

        desPageIndex = ChangeInMinToMax(desPageIndex, 0.f, self.pagesCount - 1);
        if (self.dispalyPageIndex != desPageIndex) {

            NSUInteger prevPageIndex = self.dispalyPageIndex;
            _dispalyPageIndex = desPageIndex;

            id<CLPageViewDelegate> delegate = self.delegate;
            ifRespondsSelector(delegate, @selector(pageView:didEndDisplayPageAtIndex:)) {
                [delegate pageView:self didEndDisplayPageAtIndex:prevPageIndex];
            }

            ifRespondsSelector(delegate, @selector(pageView:didDisplayPageAtIndex:)) {
                [delegate pageView:self didDisplayPageAtIndex:desPageIndex];
            }
        }
    }

    //代理消息转发
    id<CLPageViewDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(scrollViewDidScroll:)) {
        [delegate scrollViewDidScroll:scrollView];
    }

}


#pragma mark -

- (void)reloadPages:(BOOL)keepDispalyPage
{
    if (_dataVaild) {
        _dataVaild = NO;

        _ignoreScroll = YES;

        //记录当前的索引
        NSUInteger dispalyPageIndex = _dispalyPageIndex;

        //重新加载数据
        [self.collectionView reloadData];

        //移动到目标位置
        self.collectionView.scrollEnabled = NO;
        if (keepDispalyPage && dispalyPageIndex < self.pagesCount) {
            _dispalyPageIndex = dispalyPageIndex;
            self.collectionView.contentOffset = [self _contentOffsetForPageAtIndex:dispalyPageIndex];
        }else {
            self.collectionView.contentOffset = CGPointZero;
        }
        self.collectionView.scrollEnabled = YES;


        _ignoreScroll = NO;
    }
}

#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];

    //frame大小改变重新加载页面的尺寸
    [self _reoladPageSize:NO];
}

- (CGRect)_collectionViewFrame
{
    CGRect collectionViewFrame = self.bounds;
    if (self.scrollDirection == CLPageViewScrollDirectionHorizontal) {
        collectionViewFrame.size.width += self.pageMargin;
    }else {
        collectionViewFrame.size.height += self.pageMargin;
    }

    return collectionViewFrame;
}

- (CGPoint)_contentOffsetForPageAtIndex:(NSUInteger)index
{
    if (self.pagesCount == 0) {
        return CGPointZero;
    }else if (self.scrollDirection == CLPageViewScrollDirectionHorizontal) {
        return CGPointMake(CGRectGetWidth(self.collectionView.frame) * index, 0.f);
    }else {
        return CGPointMake(0.f, CGRectGetHeight(self.collectionView.frame) * index);
    }
}

- (void)_reoladPageSize:(BOOL)force
{
    CGRect collectionViewFrame = [self _collectionViewFrame];
    if (force || !CGRectEqualToRect(collectionViewFrame, self.collectionView.frame)) {

        _ignoreScroll = YES;

        //重新加载数据并移动到目标位置
        [self.collectionView reloadData];
        self.collectionView.frame = collectionViewFrame;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.contentOffset = [self _contentOffsetForPageAtIndex:self.dispalyPageIndex];
        self.collectionView.scrollEnabled = YES;

        _ignoreScroll = NO;
    }
}

- (void)setPageMargin:(CGFloat)pageMargin
{
    pageMargin = MAX(0, pageMargin);
    if (_pageMargin != pageMargin) {
        _pageMargin = pageMargin;

        if (_dataVaild) { //如果数据有效，重新加载页面尺寸
            [self _reoladPageSize:YES];
        }else {
            self.collectionView.frame = [self _collectionViewFrame];
        }
    }
}

#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets sectionInset = UIEdgeInsetsZero;
    if (self.scrollDirection == CLPageViewScrollDirectionHorizontal) {
        sectionInset.right += self.pageMargin;
    }else {
        sectionInset.bottom += self.pageMargin;
    }

    return sectionInset;
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.pagesCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = nil;
    id<CLPageViewDatasource> dataSource = self.dataSource;
    ifRespondsSelector(dataSource, @selector(pageView:cellForPageAtIndex:)) {
        cell = [dataSource pageView:self cellForPageAtIndex:PageIndexForIndexPath(indexPath)];
    }

//    if (cell == nil) {
//        @throw [NSException exceptionWithName:NSInternalInconsistencyException
//                                       reason:@"pageView:cellForPageAtIndex:必须返回非nil的cell"
//                                     userInfo:nil];
//    }

    return cell;
}

#pragma mark -

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    id<CLPageViewDelegate> delegate = self.delegate;
//    ifRespondsSelector(delegate, @selector(pageView:didSelectedPageAtIndex:)) {
//        [delegate pageView:self didSelectedPageAtIndex:PageIndexForIndexPath(indexPath)];
//    }
//
//    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//}

#pragma mark -

- (id)cellForPageAtIndex:(NSUInteger)pageIndex {
    return [self.collectionView cellForItemAtIndexPath:IndexPathForPageIndex(pageIndex)];
}

- (NSUInteger)indexForPageCell:(UICollectionViewCell *)cell {
    return PageIndexForIndexPath([self.collectionView indexPathForCell:cell]);
}

#pragma mark -

- (void)registerCellForPage:(Class)cellClass {
    [self registerCellForPage:cellClass andReuseIdentifier:nil];
}

- (void)registerCellForPage:(Class)cellClass andReuseIdentifier:(NSString *)identifier {
    [self registerCellForPage:cellClass nibNameOrNil:nil bundleOrNil:nil andReuseIdentifier:identifier];
}

- (void)registerCellForPage:(Class)cellClass
               nibNameOrNil:(NSString *)nibNameOrNil
                bundleOrNil:(NSBundle *)bundleOrNil
         andReuseIdentifier:(NSString *)reuseIdentifier
{
    [self.collectionView registerCellWithClass:cellClass
                                  nibNameOrNil:nibNameOrNil
                                   bundleOrNil:bundleOrNil
                            andReuseIdentifier:reuseIdentifier];
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forPageIndex:(NSUInteger)pageIndex {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:IndexPathForPageIndex(pageIndex)];
}

#pragma mark - 代理消息转发

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [super methodSignatureForSelector:aSelector] ?: [(id)self.delegate methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    id delegate = self.delegate;
    if ([delegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:delegate];
    }else{
        [super forwardInvocation:anInvocation] ;
    }
}

@end

