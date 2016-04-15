//
//  SerViceTableViewCell.h
//  微密
//
//  Created by MacDev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModely.h"
#import "ServerZFJModel.h"

@interface SerViceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *serviceImage;//图像
@property (weak, nonatomic) IBOutlet UILabel *oneTitleLable;//一级标题
@property (weak, nonatomic) IBOutlet UILabel *twoTitleLable;//二级标题
@property (weak, nonatomic) IBOutlet UILabel *threeTitleLable;//三级标题
@property (weak, nonatomic) IBOutlet UIButton *collectButon;
///////第二个cell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//频道头像
@property (weak, nonatomic) IBOutlet UILabel *channelTitleLable;///频道名字
@property (weak, nonatomic) IBOutlet UILabel *channelPlaceLable;//频道地点
@property (weak, nonatomic) IBOutlet UILabel *channelMemberNumLable;//频道成员数量lable

@property (weak, nonatomic) IBOutlet UILabel *channelIntroduceLable;//频道介绍lable
@property (weak, nonatomic) IBOutlet UILabel *titleLable;//标题
@property (weak, nonatomic) IBOutlet UIImageView *showHideView;//图片
- (void)fillDataWith:(ChannelModely *)model;
- (void)showUIViewWithModel:(ServerZFJModel *)model;
@end
