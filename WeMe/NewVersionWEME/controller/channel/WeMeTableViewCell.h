//
//  WeMeTableViewCell.h
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface WeMeTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

- (void)filleDataWithModel:(NewChannelModel *)model;
@end
