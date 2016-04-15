//
//  ShareErWeiMaViewController.h
//  微密
//
//  Created by wemeDev on 15/5/30.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface ShareErWeiMaViewController : BasesViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *twoCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *channelNumber;//频道号

@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *imageStr;
@property (nonatomic,copy) NSString *number;

@end
