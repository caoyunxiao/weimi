//
//  WEMECustomTableViewCell.h
//  微密
//
//  Created by mirrtalk on 15/5/21.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEMECustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLableContent;
@property (weak, nonatomic) IBOutlet UILabel *detailText;
@property (weak, nonatomic) IBOutlet UILabel *pageValue;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@end
