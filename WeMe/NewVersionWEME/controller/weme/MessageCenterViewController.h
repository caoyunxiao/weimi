//
//  MessageCenterViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"

@interface MessageCenterViewController : BasesViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong) NSMutableArray *arrayData;
@end
