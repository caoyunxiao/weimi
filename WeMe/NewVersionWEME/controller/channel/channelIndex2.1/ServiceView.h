//
//  ServiceView.h
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerZFJModel.h"

@protocol selectServiceChannelCellDelgate <NSObject>

@optional

- (void)selectServiceChannelCell:(ServerZFJModel *)model;

@end

@interface ServiceView : UIView<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_dataArray;      //数据源数组
    NSString *_customType;
    NSInteger _startPage;            //开始加载页
    NSInteger _pageCount;            //每一页加载的数据
    BOOL _isLoadDataCache;           //是否加载过缓存
    
}

@property (nonatomic,assign) id<selectServiceChannelCellDelgate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *ServiceViewTableView;

@end
