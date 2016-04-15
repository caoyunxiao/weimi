//
//  RankTableViewCell.m
//  微密
//
//  Created by MacDev on 15/4/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "RankTableViewCell.h"

@implementation RankTableViewCell

- (void)awakeFromNib {
    // Initialization code
    ImageViewCorner(_headImageViewy);
    ImageViewCorner(self.bottomViewy);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fileDataWithData:(RankModel *)model
{
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    _rankNumLable.text = [NSString stringWithFormat:@"%@.",model.grade];
    _nameLable.text = model.nickName;
    _shareValueLable.text = [NSString stringWithFormat:@"%@谢尔",model.rochelle];
}
- (void)fileDataWithDatay:(RankModel *)model
{
    [_headImageViewy sd_setImageWithURL:[NSURL URLWithString:model.userHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    //_nickNameLabley.text = model.nickName.length==0?@"无昵称":model.nickName;//昵称
    NSString *nickName = model.nickName.length==0?@"无昵称":model.nickName;//昵称
    _nickNameLabley.text = [NSString stringWithFormat:@"%ld. %@",self.rankNum+1,nickName];
    _titleLabley.text = [NSString stringWithFormat:@"%@",model.itemValue];
    _rankTitleLabley.text = [NSString stringWithFormat:@"LV%@ %@",model.grade==nil?@"0":model.grade,model.title==nil?@"微密新手":model.title];
    
    NSString * ftype = [NSString stringWithFormat:@"%@",model.fType==nil?nil:model.fType];
    NSString *comeFrom = nil;
    if ([ftype isEqualToString:@"4"]) {
        comeFrom = @"来自+频道";
    }else if([ftype isEqualToString:@"5"]){
        comeFrom = @"来自++频道";
    }else{
        comeFrom = @"来自微密好友";
    }
    //NSString *comeFrom = [ftype isEqualToString:@"0"]?@"来自好友":@"来自频道";
    //NSLog(@"==%@  ==%@  ==%@",[PersonInfo sharePersonInfo].areaStr,comeFrom==nil?@"":comeFrom,model.fromChannel==nil?@"":model.fromChannel);
    _placeLabley.text = [NSString stringWithFormat:@"%@ %@ %@",model.userArea == nil?@"":model.userArea,comeFrom==nil?@"":comeFrom,model.fromChannel==nil?@"":model.fromChannel];

    //_placeLabley.text = @"fadfafdsa";
    _secImageViewy.image = [[NSString stringWithFormat:@"%@",model.gender] isEqualToString:@"1"]?[UIImage imageNamed:@"boy.png"]:[UIImage imageNamed:@"girl.png"];//性别图片
    CGRect rect = [self dynamicHeight:_nickNameLabley.text systemFontOfSize:14];
    CGRect frame = _nickNameLabley.frame;
    _nickNameLabley.frame = CGRectMake(frame.origin.x, frame.origin.y, rect.size.width, rect.size.height);
    _secImageViewy.frame = CGRectMake(CGRectGetMaxX(_nickNameLabley.frame)+2, frame.origin.y, 15, 15);

    float starCount = model.star==nil?0:model.star.floatValue;
    [self.starView setStar:starCount];
    
}

-(CGRect)dynamicHeight:(NSString *)str systemFontOfSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}

@end
