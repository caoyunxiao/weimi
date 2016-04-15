//
//  ZhuTableViewCell.m
//  微密
//
//  Created by wkl-mac-4 on 15/5/7.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ZhuTableViewCell.h"
#import "QRCodeGenerator.h"
@implementation ZhuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fileDataWithModel:(NewChannelModel *)model {
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
    self.titleLable.text = model.name;
    self.zhuLabel.text = [NSString stringWithFormat:@"%@",model.chiefAnnouncerName];
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝: %@/%@",model.onlineCount,model.userCount];
    self.categroyLabel.text = [NSString stringWithFormat:@"%@",model.catalogName];
//    [self.markImage sd_setImageWithURL:[NSURL URLWithString:model.twoDimensionCode] placeholderImage:[UIImage imageNamed:@"touxy.jpg"]];
//    self.markImage.image = [QRCodeGenerator qrImageForString:model.twoDimensionCode imageSize:self.markImage.bounds.size.width];
//    
//    self.hostlabel.text = model.hostSpreadName;
//    self.classifyLabel.text = model.category;
//    self.keywordLabel.text = model.keyWords;
//    self.dscrLabel.text = model.channelIntro;
//    self.introLabel.text = model.hostSpreadIntro;
}
@end
