//
//  HomePageChannelViewController.h
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "ModelView.h"
#import "GroupChatView.h"
#import "ServiceView.h"
#import "AnchorView.h"

@interface HomePageChannelViewController : BasesViewController<UIScrollViewDelegate,UISearchBarDelegate,selectHotChannelCellDelgate,selectServiceChannelCellDelgate,selectAnchorClassDelgate>
{
    NSInteger _indexButton;          //记录button点击顺序
    NSMutableArray *_buttonArray;    //按钮数组 头部三个按钮
    UIView *_touchView;              //覆盖点击视图
    UISearchBar *_searchBar;         //搜索框
    ModelView *_modelView;           //加载视图
    NSString *_searchMessage;        //搜索框内容
    UIView *_searchView;             //搜索框视图
    UIButton  *_searchButton;        //覆盖搜索点击视图
}

@property (weak, nonatomic) IBOutlet UIScrollView *HomePageScrollView;//底层滚动视图

@property (weak, nonatomic) IBOutlet UIButton *GroupChatButton;//群聊button
@property (weak, nonatomic) IBOutlet UIButton *AnchorButton;//主播
@property (weak, nonatomic) IBOutlet UIButton *ServiceButton;//服务

@property (weak, nonatomic) IBOutlet UIView *moreView;//更多view
@property (weak, nonatomic) IBOutlet UIView *downView;//内部view

@property (weak, nonatomic) IBOutlet UIButton *createButton;//创建频道
@property (weak, nonatomic) IBOutlet UIButton *ScanningButton;//扫一扫
@property (weak, nonatomic) IBOutlet UIButton *AdministrationButton;//管理频道
@property (weak, nonatomic) IBOutlet UIButton *functionSettingButton;//功能设置
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;//终端类型























@end
