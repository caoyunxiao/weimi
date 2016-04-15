//
//  ChannelTableViewCell.h
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ChannelImage;//图像
@property (weak, nonatomic) IBOutlet UILabel *ChannelName;//名字
@property (weak, nonatomic) IBOutlet UILabel *ChannelPlace;//地点
@property (weak, nonatomic) IBOutlet UILabel *ChannelMember;//数量
@property (weak, nonatomic) IBOutlet UILabel *ChannelDescribe;//详情
@property (weak, nonatomic) IBOutlet UILabel *ChannelCatalogName;//分类
- (void)filleDataWithModel:(NewChannelModel *)model ChannelType:(NSString *)channelType;

@end
