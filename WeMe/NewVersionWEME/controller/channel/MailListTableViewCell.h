//
//  MailListTableViewCell.h
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phoneFriendName;
@property (weak, nonatomic) IBOutlet UIImageView *sexUser;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
- (void)fileDataWithModel:(NewChannelModel *)model;


@end
