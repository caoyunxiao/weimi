//
//  DetailsClassViewController.h
//  微密
//
//  Created by ZFJ on 15/8/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "NewChannelModel.h"

@interface DetailsClassViewController : BasesViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *_catalogID;
    NSMutableArray *_dataArray;//数据源数组
    NSInteger _startPage;//开始页
    NSInteger _pageCount;//每一页请求的数据数
    UIAlertView  *_alertView;//警告视图
    NSMutableArray *_settingArr;//功能键设置数组
    NSInteger _buttonTag;
    UIAlertView *_alert;//设置功能键按钮警告视图
}

@property (nonatomic,retain) NewChannelModel* model;
@property (nonatomic,assign) BOOL isUISearchBar;   //是否是搜索框
@property (nonatomic,copy) NSString *searchMessage; //搜索的内容


@property (weak, nonatomic) IBOutlet UITableView *detailsTableView;

@end
