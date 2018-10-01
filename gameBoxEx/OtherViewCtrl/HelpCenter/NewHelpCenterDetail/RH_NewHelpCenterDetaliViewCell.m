
//
//  RH_NewHelpCenterDetaliViewCell.m
//  gameBoxEx
//
//  Created by richard on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_NewHelpCenterDetaliViewCell.h"
#import "coreLib.h"
#import "RH_HelpCenterDetailModel.h"

@implementation RH_NewHelpCenterDetaliViewCell
{
    UILabel *_contentLab ;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI] ;
        self.separatorLineStyle = CLTableViewCellSeparatorLineStyleNone ;
    }
    return self ;
}

-(void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor] ;
    _contentLab = [UILabel new] ;
    [self.contentView addSubview:_contentLab] ;
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10) ;
        make.top.mas_equalTo(10) ;
        make.width.mas_offset(screenSize().width-20) ;
    }] ;
    _contentLab.numberOfLines = 0 ;
    _contentLab.font = [UIFont systemFontOfSize:14] ;
    _contentLab.textColor = colorWithRGB(51, 51, 51) ;
    
    
    UILabel *lineLab = [UILabel new] ;
    [self.contentView addSubview:lineLab] ;
    lineLab.backgroundColor = colorWithRGB(239, 239, 239) ;
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0) ;
        make.height.mas_offset(0.5) ;
    }] ;
    
}


-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_HelpCenterDetailModel *model = ConvertToClassPointer(RH_HelpCenterDetailModel, context) ;
    _contentLab.text = [self filterHTML:model.helpContent] ;
    CGFloat height = [model.helpContent boundingRectWithSize:CGSizeMake(screenSize().width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    model.cellHeight = height +15 ;
}






-(NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
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
