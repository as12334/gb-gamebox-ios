//
//  RH_BasicAlertView.m
//  gameBoxEx
//
//  Created by Lenny on 2018/1/3.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicAlertView.h"
#import "coreLib.h"
#import "RH_AnnouncementModel.h"
@interface RH_BasicAlertView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageIndicator;
@property (nonatomic, strong) UIButton      *cancelButton;
@end

@implementation RH_BasicAlertView
{
    UIView *contentView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
//        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}

- (UIPageControl *)pageIndicator {
    if (_pageIndicator == nil) {
        _pageIndicator = [[UIPageControl alloc] init];
        _pageIndicator.tintColor = [UIColor grayColor];
        _pageIndicator.pageIndicatorTintColor = [UIColor blackColor];
        _pageIndicator.currentPageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageIndicator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        contentView = [UIView new];
        [self addSubview:contentView];
        contentView.whc_Center(0, 0).whc_Width(screenSize().width/3*2).whc_Height(200);
        contentView.backgroundColor = RH_View_DefaultBackgroundColor;
        contentView.transform = CGAffineTransformMakeScale(0, 0);
        [contentView addSubview:self.scrollView];
        [contentView addSubview:self.pageIndicator];
        self.scrollView.whc_TopSpace(20).whc_LeftSpace(10).whc_RightSpace(10).whc_BottomSpace(20);
        self.scrollView.delegate = self;
        self.pageIndicator.whc_CenterX(0).whc_Width(100).whc_Height(10).whc_TopSpaceToView(5, self.scrollView);
        self.pageIndicator.currentPage = 0;
        contentView.layer.cornerRadius = 20;
        contentView.clipsToBounds = YES;
        self.backgroundColor = ColorWithRGBA(134, 134, 134, 0.3);
        self.cancelButton = [[UIButton alloc] init];
        [self addSubview:self.cancelButton];
        self.cancelButton.whc_TopSpaceToView(20, contentView).whc_CenterX(0).whc_Width(70).whc_Height(70);
        self.cancelButton.layer.cornerRadius = 35;
        self.clipsToBounds = YES;
        self.cancelButton.backgroundColor = [UIColor purpleColor];
        self.cancelButton.alpha = 0;
        [self.cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)cancelButtonDidTap:(UIButton *)button {
    
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        contentView.alpha = 0.1;
        self.cancelButton.alpha = 0.1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showContentWith:(NSArray *)content {
    [self layoutIfNeeded];
    if (content.count == 0) {
        return;
    }
    self.pageIndicator.numberOfPages = content.count;
    for (int i = 0; i < content.count; i++) {
        RH_AnnouncementModel *model = content[i];
        UITextView *textView = [[UITextView alloc] init];
        textView.backgroundColor = colorWithRGB(151, 151, 151);
        textView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:textView];
        textView.text = model.mContent;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * content.count, 0);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformIdentity;
        self.cancelButton.alpha = 1;
    }];
}
#pragma mark - scrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = (scrollView.contentOffset.x + 5) / scrollView.bounds.size.width;
    self.pageIndicator.currentPage = index;
}
@end
