//
//  ShowVideoViewController.m
//  微密
//
//  Created by wemeDev on 15/6/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ShowVideoViewController.h"

@interface ShowVideoViewController ()

@end

@implementation ShowVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIView];
}

- (void)setUIView
{
    _isFull = NO;
    _isPlay = YES;
    self.bofangView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinishNotification) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerWillEnterFullscreenNotification) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    
    _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.videoUrl]];
    _player.controlStyle = MPMovieControlStyleEmbedded;
    _player.view.frame = CGRectMake(0, (ScreenHeight-(ScreenWidth*200)/320)/2, ScreenWidth, (ScreenWidth*200)/320);
    [_player play];
    [self.view addSubview:_player.view];
}

- (void)MPMoviePlayerWillEnterFullscreenNotification
{
    ////
}

#pragma mark - 视频结束播放
- (void)moviePlayerPlaybackDidFinishNotification
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_player stop];
}
#pragma mark - 快退
- (IBAction)kuaituiButton:(UIButton *)sender
{
    [_player currentPlaybackRate];
}
#pragma mark - 播放
- (IBAction)bofangButton:(UIButton *)sender
{
    if(_isPlay)
    {
        [_player pause];
    }
    else
    {
        [_player play];
    }
    _isPlay = !_isPlay;
}
#pragma mark - 快进
- (IBAction)kuaijingButton:(UIButton *)sender
{
}
#pragma mark - 全屏
- (IBAction)quanpinButton:(UIButton *)sender
{
    CGAffineTransform landscapeTransform;
    if(!_isFull)
    {
        landscapeTransform = CGAffineTransformMakeRotation(M_PI/2);
        _player.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.view bringSubviewToFront:self.bofangView];
    }
    else
    {
        landscapeTransform = CGAffineTransformMakeRotation(0);
        _player.view.frame = CGRectMake(0, (ScreenHeight-(ScreenWidth*200)/320)/2, ScreenWidth, (ScreenWidth*200)/320);
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    _player.view.transform = landscapeTransform;
    _isFull = !_isFull;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
