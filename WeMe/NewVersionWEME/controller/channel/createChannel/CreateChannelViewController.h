//
//  CreateChannelViewController.h
//  微密
//
//  Created by Daoke Dev on 15/3/27.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"


@interface CreateChannelViewController : BasesViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NewChannelModel * _channelModel;
    NSString *_channelNumber;
    NSString *_uniqueCode;
    UIImage *_userImage;
}
- (void)complete;
- (void)goBack;


@end