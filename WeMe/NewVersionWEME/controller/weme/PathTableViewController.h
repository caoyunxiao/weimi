//
//  PathTableViewController.h
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathModel.h"


#pragma mark --
#pragma mark --  轨迹


@interface PathTableViewController : UITableViewController
{
    NSMutableArray *_sectionArray;
    PathModel *_pathModel;
    NetworkErrorView *_errorView;
}
@end
