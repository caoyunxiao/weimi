//
//  PindaoTableViewCell.h
//  微密
//
//  Created by wemedev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PindaoButtonDelgate <NSObject>

- (void)pindaoButton:(NSString *)buttonTag;

@end

@interface PindaoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *PindaoView;

@property (weak, nonatomic) IBOutlet UIView *PindaoViewTwo;

@property (weak, nonatomic) IBOutlet UIView *PindaoViewThree;

- (IBAction)PindaoButton:(UIButton *)sender;

@property (nonatomic,assign) id<PindaoButtonDelgate> delegate;

@end
