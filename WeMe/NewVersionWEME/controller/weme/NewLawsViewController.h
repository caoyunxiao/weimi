//
//  NewLawsViewController.h
//  微密
//
//  Created by mirrtalk on 15/3/12.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLawsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    
}


@property(copy,nonatomic)NSString *depositType;

@end
