//
//  PindaoTableViewCell.m
//  微密
//
//  Created by wemedev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "PindaoTableViewCell.h"

@implementation PindaoTableViewCell

- (void)awakeFromNib
{
    self.PindaoView.layer.masksToBounds = YES;
    self.PindaoView.layer.cornerRadius = 5;
    
    self.PindaoViewTwo.layer.masksToBounds = YES;
    self.PindaoViewTwo.layer.cornerRadius = 5;
    
    self.PindaoViewThree.layer.masksToBounds = YES;
    self.PindaoViewThree.layer.cornerRadius = 5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)PindaoButton:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(pindaoButton:)])
    {
        NSString *strTag = [NSString stringWithFormat:@"%ld",sender.tag];
        [_delegate pindaoButton:strTag];
    }
}





@end
