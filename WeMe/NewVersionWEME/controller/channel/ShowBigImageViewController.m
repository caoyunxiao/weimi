//
//  ShowBigImageViewController.m
//  微密
//
//  Created by wemeDev on 15/6/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ShowBigImageViewController.h"
#import "MyScrollView.h"

@interface ShowBigImageViewController ()<UIScrollViewDelegate>

@end

@implementation ShowBigImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSV];
}
- (void)createSV
{
    self.ShowBigImageView.hidden = YES;
    MyScrollView *mSV = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, _ShowBigScrollView.frame.size.width, _ShowBigScrollView.frame.size.height) anImage:self.media_url];
    [mSV addSingleClickWithTarget:self andAction:@selector(singleClick)];
    [mSV addDoubleClickWithTarget:self andAction:@selector(doubleClick:)];
    mSV.minimumZoomScale = 1.0;
    mSV.maximumZoomScale = 5.0;
    mSV.delegate = self;
    mSV.showsVerticalScrollIndicator = FALSE;
    mSV.showsHorizontalScrollIndicator = FALSE;
    [_ShowBigScrollView addSubview:mSV];
    
    _ShowBigScrollView.pagingEnabled = YES;
    _ShowBigScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _ShowBigScrollView.showsVerticalScrollIndicator = FALSE;
    _ShowBigScrollView.showsHorizontalScrollIndicator = FALSE;
    _ShowBigScrollView.delegate = self;
}
#pragma mark - 缩放
- (void)singleClick
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].statusBarHidden;
}
#pragma mark - 双击
- (void)doubleClick:(MyScrollView *)mSV
{
    [UIView animateWithDuration:0.5 animations:^{
        if (mSV.zoomScale == 2.0)
        {
            mSV.zoomScale = 1.0;
        }
        else
        {
            mSV.zoomScale = 2.0;
        }
    }];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != _ShowBigScrollView) {
        return scrollView.subviews.firstObject ;
    }
    return 0;
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
