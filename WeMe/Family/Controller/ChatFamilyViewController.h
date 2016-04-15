//
//  ChatFamilyViewController.h
//  微密
//
//  Created by iOS Dev on 14-8-18.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordingButton.h"
#import <AVFoundation/AVFoundation.h>
#import "SUserDB.h"
#import "FamilyViewController.h"



typedef void(^ExitLoginBlock)(BOOL isSucceed);

@interface ChatFamilyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,RecordingButtonDelegate,UIAlertViewDelegate>
{
    NSURL *recordedFile;
    AVAudioRecorder *recorder;
    BOOL isRecording;
    
    NSString *_appStation;
    NSString *_recvIDString;
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet RecordingButton *recordingButton;

@property (nonatomic,copy) NSString *backType;




















@end
