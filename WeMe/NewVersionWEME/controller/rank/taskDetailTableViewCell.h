//
//  taskDetailTableViewCell.h
//  微密
//
//  Created by mirrtalk on 15/5/14.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface taskDetailTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
//receiveStatus
@property (nonatomic,copy) NSString *receiveStatus;

@end
