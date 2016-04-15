//
//  DetailSerViceCell.m
//  微密
//
//  Created by wemeDev on 15/5/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailSerViceCell.h"

@implementation DetailSerViceCell

- (void)awakeFromNib {
}

- (void)ShowUIViewWithModel:(RecordsModel *)model
{
    NSString *messageType = model.msgtype;
    if([messageType isEqualToString:@"text"])//文本
    {
        NSString *content = [model.text objectForKey:@"content"];
        self.SerViceOneLabel.text = content;
        CGRect rect = [self dynamicHeight:content fontSize:14 widthSize:self.SerViceOneLabel.frame.size.width];
        CGRect frame = self.SerViceOneLabel.frame;
        if(rect.size.height>34)
        {
            frame.origin.y = 8;
            frame.size.height = rect.size.height+16;
        }
        else
        {
            frame.origin.y = 8;
            frame.size.height = 34;
        }
        self.SerViceOneLabel.frame = frame;
    }
    if([messageType isEqualToString:@"image"])//图片
    {
        [self.SerViceTwoImageView sd_setImageWithURL:[NSURL URLWithString:[model.image objectForKey:@"media_url"]] placeholderImage:[UIImage imageNamed:@"moreimage.png"]];
    }
    if([messageType isEqualToString:@"news"])//图文
    {
        NSDictionary *news = model.news;
        NSArray *articles = [news objectForKey:@"articles"];
        _articlesArray = articles;
        for (int i=0; i<articles.count; i++)
        {
            NSDictionary *dict = [articles objectAtIndex:i];
            NSString *title = [dict objectForKey:@"title"];//图文标题
            //NSString *description = [dict objectForKey:@"description"];//图文简介
            //NSString *url = [dict objectForKey:@"url"];//正文地址
            NSString *picurl = [dict objectForKey:@"picurl"];//图片地址
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8+i*60, self.frame.size.width-66-8, 43)];
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:titleLabel];
            
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-80, 5+i*60, 50, 50)];
            [image sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:[UIImage imageNamed:@""]];
            [self addSubview:image];
            if(articles.count>1)
            {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 60+66*i, self.frame.size.width, 1)];
                line.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
                [self addSubview:line];
            }
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 60*i, self.frame.size.width, 60)];
            button.tag = 777+i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    if([messageType isEqualToString:@"2"])//视频
    {
        NSDictionary *video = model.video;
        //NSString *media_url = [video objectForKey:@"media_url"];//视频的url地址
        NSString *thumb_media_url = [video objectForKey:@"thumb_media_url"];//视频封面的图片地址
        NSString *title = [video objectForKey:@"title"];//视频标题
        //NSString *description = [video objectForKey:@"description"];//视频简介
        [self.SerViceFourView sd_setImageWithURL:[NSURL URLWithString:thumb_media_url] placeholderImage:[UIImage imageNamed:@"moreimage.png"]];
        self.SerViceFourTitle.text = title;
    }
    if([messageType isEqualToString:@"5"])//语音
    {}
}

#pragma mark - 图文button点击事件
- (void)buttonClick:(UIButton *)button
{
    if([self.delegate respondsToSelector:@selector(oneNewsCellClick:url:)])
    {
        NSInteger index = button.tag - 777;
        NSDictionary *dict = [_articlesArray objectAtIndex:index];
        NSString *title = [dict objectForKey:@"title"];//图文标题
        NSString *url = [dict objectForKey:@"url"];//正文地址
        [self.delegate oneNewsCellClick:title url:url];
    }
}
#pragma mark - 动态计算行高
-(CGRect)dynamicHeight:(NSString *)str fontSize:(NSInteger)fontSize widthSize:(NSInteger)widthSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(widthSize, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
