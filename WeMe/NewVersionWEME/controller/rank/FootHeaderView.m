//
//  FootHeaderView.m
//  微密
//
//  Created by APP on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FootHeaderView.h"

@implementation FootHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)headerButtonClick:(UIButton *)sender {
    self.headerCallBack((int)sender.tag);
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self requestData];
    [self reloadData];
    ImageViewCorner(_headImageView);
}
- (void)reloadData
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    _nickName.text = [PersonInfo sharePersonInfo].nicknameString==nil?@"无昵称":[PersonInfo sharePersonInfo].nicknameString;
    _gradeAndTitle.text = [NSString stringWithFormat:@"LV%@ %@",[PersonInfo sharePersonInfo].grade==nil?@"1":[PersonInfo sharePersonInfo].grade,[PersonInfo sharePersonInfo].gradeTitle==nil?@"驾校学员":[PersonInfo sharePersonInfo].gradeTitle];
    _placeLabel.text = [PersonInfo sharePersonInfo].areaStr == nil?@"":[PersonInfo sharePersonInfo].areaStr;
    
    _sexImageView.image = [[NSString stringWithFormat:@"%@",[PersonInfo sharePersonInfo].sexString] isEqualToString:@"1"]?[UIImage imageNamed:@"boy.png"]:[UIImage imageNamed:@"girl.png"];//性别图片
    _cityAndPointLabel.text = self.cityAndPointText;
    CGRect rect = [self dynamicHeight:_nickName.text systemFontOfSize:15];
    CGRect frame = _nickName.frame;
    _nickName.frame = CGRectMake(frame.origin.x, frame.origin.y, rect.size.width, rect.size.height);
    _sexImageView.frame = CGRectMake(CGRectGetMaxX(_nickName.frame)+2, frame.origin.y, 20, 20);
    
}


-(CGRect)dynamicHeight:(NSString *)str systemFontOfSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}

- (void)requestData
{
//    [RequestEngine getHotPointForWebView:^(NSDictionary *dic) {
//        NSString *str = [self dictionaryToJson:dic];
//        NSString *str1 = [NSString stringWithFormat:@"http://192.168.11.85/echart_test/city.html?param=%@",str];
//        NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:str2];
//        _cityWebView.scalesPageToFit = YES;
//        [_cityWebView loadRequest:[NSURLRequest requestWithURL:url]];
//        
//    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark webView
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
