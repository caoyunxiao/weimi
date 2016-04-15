//
//  ShowBigErWeiMaViewController.h
//  微密
//
//  Created by wemeDev on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface ShowBigErWeiMaViewController : BasesViewController
@property(nonatomic,copy)NSString * type;
@property(nonatomic,strong)NewChannelModel * model;
@property(nonatomic,assign)BOOL isZhubo;
@property(nonatomic,copy)NSString *number;

@property (strong, nonatomic) IBOutlet UIView *bigView;
@property (strong, nonatomic) IBOutlet UIImageView *erWeiMaImage;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nameTitle;
@property (strong, nonatomic) IBOutlet UILabel *classTitle;
@property (strong, nonatomic) IBOutlet UILabel *zhuBoLabel;
@property (strong, nonatomic) IBOutlet UILabel *fansLabel;

@end
