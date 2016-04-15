//
//  ChannelTableViewCell.m
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ChannelTableViewCell.h"

@implementation ChannelTableViewCell

- (void)awakeFromNib {
    // Initialization code、、、、、、、。、。、。、。、
}
- (void)filleDataWithModel:(NewChannelModel *)model ChannelType:(NSString *)channelType
{
    if(model.name!=nil&&model.name.length>0)
    {
        self.ChannelName.text = model.name;
    }
    else
    {
        self.ChannelName.text = @"";
    }
    if(model.cityName!=nil&&model.cityName.length>0)
    {
        self.ChannelPlace.text = model.cityName;
    }
    else
    {
        self.ChannelPlace.text = @"";
    }
    NSString *strType;
    NSRange range = [channelType rangeOfString:@"主播"];
    if (range.location != NSNotFound)
    {
        strType = @"粉丝";
    }
    else
    {
        strType = @"成员";
    }
    if(model.capacity==nil)
    {
        self.ChannelMember.text = [NSString stringWithFormat:@"%@:0",strType];
    }
    else
    {
        self.ChannelMember.text = [NSString stringWithFormat:@"%@:%@",strType,model.userCount];
    }
    if(model.catalogName!=nil&&model.catalogName.length>0)
    {
        self.ChannelCatalogName.text = [NSString stringWithFormat:@"分类:%@",model.catalogName];
    }
    else
    {
        self.ChannelCatalogName.text = [NSString stringWithFormat:@"分类:无"];
    }
    if(model.introduction!=nil&&model.introduction.length>0)
    {
        self.ChannelDescribe.text = model.introduction;
    }
    else
    {
        self.ChannelDescribe.text = @"该频道没有简介哦";
    }
    [self.ChannelImage sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
