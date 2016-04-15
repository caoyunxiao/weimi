//
//  MyAccountyViewController.m
//  微密
//
//  Created by mirrtalk on 15/6/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MyAccountyViewController.h"
#import "DetailWebViewViewController.h"
#import "MoneyModely.h"
#import <MapKit/MapKit.h>

@interface MyAccountyViewController ()
{
    NSMutableArray * _dataArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MyAccountyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"道客钱包";
    _buttonArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+50);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //[self requestMoneyData];
    [self getDataBaseFromTwoWay];
    _locationManager=[[CLLocationManager alloc]init];;
    _locationManager.delegate=self;
    [_locationManager startUpdatingLocation];
}

#pragma mark - 定位
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if (locations!=nil&&locations.count>0)
    {
        CLLocation *cllocat=[locations firstObject];
        _longitude = [NSString stringWithFormat:@"%f",cllocat.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%f",cllocat.coordinate.latitude];
        [HeaderModel sharedHeaderModel].latitude = _latitude;
        [HeaderModel sharedHeaderModel].longitude = _longitude;
        [_locationManager stopUpdatingLocation];
    }
}

#pragma mark - 从数据库或者网上加载数据
- (void)getDataBaseFromTwoWay
{
    NSString *strTable = @"moneyModelyTable";
    DBOperation *db = [[DBOperation alloc]init];
    BOOL ret = [db createMoneyModelyTable:strTable];
    if(ret)
    {
        NSArray *markArray = [db selectMoneyModelyDataBaseWith:strTable];
        if(markArray.count<=0)
        {
            //请求数据
            [self requestMoneyData];
        }
        else
        {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:markArray];
            if(_buttonArray.count>0)
            {
                [self clearnUIViewAboutButton];
            }
            [self setUI];
        }
    }
    else
    {
        //请求数据
        [self requestMoneyData];
    }
}

#pragma mark - 数据请求
- (void)requestMoneyData
{
    [self refreshWithStatus:YES];
    [RequestEngine queryDaoKeWallet:^(NSString *errorCode, NSMutableArray *dataArray) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"]&&dataArray.count>0)
        {
           _dataArray = dataArray;
            [self putInDataBaseWithMarks:_dataArray];
            if(_buttonArray.count>0)
            {
                [self clearnUIViewAboutButton];
            }
           [self setUI];
        }
    }];
}

#pragma mark - 把数据存到数据库
- (void)putInDataBaseWithMarks:(NSArray *)array
{
    NSString *strTable = @"moneyModelyTable";
    if(array.count>0)
    {
        DBOperation *db = [[DBOperation alloc]init];
        BOOL ret = [db createMoneyModelyTable:strTable];
        if(ret)
        {
            [db addMoneyModelyWithArray:array withTableName:strTable];
        }
    }
}

#pragma mark - 清除视图
- (void)clearnUIViewAboutButton
{
    for (NSArray *array in _buttonArray)
    {
        for (UIView *view in array)
        {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - 设置UI 所有模块
- (void)setUI
{
    /**
     *  暂时移除流量兑换功能
     */
    for (int i=0; i<_dataArray.count; i++) {
        MoneyModely *model=_dataArray[i];
        if ([model.name isEqualToString:@"流量兑换"]) {
            [_dataArray removeObjectAtIndex:i];
        }
    }
    NSInteger shang = _dataArray.count/3;
    NSInteger yu = _dataArray.count%3;
    NSInteger hang = (yu==0)?shang:shang+1;
    for (int j = 0; j<hang; j++)
    {
        NSInteger num = j==hang-1?yu:3;
        for (int i = 0; i<(yu==0?3:num); i++)
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            NSInteger tag = (i+1)+j*3;
            MoneyModely * model = [_dataArray objectAtIndex:tag-1];
            
            CGFloat screenW=[UIScreen mainScreen].bounds.size.width;
            CGFloat screenH=[UIScreen mainScreen].bounds.size.height;
            CGFloat btnW=(screenW-2)/3;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(107*i, 100+105*j, 106, 104);
            btn.frame = CGRectMake((btnW+1)*i, 100+105*j, btnW, 104);
            btn.backgroundColor = [UIColor whiteColor];
            btn.tag = tag;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [array addObject:btn];
            [self.scrollView addSubview:btn];
            
            
            CGFloat imgWH = (screenW/screenH)*45;//图片的宽高
            CGFloat imgBtweenW=(btnW - imgWH)/2;//图片两边的间距
//            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(33+(106+5)*i, 118+104*j, 30, 30)];
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(imgBtweenW+btnW*i, 130+104*j, imgWH, imgWH)];
            NSString * imageUrl = [NSString stringWithFormat:@"%@",model.icon];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            [array addObject:imageView];
            [self.scrollView addSubview:imageView];
            
//            UILabel * textLable = [[UILabel alloc]initWithFrame:CGRectMake(107*i, 166+104*j, 106, 21)];
            UILabel *textLable=[[UILabel alloc]initWithFrame:CGRectMake(btnW*i, 166+104*j, btnW, 21)];
            textLable.text = model.name;
            textLable.font = [UIFont systemFontOfSize:12];
            textLable.textAlignment = NSTextAlignmentCenter;
            [array addObject:textLable];
            [self.scrollView addSubview:textLable];
            [_buttonArray addObject:array];
        }
    }
}


#pragma mark --下方的按钮--
- (void)btnClick:(UIButton *)btn
{
    DetailWebViewViewController * vc = [[DetailWebViewViewController alloc]init];
    MoneyModely * model = [_dataArray objectAtIndex:btn.tag-1];
    vc.url = [NSString stringWithFormat:@"%@%@&longitude=%@&latitude=%@",model.url,[PersonInfo sharePersonInfo].accountIDString,_longitude,_latitude];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --余额和账单
- (IBAction)yuerAndZhangdanClick:(UIButton *)sender
{
    DetailWebViewViewController * vc = [[DetailWebViewViewController alloc]init];
    
    NSString * account = [PersonInfo sharePersonInfo].accountIDString;
    switch (sender.tag-120)
    {
        case 1:
        {
            vc.url = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/balance?accountID=%@&longitude=%@&latitude=%@",account,_longitude,_latitude];//余额
        }
            break;
        case 2:
        {
            vc.url = [NSString stringWithFormat:@"http://store.daoke.me/index.php/app/bill?accountID=%@&longitude=%@&latitude=%@",account,_longitude,_latitude];//账单
        }
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
