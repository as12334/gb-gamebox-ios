//
//  RH_SiteSendMessagePullDownView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/16.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteSendMessagePullDownView.h"
#import "coreLib.h"
@interface RH_SiteSendMessagePullDownView()<UITableViewDelegate,UITableViewDataSource>
@end
@implementation RH_SiteSendMessagePullDownView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 4.f;
        self.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
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
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
        _tabelView.separatorColor = colorWithRGB(242 , 242, 242) ;
        _tabelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5) ;
    }
    return _tabelView;
}
#pragma mark set方法
-(void)setSendModel:(RH_SendMessageVerityModel *)sendModel
{
    _sendModel = sendModel;
    
}
#pragma mark-
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sendModel.mAdvisoryTypeListModel.count;
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
    AdvisoryTypeListModel *model = ConvertToClassPointer(AdvisoryTypeListModel, self.sendModel.mAdvisoryTypeListModel[indexPath.item]);
    cell.textLabel.text = model.mAdvisoryName;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:12.f];
    cell.textLabel.textColor = colorWithRGB(153, 153, 153);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdvisoryTypeListModel *model = ConvertToClassPointer(AdvisoryTypeListModel, self.sendModel.mAdvisoryTypeListModel[indexPath.item]);
    self.block(model.mAdvisoryType,model.mAdvisoryName);
}

@end
