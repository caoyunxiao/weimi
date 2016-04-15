//
//  MailListTableViewCell.m
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MailListTableViewCell.h"

@implementation MailListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fileDataWithModel:(NewChannelModel *)model
{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];//头像
    self.userName.text = model.nickName.length==0?@"无昵称":model.nickName;//昵称
    self.sexUser.image = [model.gender isEqualToString:@"1"]?[UIImage imageNamed:@"boy.png"]:[UIImage imageNamed:@"girl.png"];//性别图片
    NSString *phoneName = model.phoneName;
    if(phoneName==nil||phoneName.length==0)
    {
        phoneName = @"";
    }
    self.phoneFriendName.text = [NSString stringWithFormat:@"手机联系人:%@",phoneName];
    if ([[NSString stringWithFormat:@"%@",model.isFriend] isEqualToString:@"1"]) {
        [self.addFriend setTitle:@"已添加" forState:UIControlStateNormal];
        self.addFriend.enabled=NO;
        [self.addFriend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.addFriend setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    CGRect rect = [self dynamicHeight:self.userName.text systemFontOfSize:14];
    self.userName.frame = CGRectMake(self.userName.frame.origin.x, self.userName.frame.origin.y, rect.size.width, rect.size.height);
    self.sexUser.frame = CGRectMake(self.userName.frame.origin.x+rect.size.width, self.sexUser.frame.origin.y, self.sexUser.frame.size.width, self.sexUser.frame.size.height);
}
-(CGRect)dynamicHeight:(NSString *)str systemFontOfSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}
@end
