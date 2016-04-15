//
//  ChatCell.m
//  自带下拉刷新
//
//  Created by iOS Dev on 14-8-18.
//  Copyright (c) 2014年 语境. All rights reserved.
//

#import "ChatCell.h"
#import "HTTPManger.h"
#import "SUserDB.h"
#import "VoiceConverter.h"






@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
    _isPlayer = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)leftBtnClick:(id)sender
{
    if (!_isPlayer)
    {
        if (self.pathUrl == nil)
        {
            [self playerNetWork];
        }
        else
        {
            [self playerAudio];
        }
    }
    else
    {
        [self pausePlayerPNG];
    }
    _isPlayer = !_isPlayer;
    
}


- (IBAction)rightBtnClick:(id)sender
{
    if (!_isPlayer)
    {
        [self playerAudio];
    }
    else
    {
        [self pausePlayerPNG];
    }
    _isPlayer = !_isPlayer;
}

- (void)playerAudio
{
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.pathUrl error:nil];
    _audioPlayer.delegate = self;
    [_audioPlayer play];
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pngTimer) userInfo:nil repeats:YES];
    _iTimer = 0;
}


- (void)pngTimer
{
    _iTimer++;
    
    if (_iTimer > 3)
    {
        _iTimer = 0;
    }
    
    NSString *leftImageString = [NSString stringWithFormat:@"left_voice%d.png",_iTimer];
    
    NSString *rightImageString = [NSString stringWithFormat:@"right_voice%d.png",_iTimer];
    
    [self.leftVoiceButton setImage:[UIImage imageNamed:leftImageString] forState:UIControlStateNormal];
    [self.rightVoiceButton setImage:[UIImage imageNamed:rightImageString] forState:UIControlStateNormal];
}


- (void)pausePlayerPNG
{
    [_myTimer invalidate];
    _myTimer = nil;
    
    [self.leftVoiceButton setImage:[UIImage imageNamed:@"left_voice3.png"] forState:UIControlStateNormal];
    [self.rightVoiceButton setImage:[UIImage imageNamed:@"right_voice3.png"] forState:UIControlStateNormal];
    _audioPlayer = nil;
    [_audioPlayer pause];
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self pausePlayerPNG];
}



- (void)playerNetWork
{
    [HTTPManger requestWithURL:self.netWorkUrl Finish:^(NSData *data)
    {
        NSString *date = [NSString currentDetailDate];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/tmp/%@.%@",NSHomeDirectory(),date,@"amr"];
        [data writeToFile:filePath atomically:YES];
        
        NSString *wavFilePath = [NSString stringWithFormat:@"%@/tmp/%@.%@",NSHomeDirectory(),date,@"wav"];
        
        [VoiceConverter amrToWav:filePath wavSavePath:wavFilePath];
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:wavFilePath] error:nil];
        _audioPlayer.delegate = self;
        [_audioPlayer play];
        
        
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pngTimer) userInfo:nil repeats:YES];
        _iTimer = 0;
        
        SUserDB *userDB = [[SUserDB alloc]init];
        ChatInfo *info = [[ChatInfo alloc]init];
        info.uid = self.uid;
        info.mediaUrl = wavFilePath;
        
        [userDB updataWithUser:info];
        
    } Failed:^(NSError *error)
    {
        
    }];
}


@end
