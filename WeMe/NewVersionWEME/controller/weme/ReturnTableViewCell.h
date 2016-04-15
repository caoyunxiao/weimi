//
//  ReturnTableViewCell.h
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepositHisotryInfo.h"


@interface ReturnTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;

@property (strong, nonatomic) IBOutlet UILabel *cashLabel;

@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;

- (void)fillData:(DepositHisotryInfo *)history;

@end
