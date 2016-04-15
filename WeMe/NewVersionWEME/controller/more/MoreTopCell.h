//
//  MoreTopCell.h
//  微密
//
//  Created by wemeDev on 15/5/27.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "MoreModely.h"

@protocol moreAPPTopCellDelgate <NSObject>

@optional

- (void)selectMoreOneImageByClick:(MoreModely *)model;//图片点击代理事件

@end


@interface MoreTopCell : UITableViewCell<SDCycleScrollViewDelegate>{
    
    NSTimer *_timer;               //时间控制器
    NSArray *_topDataArray;        //数据源数组
    NSInteger _pageIndex;          //第几页
    NSArray *_modelArray;     //存放model数组
}

@property (nonatomic,assign) id<moreAPPTopCellDelgate> delegate;//设置代理

- (void)showUIViewWithNSArray:(NSArray *)array;

@end
