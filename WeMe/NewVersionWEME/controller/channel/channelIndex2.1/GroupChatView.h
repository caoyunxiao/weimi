//
//  GroupChatView.h
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelView.h"
#import "NewChannelModel.h"
#import "GroupChatViewCell.h"

@protocol selectHotChannelCellDelgate <NSObject>

@optional

- (void)selectHotChannelCell:(NewChannelModel *)model;
- (void)moreButton:(NSInteger)index;
- (void)selectClassChannelView:(NewChannelModel *)model;
-(void)homePageRedict:(UIGestureRecognizer*)recognizer;

/**
 *  跳转到验证界面
 */
-(void)pushToTestViewController:(NewChannelModel *)model applyIdx:(NSString *)applyIdx actionType:(NSString*)actionType;

@end

@interface GroupChatView : UIView<UITableViewDataSource,UITableViewDelegate,selectClassCellDelgate>{
    
    NSMutableArray *_settingArr;       //频道设置数据
    NSMutableArray *_hotArray;         //热门推荐
    NSMutableArray *_classArray;       //分类推荐
    NSInteger  _dataCount;             //获得到的数据数量
    UIAlertView *_alert;
    NSInteger _buttonTag;              //开始聊天的button顺序数
    NSInteger _indexRequest;           //请求的次数
    
    NSInteger _endRefreshTimers;       //停止刷新的次数
}

@property (nonatomic,assign) id<selectHotChannelCellDelgate> delegate;


@property (weak, nonatomic) IBOutlet UITableView *GroupChatTableView;
















@end
