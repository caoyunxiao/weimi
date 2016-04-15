//
//  GroupChatViewCell.h
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewChannelModel.h"
#import "headIcon.h"


@protocol selectClassCellDelgate <NSObject>

@optional

- (void)selectClassChannelCell:(NewChannelModel *)model;
//点击actiontye上的按钮
//@para:actionType 按钮状态
-(void)clickStartChat;

/**
 *  跳转到我管理的频道
 */
-(void)topCellRedict:(UIGestureRecognizer*)recognizer;

@end

@interface GroupChatViewCell : UITableViewCell

@property (nonatomic,assign) id<selectClassCellDelgate> delegate;

//频道设置数据配置函数
- (void)setGroupChatOneValue:(NSArray *)array;
//频道设置数据配置函数（重构）
- (void)setGroupChatOneValueNew:(NSArray *)array;

//热门推荐数据配置
- (void)setGroupChatThreeValue:(NewChannelModel *)model classArray:(NSArray *)classArray;

//分类推荐数据配置
- (void)setGroupChatFourValue:(NSArray *)array;

@property (weak, nonatomic) IBOutlet UIView *groupChatOne;
@property (weak, nonatomic) IBOutlet UIImageView *GCImageView;
@property (weak, nonatomic) IBOutlet UILabel *GCName;
@property (weak, nonatomic) IBOutlet UILabel *GCNumber;
@property (weak, nonatomic) IBOutlet UILabel *GCClass;
@property (weak, nonatomic) IBOutlet UIButton *GCJoinButton;//开始聊天
- (IBAction)GCJoinButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *GroupChatFourView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;//更多
@property (weak, nonatomic) IBOutlet UILabel *channelNumber;//频道号






@end
