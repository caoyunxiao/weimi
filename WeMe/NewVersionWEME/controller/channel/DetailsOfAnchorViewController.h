//
//  DetailsOfAnchorViewController.h
//  微密
//
//  Created by MacDev on 15/4/17.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface DetailsOfAnchorViewController : BasesViewController{
    
    NSString *_accountID;
    NSString *_accountIDString;
    NSInteger _sectionsNum;
    NSString *_isJoined;
    NSInteger _cellAtIndexRow;
    NSInteger _atSection;
    NSString *_openType;//
    NSString *_isVerify;
    NSString *_bindKey;
    
    NSInteger _cellAtIndexRow_Open;
    NSInteger _atSection_Open;
    NSString *_typeInt;
}
- (IBAction)guanQuButtonClick:(UIButton *)sender;
@property(nonatomic,strong)NewChannelModel * getmodel;
@property(nonatomic,copy)NSString * channelNumber;
@property(nonatomic,copy)NSString * channelType;//1，关注频道，2，取消关注频道；
@property(nonatomic,assign)BOOL isGenduo;
@property(nonatomic,copy)NSString *uniqueCode;//扫描二维码得到的邀请码
@property(nonatomic,copy)NSString *talkStatus;//获取是否需要验证的字符串 4.需要验证

@end
