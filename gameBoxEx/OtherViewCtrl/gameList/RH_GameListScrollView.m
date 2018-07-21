//
//  RH_GameListScrollView.m
//  gameBoxEx
//
//  Created by shin on 2018/6/6.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListScrollView.h"

@interface RH_GameListScrollView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation RH_GameListScrollView

- (void)reload
{
    NSInteger pageNum = [self.datasource numberOfPagesInScrollView:self];;
    self.contentSize = CGSizeMake(self.frame.size.width*pageNum, self.frame.size.height);
    self.pagingEnabled = YES;
    
    for (int i = 0; i < pageNum; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = 1024+i;
        [self addSubview:tableView];
    }
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%li",(long)tableView.tag];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}
@end
