//
//  MoreCell.h
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreModely.h"
@interface MoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appRemarks;

@property (weak, nonatomic) IBOutlet UILabel *appName;
- (void)filleDataWithModel:(MoreModely *)model;
@end
