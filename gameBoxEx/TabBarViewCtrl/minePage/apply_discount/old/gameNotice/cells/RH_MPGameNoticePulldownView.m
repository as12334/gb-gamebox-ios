//
//  RH_MPGameNoticePulldownView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameNoticePulldownView.h"
#import "coreLib.h"
#import "RH_ServiceRequest.h"
@interface RH_MPGameNoticePulldownView()<UITableViewDelegate,UITableViewDataSource,RH_ServiceRequestDelegate>
@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong,readonly)RH_ServiceRequest *serviceRequest;
@end
@implementation RH_MPGameNoticePulldownView
@synthesize serviceRequest = _serviceRequest;
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
    return self.modelArray.count;
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
    ApiSelectModel *model = ConvertToClassPointer(ApiSelectModel, self.modelArray[indexPath.item]);
    cell.textLabel.text  = model.mApiName ;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApiSelectModel *model = ConvertToClassPointer(ApiSelectModel, self.modelArray[indexPath.item]);
    self.gameTypeString = model.mApiName;
    self.block();
}
@end
