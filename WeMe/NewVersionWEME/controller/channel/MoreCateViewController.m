//
//  MoreCateViewController.m
//  微密
//
//  Created by mirrortalk on 15/9/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MoreCateViewController.h"
#import "MoreCateCell.h"
#import "NewChannelModel.h"
#import "DetailsClassViewController.h"

#define CellID (@"cellid")
@interface MoreCateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataArray;//数据源数组
    NSArray *_imgArray;
    UICollectionView *_collectionView;
}
@end

@implementation MoreCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //下载数据
    _dataArray=[NSMutableArray array];
    self.title = @"更多";
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    _imgArray=@[@"trafficGoOut",@"communicate.JPG",@"oneCityMakeFriend.JPG",@"hobby.JPG",@"astronomy.JPG",@"firstAid.png",@"play.JPG",@"movieStory.JPG",@"sexMotion.JPG",@"jokeWord.JPG",@"brandProducts.JPG",@"sing.jpg",@"offLineService"];
    NSString * type = _isQunLiao?@"2":@"1";
    [self getFenLeiWithType:type];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _collectionView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
}

-(void)createUI
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    CGFloat wd=(ScreenWidth-15)/2;
    layout.itemSize=CGSizeMake(wd, 200);
    layout.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing=5;
    layout.minimumLineSpacing=10;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 55, ScreenWidth, ScreenHeight-55) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"MoreCateCell" bundle:nil] forCellWithReuseIdentifier:CellID];
    
    [self.view addSubview:_collectionView];
}

- (void)getFenLeiWithType:(NSString *)type
{
    [self refreshWithStatus:YES];
    [RequestEngine getCatalogInfoWithType:type startPg:1 pageSize:19 completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *result) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            
            for (int i = 6; i<dataArray.count; i++)
            {
                NewChannelModel * model = [dataArray objectAtIndex:i];
                [_dataArray addObject:model];
                
            }
            [self createUI];
        }
        else
        {
            Alert(@"主人,获取类别失败,请稍后再试吧");
        }
    }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MoreCateCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    NewChannelModel *model=_dataArray[indexPath.item];
    cell.cateTitleLabel.text=model.name;

    [cell.cateImgView sd_setImageWithURL:[NSURL URLWithString:model.logoURL] placeholderImage:[UIImage imageNamed:_imgArray[indexPath.row]]];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewChannelModel *model=_dataArray[indexPath.row];
    DetailsClassViewController *dvc = [[DetailsClassViewController alloc]init];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];
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
