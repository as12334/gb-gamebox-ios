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

@end

@implementation RH_BasicAlertView

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
        [self addSubview:self.scrollView];
        [self addSubview:self.pageIndicator];
        self.scrollView.whc_TopSpace(20).whc_LeftSpace(10).whc_RightSpace(10).whc_BottomSpace(20);
        self.pageIndicator.whc_CenterX(0).whc_Width(100).whc_Height(10).whc_TopSpaceToView(5, self.scrollView);
        self.pageIndicator.currentPage = 0;
        self.layer.cornerRadius = 20;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
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
    
}

@end
