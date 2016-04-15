//
//  MemberTableViewCell.m
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

- (void)awakeFromNib {
    _isFriendFirst = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (IBAction)isFriend:(UIButton *)sender {
    if([_isAllowedOpinion isEqualToString:@"0"])
    {
        Alert(@"主人,对方不允许添加好友哦");
        return;
    }
    if([self.cellDelegate respondsToSelector:@selector(addFriends:isAllowedOpinion:isVerifyOpinion:accountNickName:gender:userArea:)])
    {
        [self.cellDelegate addFriends:_accountID isAllowedOpinion:_isAllowedOpinion isVerifyOpinion:_isVerifyOpinion accountNickName:_accountNickName gender:_gender userArea:_userArea];
    }
}

- (void)filleDataWithModel:(NewChannelModel *)model
{
    if(![model.online boolValue]){
        [self.MemberClass setBackgroundColor:getRGB(220, 220, 220)];
    }
    if(model.gender!=nil)
    {
        NSString *gender = [NSString stringWithFormat:@"%@",model.gender];
        if([gender isEqualToString:@"1"])
        {
            self.sexImage.image = [UIImage imageNamed:@"boy.png"];
        }
        else if([gender isEqualToString:@"2"])
        {
            self.sexImage.image = [UIImage imageNamed:@"girl.png"];
        }
    }
    else
    {
        self.sexImage.image = [UIImage imageNamed:@"boy.png"];
    }
    if(model.userAreaCode != nil && model.userAreaCode.length>0 )
    {
        self.MemberSexAndPlace.text = model.userAreaCode;
    }
    _accountID = model.accountID;
    _isAllowedOpinion = [NSString stringWithFormat:@"%@",model.isAllowedOpinion];
    if(model.isVerifyOpinion==nil)
    {
        _isVerifyOpinion = @"0";
    }
    else
    {
        _isVerifyOpinion = [NSString stringWithFormat:@"%@",model.isVerifyOpinion];
    }
    
    [self.MemberImage sd_setImageWithURL:[NSURL URLWithString:model.userHeadName] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
    if(model.nickname.length==0)
    {
        self.MemberName.text = @"无昵称";
        _accountNickName = @"";
    }
    else
    {
        self.MemberName.text = model.nickname;
        _accountNickName = model.nickname;
    }
    
    CGRect rect = [self dynamicHeight:self.MemberName.text systemFontOfSize:14];
    self.MemberName.frame = CGRectMake(self.MemberName.frame.origin.x, self.MemberName.frame.origin.y, rect.size.width, rect.size.height);
    self.sexImage.frame = CGRectMake(self.MemberName.frame.origin.x+rect.size.width, self.sexImage.frame.origin.y, self.sexImage.frame.size.width, self.sexImage.frame.size.height);
    
    self.MemberClass.text = [self getIdentityByroleID:model.role];
    NSString *isFriend = [NSString stringWithFormat:@"%@",model.isFriend];
    if(_isFriendFirst)
    {
        if([isFriend isEqualToString:@"0"])
        {
            self.isFriend.hidden = NO;
        }
        else
        {
            self.isFriend.hidden = YES;
        }
    }
    self.MemberSexAndPlace.text = model.userArea.length == 0?@"无地点":model.userArea;
    NSString *postNotificationName = [NSString stringWithFormat:@"%@%@",_accountID,_accountNickName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:postNotificationName object:nil];
    _gender = model.gender;
    _userArea = model.userArea;
    
    ///禁言
    if(model.talkStatus != nil)
    {
        NSString *talkStatus = [NSString stringWithFormat:@"%@",model.talkStatus];
        if([talkStatus isEqualToString:@"2"])
        {
            self.JinYanImageView.hidden = NO;
        }
        else
        {
            self.JinYanImageView.hidden = YES;
        }
    }
    else
    {
        self.JinYanImageView.hidden = YES;
    }
}
- (void)tongzhi:(NSNotification *)text
{
    self.isFriend.hidden = YES;
    _isFriendFirst = NO;
}
#pragma mark - 判断成员身份
- (NSString *)getIdentityByroleID:(NSString *)role
{
    NSString *strRole = @"";
    if([role isEqualToString:@"0"])
    {
        strRole = @"成员";
    }
    else if([role isEqualToString:@"1"])
    {
        strRole = @"管理员";
    }
    else if([role isEqualToString:@"2"])
    {
        strRole = @"管理员";
    }
    return strRole;
}
-(CGRect)dynamicHeight:(NSString *)str systemFontOfSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}

@end
