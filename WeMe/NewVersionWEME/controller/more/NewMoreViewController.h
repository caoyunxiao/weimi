//
//  NewMoreViewController.h
//  微密
//
//  Created by wemeDev on 15/3/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreTopCell.h"

@interface NewMoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,moreAPPTopCellDelgate>{
    NSMutableArray *_topArray;   //图片轮播的数据源数组
    NSMutableArray *_dataArray;  //数据源数组
    UIImageView *_showImageView; //隐藏的适合显示的大图
    NSMutableArray *_adArray;    //头部轮播图片数组
}

@property (weak, nonatomic) IBOutlet UITableView *NewMoreTableView;//底层tableView

@end
