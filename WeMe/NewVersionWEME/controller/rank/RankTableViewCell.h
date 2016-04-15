//
//  RankTableViewCell.h
//  微密
//
//  Created by MacDev on 15/4/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"
#import "StarView.h"
@interface RankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *rankNumLable;//排名
@property (weak, nonatomic) IBOutlet UILabel *nameLable;//昵称
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;//男女
@property (weak, nonatomic) IBOutlet UILabel *levealLable;//等级
@property (weak, nonatomic) IBOutlet UILabel *placeLable;//地点
@property (weak, nonatomic) IBOutlet UILabel *shareValueLable;//谢尔值lable
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;//加好友按钮

@property (weak, nonatomic) IBOutlet UIImageView *bottomViewy;
@property (weak, nonatomic) IBOutlet UIImageView *headImageViewy;//头像
@property (weak, nonatomic) IBOutlet UILabel *rankLabley;//等级100
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabley;//昵称
@property (weak, nonatomic) IBOutlet UIImageView *gradeImageViewy;//得分等级
@property (weak, nonatomic) IBOutlet StarView *starView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabley;//用时15天

@property (assign,nonatomic)NSInteger rankNum;//排名 创建cell的时候传row过来
@property (weak, nonatomic) IBOutlet UILabel *placeLabley;//上海
@property (weak, nonatomic) IBOutlet UILabel *rankTitleLabley;//LV8道客车手
@property (weak, nonatomic) IBOutlet UIImageView *secImageViewy;//性别头像
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;
- (void)fileDataWithDatay:(RankModel *)model;
- (void)fileDataWithData:(RankModel *)model;//填充数据
@end
