//
//  DetailsAnchorViewController.h
//  微密
//
//  Created by ZFJ on 15/8/11.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface DetailsAnchorViewController : BasesViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_dataArray;//数据源数组
    NSInteger _startPage;
    NSInteger _pageCount;
    NSString *_catalogID;
}

@property (weak, nonatomic) IBOutlet UITableView *detailsAnchorTableView;

@property (nonatomic,retain) NewChannelModel* model;
@property (nonatomic,assign) BOOL isUISearchBar;   //是否是搜索框
@property (nonatomic,copy) NSString *searchMessage; //搜索的内容


@end
