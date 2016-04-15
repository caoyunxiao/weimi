//
//  FunctionTableViewCell.m
//  微密
//
//  Created by longlz on 14-8-5.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "FunctionTableViewCell.h"
@implementation FunctionTableViewCell

- (void)awakeFromNib
{
    // Initialization code

//    CGSize titleSieze = [_info.intro sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.detailLabel.font,NSFontAttributeName,nil]];
//    
//    self.detailLabel.frame = CGRectMake(15, 31, 248, titleSieze.height);
//    NSLog(@"%f %@ ",titleSieze.height,_info.intro);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)orderValueChange:(id)sender
{
    
    UISwitch *chanageSwitch = (UISwitch *)sender;
    
    if ([_delegate respondsToSelector:@selector(functionCallback:row:isSelected:)])
    {
        [_delegate functionCallback:_section row:_row isSelected:chanageSwitch.isOn];
    }
}

@end
