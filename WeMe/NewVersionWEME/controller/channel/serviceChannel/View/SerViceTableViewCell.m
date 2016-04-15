//
//  SerViceTableViewCell.m
//  微密
//
//  Created by MacDev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "SerViceTableViewCell.h"

@implementation SerViceTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWith:(ChannelModely *)model
{
    if (model)
    {
        _channelTitleLable.text = model.channelName;
        _channelPlaceLable.text = [NSString stringWithFormat:@"地点: %@",model.area];
        _channelMemberNumLable.text = [NSString stringWithFormat:@"成员: %ld/%ld",model.onLineMembers,model.totalMembers];
        _channelIntroduceLable.text = model.channelIntro;
    }
}

- (void)showUIViewWithModel:(ServerZFJModel *)model
{
    if(model)
    {
        [self.serviceImage sd_setImageWithURL:[NSURL URLWithString:model.defineLogo] placeholderImage:[UIImage imageNamed:@"jiaotongtongxinfenxiang.png"]];
        self.oneTitleLable.text = model.defineName;
        self.twoTitleLable.text = model.briefIntro;
        self.threeTitleLable.text = model.customType;
    }
}




@end
