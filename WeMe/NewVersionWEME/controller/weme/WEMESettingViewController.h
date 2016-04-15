//
//  WEMESettingViewController.h
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "YJCache.h"

@interface WEMESettingViewController : BasesViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>{
    NSArray *_titleArray;
    NSArray *_imageArray;
    YJCache  *_cacheSetting;
    ModelView *_modelView;
}

@property (weak, nonatomic) IBOutlet UITableView *WEMESettingTableView;

@end
