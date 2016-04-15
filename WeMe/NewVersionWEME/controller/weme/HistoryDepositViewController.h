//
//  HistoryDepositViewController.h
//  微密
//
//  Created by Daoke Dev on 15/3/17.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathModel.h"
#import "ContractInfo.h"
#import "HeaderView.h"

@interface HistoryDepositViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_tableView;         //主界面的tableView控件
    NSMutableArray *_dataArray;      //数据源
    ModelView   *_modelView;
    PathModel *_pathModel;
    NetworkErrorView *_errorView;
    ContractInfo *_contractInfo;
    HeaderView *_headView;
    BOOL _isShow;
}

@property(copy,nonatomic)NSString *totalDepositAmount;

@property(copy,nonatomic)NSString *frozenDepositAmount;

@property(copy,nonatomic)NSString *depositType;

@end
