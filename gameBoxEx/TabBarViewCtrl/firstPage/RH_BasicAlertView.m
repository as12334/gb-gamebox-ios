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
@interface RH_BasicAlertView() <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIPageControl *pageIndicator;
@property (nonatomic, strong) UIButton      *cancelButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RH_BasicAlertView
{
    UIView *contentView;
    NSArray *contents;
}
@synthesize tableView = _tableView;

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
//        _scrollView.backgroundColor = [UIColor blackColor];
    }
    return _scrollView;
}



- (instancetype)init {
    self = [super init];
    if (self) {
        contentView = [UIView new];
        [self addSubview:contentView];
        contentView.whc_Center(0, 0).whc_Width(310).whc_Height(426);
        contentView.backgroundColor = colorWithRGB(242, 242, 242);
        contentView.transform = CGAffineTransformMakeScale(0, 0);

        contentView.layer.cornerRadius = 10;
        contentView.clipsToBounds = YES;
        self.backgroundColor = ColorWithRGBA(134, 134, 134, 0.3);
        
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        label.whc_CenterX(0).whc_TopSpace(15).whc_LeftSpace(30).whc_RightSpace(30);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = colorWithRGB(51, 51, 51);
        label.text = @"公告";
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setImage:ImageWithName(@"home_announce_close") forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
        self.cancelButton.whc_TopSpaceToView(5, contentView).whc_CenterX(0).whc_Width(70).whc_Height(70);
        self.cancelButton.layer.cornerRadius = 35;
        self.clipsToBounds = YES;
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
    contents = [NSArray array];
    contents = content;
//    for (int i = 0; i < content.count; i++) {
//        RH_AnnouncementModel *model = content[i];
//        UITextView *textView = [[UITextView alloc] init];
//        textView.backgroundColor = colorWithRGB(255, 255, 255);
//        textView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//        [self.scrollView addSubview:textView];
//        textView.textColor = colorWithRGB(51, 51, 51);
//        textView.editable = NO;
//        textView.font = [UIFont systemFontOfSize:14.f];
//        textView.text = model.mContent;
//
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * content.count, 0);
//    }
    [contentView addSubview:self.tableView];
    self.tableView.whc_TopSpace(39).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(15);
    self.tableView.tableFooterView = [UIView new];
    [UIView animateWithDuration:0.3 animations:^{
        contentView.transform = CGAffineTransformIdentity;
        self.cancelButton.alpha = 1;
    }];
}

#pragma mark uitableViewdelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        RH_AnnouncementModel *model = contents[indexPath.row];
        cell.textLabel.text = model.mContent;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = colorWithRGB(102, 102, 102);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        UIImageView *imageB = [UIImageView new];
        [cell.contentView addSubview:imageB];
        imageB.image = ImageWithName(@"line-notic");
        imageB.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_Height(1);
    }
    return cell;
}


@end
