//
//  ShowBigImageViewController.h
//  微密
//
//  Created by wemeDev on 15/6/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface ShowBigImageViewController : BasesViewController

@property (nonatomic,copy) NSString *media_url;
@property (weak, nonatomic) IBOutlet UIScrollView *ShowBigScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ShowBigImageView;

@end
