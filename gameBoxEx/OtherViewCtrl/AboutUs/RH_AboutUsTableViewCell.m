//
//  RH_AboutUsTableViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_AboutUsTableViewCell.h"
#import "coreLib.h"

@implementation RH_AboutUsTableViewCell
{
    UIWebView *webView ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
}


@end
