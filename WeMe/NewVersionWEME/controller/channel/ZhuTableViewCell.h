//
//  ZhuTableViewCell.h
//  微密
//
//  Created by wkl-mac-4 on 15/5/7.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuTableViewCell : UITableViewCell
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/**
 *  粉丝
 */
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
/**
 *  主播
 */
@property (weak, nonatomic) IBOutlet UILabel *zhuLabel;
/**
 *  分类
 */
@property (weak, nonatomic) IBOutlet UILabel *categroyLabel;

/**
 *  1区-----
 */

/**
 *  主播Label
 */
@property (weak, nonatomic) IBOutlet UILabel *hostlabel;
/**
 *  分类
 */
@property (weak, nonatomic) IBOutlet UILabel *classifyLabel;
/**
 *  关键字
 */
@property (weak, nonatomic) IBOutlet UILabel *keywordLabel;
/**
 *  二维码
 */
@property (weak, nonatomic) IBOutlet UIImageView *markImage;
/**
 *  2区------
 */

/**
 *  频道简介
 */
@property (weak, nonatomic) IBOutlet UILabel *dscrLabel;

/**
 *  粉丝数
 */
@property (weak, nonatomic) IBOutlet UILabel *numFansLabel;
/**
 *  3区
 */

/**
 *  主播简介
 */
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

/**
 *  获取数据方法
 */
- (void)fileDataWithModel:(NewChannelModel *)model;
@end
