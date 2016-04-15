//
//  PersonInfoCell.h
//  微密
//
//  Created by wemeDev on 15/3/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *personIcon;
@property (strong, nonatomic) IBOutlet UILabel *personName;
@property (strong, nonatomic) IBOutlet UILabel *personPhone;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ranBackImage;


@end
