//
//  ZhuThreeCell.h
//  微密
//
//  Created by wkl-mac-4 on 15/5/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuThreeCell : UITableViewCell
+ (instancetype)zhuThreeCellWithTableview:(UITableView *)tableView;
@property(nonatomic,strong)ChannelModely *model;
/**
 *  频道简介
 */
@property(nonatomic,weak)UILabel *channelIntro;
@end
