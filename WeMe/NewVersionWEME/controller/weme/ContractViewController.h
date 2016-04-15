//
//  ContractViewController.h
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end
