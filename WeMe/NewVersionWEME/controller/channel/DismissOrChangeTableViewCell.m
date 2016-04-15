//
//  DismissOrChangeTableViewCell.m
//  微密
//
//  Created by weme on 15/9/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DismissOrChangeTableViewCell.h"
@interface DismissOrChangeTableViewCell()


@end


@implementation DismissOrChangeTableViewCell
/**
 *  解散
 *
 *  @param sender <#sender description#>
 */
- (IBAction)dismissAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dismissChannel)]) {
        [self.delegate dismissChannel];
    }
}

/**
 *  转移
 *
 *  @param sender <#sender description#>
 */
- (IBAction)changeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(changeChannel)]) {
        [self.delegate changeChannel];
    }
}

+(instancetype)initWithTableView:(UITableView *)tableView{
    static NSString *identifier=@"DismissOrChangeTableViewCell";
    DismissOrChangeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"DismissOrChangeTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
