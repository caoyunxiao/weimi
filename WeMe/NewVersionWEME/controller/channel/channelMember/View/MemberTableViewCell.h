//
//  MemberTableViewCell.h
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@protocol memberTableViewCellDelgate <NSObject>

@optional

- (void)addFriends:(NSString *)accountID isAllowedOpinion:(NSString *)isAllowedOpinion isVerifyOpinion:(NSString *)isVerifyOpinion accountNickName:(NSString *)accountNickName gender:(NSString *)gender userArea:(NSString *)userArea;

@end


@interface MemberTableViewCell : SWTableViewCell{
    
    NSString *_accountID;
    NSString *_isAllowedOpinion;
    NSString *_isVerifyOpinion;
    NSString *_accountNickName;
    NSString *_gender;
    NSString *_userArea;
    BOOL _isFriendFirst;
}

@property (weak, nonatomic) IBOutlet UIImageView *MemberBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *MemberImage;
@property (weak, nonatomic) IBOutlet UILabel *MemberClass;
@property (weak, nonatomic) IBOutlet UILabel *MemberName;
@property (weak, nonatomic) IBOutlet UILabel *MemberSexAndPlace;
@property (weak, nonatomic) IBOutlet UILabel *MemberRemarks;
@property (strong, nonatomic) IBOutlet UIButton *isFriend;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *JinYanImageView;

@property (nonatomic,assign) id<memberTableViewCellDelgate> cellDelegate;         //cell设置代理
- (IBAction)isFriend:(UIButton *)sender;

- (void)filleDataWithModel:(NewChannelModel *)model;
@end
