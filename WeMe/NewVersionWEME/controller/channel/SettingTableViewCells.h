//
//  SettingTableViewCell.h
//  微密
//
//  Created by MacDev on 15/4/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCells : UITableViewCell
/**
 *  频道logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *picture;
/**
 *  频道类型
 */
@property (weak, nonatomic) IBOutlet UILabel *channelType;
/**
 *  频道名字
 */
@property (weak, nonatomic) IBOutlet UILabel *channelName;
/**
 *  logo背景颜色
 */
@property (weak, nonatomic) IBOutlet UIView *logoView;

@end
