//
//  TaskOSViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/14.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskOSViewController : UITableViewController
{
    NSString *_resultInfoString;
    NSArray *_taskInfoArray;
}

@property (nonatomic,copy) NSString *taskInfoType;
@end
