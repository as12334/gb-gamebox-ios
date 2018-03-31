//
//  RH_HelpCenterDetailViewCell.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_HelpCenterDetailViewCell.h"
#import "RH_HelpCenterDetailModel.h"

#import "coreLib.h"

@interface RH_HelpCenterDetailViewCell()<UIWebViewDelegate>

@end

@implementation RH_HelpCenterDetailViewCell
{
    UIButton *titleBtn;
    UIWebView *webView ;
    UILabel *contentLab ;
    RH_HelpCenterDetailModel *dataModel  ;
}

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_HelpCenterDetailModel *model =  ConvertToClassPointer(RH_HelpCenterDetailModel, context) ;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,tableView.frameWidth, 0)];
    NSString *str = model.helpContent ;
    NSScanner * scanner = [NSScanner scannerWithString:str];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    label.text = str;
    label.font = [UIFont systemFontOfSize:16.f];
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize maxSize = CGSizeMake(label.frameWidth, MAXFLOAT);
    label.numberOfLines=0;
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return 100.f +size.height;
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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI] ;
    }
    return self ;
}


-(void)setUpUI
{
    titleBtn = [UIButton new] ;
    [self.contentView addSubview:titleBtn];
    self.contentView.backgroundColor = colorWithRGB(242, 242, 242) ;
    titleBtn.whc_LeftSpace(0).whc_TopSpace(10).whc_RightSpace(0).whc_Height(40) ;
    [titleBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    titleBtn.backgroundColor = [UIColor whiteColor] ;
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    webView = [UIWebView new] ;
    [self.contentView addSubview:webView];
    webView.delegate = self ;
    webView.whc_LeftSpace(0).whc_TopSpaceToView(0, titleBtn).whc_RightSpace(0).whc_HeightAuto() ;
    
    contentLab = [UILabel new] ;
    [self.contentView addSubview:contentLab];
    contentLab.whc_LeftSpace(10).whc_TopSpaceToView(0, titleBtn).whc_RightSpace(10).whc_HeightAuto() ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_HelpCenterDetailModel *model =  ConvertToClassPointer(RH_HelpCenterDetailModel, context) ;
    [titleBtn setTitle:[NSString stringWithFormat:@"%@",model.helpTitle] forState:UIControlStateNormal];
//    [webView loadHTMLString:[self filterHTML:model.helpContent] baseURL:nil] ;
    contentLab.text = [self filterHTML:model.helpContent] ;
    dataModel = model ;
//    if (!self.isOpen) {
//        webView.hidden = NO ;
//    }else
//    {
//        webView.hidden = YES ;
//    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#EFEFEF'"];
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    CGRect frame = webView.frame;
    frame.size.height = webViewHeight;
    webView.frame = frame;
}

-(void)titleBtnClick:(UIButton *)sender
{
    if (dataModel.helpDocumentId) {
        
    }
    ifRespondsSelector(self.delegate,@selector(helpCenterDetailViewCellDidTouchTitleBtn:)){
        [self.delegate helpCenterDetailViewCellDidTouchTitleBtn:self];
    }

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
