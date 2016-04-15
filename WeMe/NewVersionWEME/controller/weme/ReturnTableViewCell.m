//
//  ReturnTableViewCell.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ReturnTableViewCell.h"
#import "NSString+Time.h"

@implementation ReturnTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)fillData:(DepositHisotryInfo *)history
{
    self.dataLabel.text = [[NSString dateFormatWithSeconds:[history.updateTime longLongValue]] substringToIndex:10];
    
    self.cashLabel.text = history.changedAmount;
    
    self.remarkLabel.text = history.remark;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
