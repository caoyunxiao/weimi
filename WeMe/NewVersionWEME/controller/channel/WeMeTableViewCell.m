//
//  WeMeTableViewCell.m
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "WeMeTableViewCell.h"
#import "ChatViewController.h"
@implementation WeMeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)filleDataWithModel:(NewChannelModel *)model
{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.userHeadName] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];//头像
    self.userName.text = model.nickName.length==0?[NSString stringWithFormat:@"无昵称"]:[NSString stringWithFormat:@"%@",model.nickName];//地区
    self.address.text = model.userArea.length==0?[NSString stringWithFormat:@"无"]:[NSString stringWithFormat:@"%@",model.userArea];//地区
    self.sexImg.image = [model.gender isEqualToString:@"1"]?[UIImage imageNamed:@"boy.png"]:[UIImage imageNamed:@"girl.png"];//性别图片
    CGRect rect = [self dynamicHeight:self.userName.text systemFontOfSize:14];
    self.userName.frame = CGRectMake(self.userName.frame.origin.x, self.userName.frame.origin.y, rect.size.width, rect.size.height);
    self.sexImg.frame = CGRectMake(self.userName.frame.origin.x+rect.size.width, self.sexImg.frame.origin.y, self.sexImg.frame.size.width, self.sexImg.frame.size.height);
}

-(CGRect)dynamicHeight:(NSString *)str systemFontOfSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}
@end
