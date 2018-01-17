//
//  RH_MPGameNoticePulldownView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameNoticePulldownView.h"
#import "coreLib.h"
@interface RH_MPGameNoticePulldownView()<UITableViewDelegate,UITableViewDataSource>
@end
@implementation RH_MPGameNoticePulldownView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tabelView];
    }
    return self;
}
-(UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tabelView;
}
#pragma mark set方法
-(void)setModelArray:(NSArray<ApiSelectModel *> *)modelArray
{
    if (![_modelArray isEqual: modelArray]) {
        _modelArray = modelArray;
    }
}
#pragma mark-
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_number==1) {
        return 7;
    }
    else if (_number==2){
    return self.modelArray.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_number==1) {
        NSArray *array = @[@"今天",@"昨天",@"本周",@"上周",@"本月",@"最近七天",@"最近三十天"];
        cell.textLabel.text = array[indexPath.row];
    }
    else if (_number==2){
    ApiSelectModel *model = ConvertToClassPointer(ApiSelectModel, self.modelArray[indexPath.item]);
    cell.textLabel.text  = model.mApiName ;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_number==2) {
        ApiSelectModel *model = ConvertToClassPointer(ApiSelectModel, self.modelArray[indexPath.item]);
        self.gameTypeString = model.mApiName;
        self.block(model.mApiId);
    }
    else if (_number==1){
        self.kuaixuanBlock(indexPath.row);
    }
    
}
@end
