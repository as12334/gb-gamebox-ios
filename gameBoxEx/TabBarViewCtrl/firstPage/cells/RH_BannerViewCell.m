//
//  RH_BannerViewCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/10.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BannerViewCell.h"

#define TAGNUMBER        10000

@interface RH_BannerViewCell()<KIPageViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic,readonly) KIPageView * pageView;

@property (nonatomic,strong) NSArray *bannerModels ;
@end


@implementation RH_BannerViewCell
@synthesize pageView = _pageView;

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return floorf((280.0/750.0)*tableView.frameWidth);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, 0.8f);
}

#pragma mark -

- (KIPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[KIPageView alloc] initWithFrame:self.bounds];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pageView.delegate = self;
        _pageView.infinite = YES;
        _pageView.pagingEnabled = YES;
        _pageView.cellMargin = 5.f;
        [self insertSubview:self.pageView belowSubview:self.pageControl];
    }
    
    return _pageView;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.bannerModels = ConvertToClassPointer(NSArray, context) ;
    if (self.bannerModels==nil){
        self.pageControl.numberOfPages = 1;
        
        if (_pageView) {
            [_pageView removeFromSuperview];
            _pageView = nil;
        }
        
        [self.pageView reloadData];
    }
}

#pragma mark -
- (void)setBannerModels:(NSArray *)bannerModels
{
    if (_bannerModels != bannerModels) {
        _bannerModels = bannerModels;
        self.pageControl.numberOfPages = _bannerModels.count;
        
        if (_pageView) {
            [_pageView removeFromSuperview];
            _pageView = nil;
        }
        [self.pageView reloadData];
    }
    
    if (_bannerModels.count) {
        [self.pageView flipOverWithTime:5.f];
    }
}

#pragma mark -

- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView
{
    return MAX(self.bannerModels.count,1);
}


- (KIPageViewCell *)pageView:(KIPageView *)pageView cellAtIndex:(NSInteger)index
{
    KIPageViewCell * cell = [pageView dequeueReusableCellWithIdentifier:defaultReuseDef];
    if (!cell) {
        cell = [[KIPageViewCell alloc] initWithIdentifier:defaultReuseDef];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.backgroundColor = RH_Image_DefaultBackgroundColor;
        imageView.clipsToBounds = YES;
        imageView.tag = TAGNUMBER ;
        [cell addSubview:imageView];
    }
    
    if (self.bannerModels.count > index) {
        UIImageView * imageView = (id)[cell viewWithTag:TAGNUMBER];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.bannerModels[index] thumbURL]]
                     placeholderImage:ImageWithName(@"default_banner.jpg")] ;
    }else{
        UIImageView * imageView = (id)[cell viewWithTag:TAGNUMBER];
        [imageView setImage:ImageWithName(@"default_banner.jpg")] ;
    }
    
    return cell;
}

- (void)pageView:(KIPageView *)pageView didDisplayPage:(NSInteger)pageIndex
{
    self.pageControl.currentPage = pageIndex;
}

- (void)pageView:(KIPageView *)pageView didSelectedCellAtIndex:(NSInteger)index
{
    id<RH_ShowBannerDetailDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(object:wantToShowBannerDetail:)){
        [delegate object:self wantToShowBannerDetail:self.bannerModels.count?self.bannerModels[index]:nil];
    }
}

@end
