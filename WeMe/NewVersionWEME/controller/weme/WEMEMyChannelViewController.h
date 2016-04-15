//
//  WEMEMyChannelViewController.h
//  微密
//
//  Created by ZFJ on 15/8/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface WEMEMyChannelViewController : BasesViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSArray *_titleArray;//标题数组
    NSArray *_imageArray;//图标数组
}

@property (weak, nonatomic) IBOutlet UITableView *WEMEMyChannelTableView;

@end
