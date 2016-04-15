//
//  WeMeFriendsViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface WeMeFriendsViewController : BasesViewController
{
    __weak IBOutlet UITableView *_table;
    NSInteger _indexRow;
    NSInteger _startPage;
    NSInteger _pageCount;
}
@end
