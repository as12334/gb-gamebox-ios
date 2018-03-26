//
//  RH_RegisterClauseViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegisterClauseViewCell.h"
#import "RH_RegisterClauseModel.h"
#import "coreLib.h"

@implementation RH_RegisterClauseViewCell
{
    UIWebView *webView ;
}

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return screenSize().height  - NavigationBarHeight;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        webView = [[UIWebView alloc] init] ;
        [self.contentView addSubview:webView];
        webView.whc_LeftSpace(0).whc_RightSpace(0).whc_TopSpace(0).whc_BottomSpace(0) ;
    }
    return self ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_RegisterClauseModel *model = ConvertToClassPointer(RH_RegisterClauseModel, context) ;
    [webView loadHTMLString:model.mValue baseURL:nil] ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
