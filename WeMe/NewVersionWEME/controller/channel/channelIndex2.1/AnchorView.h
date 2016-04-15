//
//  AnchorView.h
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnchorViewCell.h"

@protocol selectAnchorClassDelgate <NSObject>

@optional

- (void)selectAnchorOneClassButton:(NewChannelModel *)model;
- (void)selectAnchorDetailInforOfView:(NewChannelModel *)model;

@end

@interface AnchorView : UIView<UITableViewDataSource,UITableViewDelegate,selectAnchorCellDelgate>{
    NSMutableArray *_fenleiArray;    //分类数据源
    NSMutableArray *_anchorArr;      //主播数据源
    NSInteger _startPage;            //开始加载页
    NSInteger _pageCount;            //每一页加载的数据
    BOOL _isLoadDataCache;           //是否加载过缓存
}
@property (nonatomic,assign) id<selectAnchorClassDelgate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *AnchorViewTableView;

@end
