//
//  MoreCell.m
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)filleDataWithModel:(MoreModely *)model
{
    [self.appImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
    self.appName.text = model.appName;
    self.appRemarks.text = model.remark;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
