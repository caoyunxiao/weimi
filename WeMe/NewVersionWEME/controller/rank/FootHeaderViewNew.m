//
//  FootHeaderViewNew.m
//  微密
//
//  Created by APP on 15/6/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FootHeaderViewNew.h"

@implementation FootHeaderViewNew

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    self.gradeAndTitle.text = [NSString stringWithFormat:@"LV%@ %@",[PersonInfo sharePersonInfo].grade==nil?@"0":[PersonInfo sharePersonInfo].grade,[PersonInfo sharePersonInfo].gradeTitle.length==0?@"微密新手":[PersonInfo sharePersonInfo].gradeTitle];

    
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
    [RequestEngine getHotPointForWebView:^(NSString *errorcode,NSDictionary *dic) {
        if ([errorcode isEqualToString:@"0"]) {
            if(![dic[@"cityCodeList"] count]){
             NSURL *url = [NSURL URLWithString:LOGINURL(@"showData/city.html")];
            [_cityWebView loadRequest:[NSURLRequest requestWithURL:url]];
            return;
        }
        NSString *str = [self dictionaryToJson:dic[@"cityCodeList"]];
        NSString *str1 = [NSString stringWithFormat:@"http://wemeapp2.mirrtalk.com/WeMe/showData/city.html?param=%@",str];
        NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            NSLog(@"str1:%@",str1);
            
        NSURL *url = [NSURL URLWithString:str2];
        _cityWebView.scalesPageToFit = YES;
        [_cityWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }else{
        
            //NSLog(@"获取城市列表失败");
        }
    }];
    
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
