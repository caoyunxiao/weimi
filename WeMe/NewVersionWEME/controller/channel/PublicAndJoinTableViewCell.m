//
//  PublicAndJoinTableViewCell.m
//  WeMe
//
//  Created by weme on 15/10/23.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import "PublicAndJoinTableViewCell.h"

@implementation PublicAndJoinTableViewCell

- (IBAction)publicSwitchAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(publicSwitchValueChanged:)]&&sender.tag==99) {
        [self.delegate publicSwitchValueChanged:sender];
    }
}
- (IBAction)isJoinAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(isverfySwitchValueChanged:)]&&sender.tag==999) {
        [self.delegate isverfySwitchValueChanged:sender];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
