//
//  RH_ShareAnnounceView.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareAnnounceView.h"
#import "coreLib.h"
#import "RH_BasicAlertViewCell.h"
#import "RH_SharePlayerRecommendModel.h"
@interface RH_ShareAnnounceView() <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton      *cancelButton;
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation RH_ShareAnnounceView
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
        [_tableView registerCellWithClass:[CLTableViewCell class]] ;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone ;
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
        label.text = @"活动公告";
        self.cancelButton = [[UIButton alloc] init];
        if ([THEMEV3 isEqualToString:@"green"]){
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_green") forState:UIControlStateNormal];
        }else if ([THEMEV3 isEqualToString:@"red"]){
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_red") forState:UIControlStateNormal];
            
        }else if ([THEMEV3 isEqualToString:@"black"]){
            //shaole
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_black") forState:UIControlStateNormal];
        }else{
            [self.cancelButton setImage:ImageWithName(@"home_announce_close_default") forState:UIControlStateNormal];
        }
        
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
        contentView.alpha = 0.3;
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
    if (contents == nil) {
        contents = [[NSArray alloc] init];
    }
    
    contents = [content copy];
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
    self.tableView.estimatedRowHeight = 56;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RH_BasicAlertViewCell  *cell = [[RH_BasicAlertViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.contentLabel.text = contents[indexPath.row];
    UIImageView *imageB = [UIImageView new];
    [cell.contentView addSubview:imageB];
    imageB.image = ImageWithName(@"line-notic");
    imageB.whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0).whc_Height(1);
    cell.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    return cell;
}

@end
