//
//  HotPointTableViewCell.m
//  微密
//
//  Created by APP on 15/6/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "HotPointTableViewCell.h"

@implementation HotPointTableViewCell
{
    UIWebView *_hotPointWebView;
}
- (void)awakeFromNib {
    // Initialization code
//    _hotPointWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 225)];
//    _hotPointWebView.delegate = self;
//    [self.contentView addSubview:_hotPointWebView];
//    [self requestData];
}
- (void)requestData
{
    [RequestEngine getHotPointForWebView:^(NSString *errorcode,NSDictionary *dic) {
        if ([errorcode isEqualToString:@"0"]) {
            if(![dic[@"powerOffHotList"] count]){
                NSString *str = @"http://wemeapp2.mirrtalk.com/WeMe/showData/map.html";
                NSURL *url = [NSURL URLWithString:str];
                [_hotPointWebView loadRequest:[NSURLRequest requestWithURL:url]];
                return;
            }
            NSString *str = [self dictionaryToJson:dic[@"powerOffHotList"]];
            NSString *str1 = [NSString stringWithFormat:@"http://wemeapp2.mirrtalk.com/WeMe/showData/map.html?param=%@",str];
            NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:str2];
            _hotPointWebView.scalesPageToFit = YES;
            [_hotPointWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }else{
            
            NSLog(@"获取城市列表失败");
        }
    }];
}

- (NSString*)dictionaryToJson:(NSArray *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
