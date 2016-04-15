//
//  ShowVideoViewController.h
//  微密
//
//  Created by wemeDev on 15/6/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ShowVideoViewController : BasesViewController{
    MPMoviePlayerController *_player;
    BOOL _isFull;
    BOOL _isPlay;
}

@property (nonatomic,copy) NSString *videoUrl;
@property (weak, nonatomic) IBOutlet UIButton *kuaituiButton;
- (IBAction)kuaituiButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *bofangButton;
- (IBAction)bofangButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *kuaijingButton;
- (IBAction)kuaijingButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *quanpinButton;
- (IBAction)quanpinButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *bofangView;

@end
