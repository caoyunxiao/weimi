//
//  DetailsOfChannelViewController.h
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "NewChannelModel.h"
@interface DetailsOfChannelViewController : BasesViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_crowdTitleArr;      //群聊title
    UIButton *_QRCode;            //二维码
    NewChannelModel *_model;
    NSMutableArray *_DetailsArray;
    NSString *_validity;
}

@property (weak, nonatomic) IBOutlet UITableView *DetailsTableView;
@property (nonatomic,strong) NSString *IDStr;   //频道分类
@property(nonatomic,copy) NSString * channelNumber;
@property (strong, nonatomic) IBOutlet UIButton *guanZhuButton;//关注频道-->开始聊天
- (IBAction)guanZhuButton:(UIButton *)sender;
@property(nonatomic,assign)BOOL isGenduo;
@end
