//
//  ChatCell.h
//  自带下拉刷新
//
//  Created by iOS Dev on 14-8-18.
//  Copyright (c) 2014年 语境. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@protocol ChatCellDelegate <NSObject>


@end


@interface ChatCell : UITableViewCell<AVAudioPlayerDelegate>
{
    AVAudioPlayer *_audioPlayer;
    NSTimer       *_myTimer;
    int           _iTimer;
    BOOL          _isPlayer;
}


@property(strong,nonatomic)NSURL *pathUrl;

@property(strong,nonatomic)NSString *netWorkUrl;

@property(strong,nonatomic)NSString *uid;

@property (strong, nonatomic) IBOutlet UIView *leftView;


@property (strong, nonatomic) IBOutlet UIView *rightView;

@property (strong, nonatomic) IBOutlet UILabel *rightTime;
@property (strong, nonatomic) IBOutlet UILabel *leftTime;

@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;

@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;


@property (strong, nonatomic) IBOutlet UILabel *leftnickNameLable;

@property (strong, nonatomic) IBOutlet UILabel *rightnicknameLabel;


@property (strong, nonatomic) IBOutlet UIButton *leftVoiceButton;

@property (strong, nonatomic) IBOutlet UIButton *rightVoiceButton;


- (IBAction)leftBtnClick:(id)sender;


- (IBAction)rightBtnClick:(id)sender;

@end
