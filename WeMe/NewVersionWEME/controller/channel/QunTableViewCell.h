//
//  QunTableViewCell.h
//  微密
//
//  Created by mirrtalk on 15/5/7.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol openTestSwitchDelegate <NSObject>

@optional
-(void)openDetailSwitchClick:(UISwitch *)openSwitch;//公开频道
-(void)testDetailSwitchClick:(UISwitch *)testSwitch;//是否验证

@end

@interface QunTableViewCell : UITableViewCell

@property(nonatomic,weak)id<openTestSwitchDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *placeLblae;
@property (weak, nonatomic) IBOutlet UILabel *membreNumberLable;
@property (weak, nonatomic) IBOutlet UILabel *catalogName;
@property (weak, nonatomic) IBOutlet UILabel *jianjieLalble;
@property (weak, nonatomic) IBOutlet UILabel *pinDaoNumLable;
@property (weak, nonatomic) IBOutlet UILabel *fenLeiLable;
@property (weak, nonatomic) IBOutlet UILabel *guanjianziLable;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImageView;//二维码
@property (weak, nonatomic) IBOutlet UILabel *quyuLable;
@property (weak, nonatomic) IBOutlet UILabel *guanliyuanLable;
@property (weak, nonatomic) IBOutlet UILabel *chengyuanLable;
@property (weak, nonatomic) IBOutlet UISwitch *yanzhenSwitch;
@property (weak, nonatomic) IBOutlet UIButton *memberButton;
@property (weak, nonatomic) IBOutlet UIButton *erWeiMaButton;

@property (weak, nonatomic) IBOutlet UISwitch *gongkaiSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *JiaKeySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *JiaJiaKeySwitch;
@property (weak, nonatomic) IBOutlet UIButton *channelKeyWorkds;
@property (weak, nonatomic) IBOutlet UIButton *channelNameButton;
@property (weak, nonatomic) IBOutlet UIButton *channelFenleiButton;
@property (weak, nonatomic) IBOutlet UIButton *channelArearButton;

@property (weak, nonatomic) IBOutlet UILabel *channelNumber;//频道号

@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;//公开频道

@property (weak, nonatomic) IBOutlet UISwitch *testSwitch;//是否验证

- (void)fileDataWithModel:(NewChannelModel *)model andType:(NSString *)type;
@end
