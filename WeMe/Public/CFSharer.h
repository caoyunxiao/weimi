//
//  Sharer.h
//  CFShareCircle
//
//  Created by Camden on 1/15/13.
//  Copyright (c) 2013 Camden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CFSharer : NSObject

@property(copy,nonatomic) NSString *name;
@property(strong,nonatomic) UIImage *image;

/**
 Initialize a custom sharer with the name that will be presented when hovering over and the name of the image.
 */
- (id)initWithName:(NSString *)name imageName:(NSString *)imageName;


+ (CFSharer *)sina;
+ (CFSharer *)wxFriend;
+ (CFSharer *)wxCircle;

+ (CFSharer *)mail;
+ (CFSharer *)photoLibrary;
+ (CFSharer *)dropbox;
+ (CFSharer *)evernote;
+ (CFSharer *)facebook;
+ (CFSharer *)googleDrive;
+ (CFSharer *)pinterest;
+ (CFSharer *)twitter;

@end
