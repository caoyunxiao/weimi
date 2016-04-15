//
//  FunctionSettingViewController.h
//  微密
//
//  Created by longlz on 14-7-15.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionSettingHeaderButton.h"
#import "FunctionTableViewCell.h"


#pragma mark --
#pragma mark --  功能设置

@interface FunctionSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FunctionSettingHeaderButtonDelegate,FunctionTableViewCellDelegate>

{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UILabel *_headerLabel;
    
    NSMutableArray *_onOrOffArray;
}



@end
