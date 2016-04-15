//
//  CreateChannelViewController.m
//  微密
//
//  Created by Daoke Dev on 15/3/27.
//  Copyright (c) 2015年 longlz. All rights reserved.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "CreateChannelViewController.h"
#import "MobClick.h"
#import "CreatTableViewCell.h"
#import "ZHPickView.h"
#import "CityPickView.h"
#import "NewChannelModel.h"
#import "QRCodeGenerator.h"
#import "newInputViewController.h"
#import "ShareErWeiMaViewController.h"

@interface CreateChannelViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSArray * _titleArr;
    NSMutableArray * _detailTitleArr;
    NSMutableArray * _fenleiArr;//频道分类的数组
    NSString * _catagorlStr;//类别编码
    UISwitch *_switch;
}
@property (nonatomic,copy)NSString * areaCode;
@property (nonatomic,assign)NSInteger channelCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CreateChannelViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
#pragma mark --得到分类--
- (void)getFenleiData
{
    [RequestEngine getCatalogInfoWithType:@"2" startPg:1 pageSize:19 completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *result) {
        if ([errorCode isEqualToString:@"0"]) {
            _fenleiArr = dataArray;
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"NOTIFICATION_CLOSE_B" object:nil];
    self.title = @"创建群聊频道";
    _titleArr = @[@[@"频道头像"],@[@"频道名",@"分类",@"关键字",@"地区",@"简介"],@[@"公开频道",@"需要验证"]];
    NSArray * _arrayOne = @[@""];
    NSArray * _arrayTwo = @[@"输入频道名",@"选择分类",@"输入关键字",@"选择地区",@"输入简介"];
    NSArray * _arrayThree = @[@"允许被搜索",@"申请加入需要验证通过"];
    _detailTitleArr = [NSMutableArray arrayWithObjects:_arrayOne,_arrayTwo,_arrayThree,nil];
    _fenleiArr = [[NSMutableArray alloc]init];
    [self getFenleiData];
    [self addNavigationItem];
    _channelModel = [[NewChannelModel alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewControllerWithTag:) name:@"newInputViewController" object:nil];
}
- (void)addNavigationItem
{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}
#pragma mark - 返回上一层
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 完成创建
- (void)complete
{
    UILabel *channelName = (UILabel *)[self.view viewWithTag:110];
    _channelModel.channelName = channelName.text;
    _channelModel.channelCityCode = self.areaCode;
    
    UILabel *channelKeyWords = (UILabel *)[self.view viewWithTag:112];
    _channelModel.channelKeyWords = (channelKeyWords.text.length>4)?[channelKeyWords.text substringToIndex:4]:channelKeyWords.text;
    
    UILabel *introduction = (UILabel *)[self.view viewWithTag:114];
    _channelModel.introduction = introduction.text;
    
    CreatTableViewCell *channelCell = [self cellAtIndexRow:0 andAtSection:2];
    NSInteger i= channelCell.channleSwitch.on?1:0;
    _channelModel.openType = [NSString stringWithFormat:@"%ld",(long)i];
    
    CreatTableViewCell *veriyCell = [self cellAtIndexRow:1 andAtSection:2];
    NSInteger j = veriyCell.channleSwitch.on?1:0;
    _channelModel.isVerity = [NSString stringWithFormat:@"%ld",(long)j];
    _channelModel.channelCatalogID = _catagorlStr;
    
    if (_channelModel.channelName!=nil&&_channelModel.channelCityCode!=nil&&_channelModel.channelKeyWords!=nil&&_channelModel.introduction!=nil&&_channelModel.openType!=nil&&_channelModel.isVerity!=nil&&_channelModel.channelCatalogID!=nil)
    {
        if (_channelModel.channelName.length>15)
        {
            _channelModel.channelName = [_channelModel.channelName substringToIndex:15];
        }
        if (_channelModel.channelKeyWords.length>4)
        {
            _channelModel.channelKeyWords = [_channelModel.channelKeyWords substringToIndex:4];
        }
        if (_channelModel.introduction.length>20)
        {
            _channelModel.channelKeyWords = [_channelModel.introduction substringToIndex:20];
        }
        [self refreshWithStatus:YES];
        if(_userImage==nil)
        {
            _userImage = [UIImage imageNamed:[NSString stringWithFormat:@"默认频道头像%d.png",arc4random()%5+1]];
        }
        [RequestEngine uploadImageWithImage:_userImage imageType:@"1" channel:_channelModel completed:^(NSString *errorCode, NSDictionary *result) {
            [self refreshWithStatus:NO];
            if ([errorCode isEqualToString:@"0"])
            {
                //生成可分享的二维码
                _channelNumber = [result objectForKey:@"channelNumber"];
                _uniqueCode = [result objectForKey:@"uniqueCode"];
                ShareErWeiMaViewController *bvc = [[ShareErWeiMaViewController alloc]init];
                bvc.nameStr = channelName.text;
                bvc.number = _channelNumber;
                bvc.imageStr = _uniqueCode;
                UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:bvc];
                [self presentViewController:nav animated:YES completion:nil];
            }
            else if([errorCode isEqualToString:@"ME18106"])
            {
                Alert(@"主人,您创建的频道已经达到上限了哟");
            }else if([errorCode isEqualToString:@"ME01023"]){
                Alert(@"主人，换个频道名试试吧");
            }
            else
            {
                Alert(@"主人,创建失败了呀,请稍后再试试哦");
            }
        }];
    }
    else
    {
        Alert(@"主人,请把信息填写完整哦");
    }
}

- (CreatTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger)section {
    CreatTableViewCell * cell = (CreatTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}
#pragma mark --发送好友请求--/////
- (void)sendMessage
{
}
#pragma mark --表的配置--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_titleArr objectAtIndex:section]count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0?68:44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString * indentifer = @"CellOne";
        CreatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CreatTableViewCell" owner:self options:nil]objectAtIndex:0];
        }
        if (_userImage!=nil) {
            cell.oneImageView.image = _userImage;
        }
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        NSString * indentifer = @"CellThree";
        CreatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CreatTableViewCell" owner:self options:nil]objectAtIndex:2];
        }
        
        cell.bigTitleLable.text = [[_titleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.smallTitleLable.text = [[_detailTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        if(indexPath.row==0)
        {
            cell.channleSwitch.on = YES;
        }
        else if (indexPath.row==1)
        {
            cell.channleSwitch.on = NO;
        }

        return cell;
    }
//    else if ((indexPath.section == 1 &&indexPath.row == 0)||(indexPath.section == 1 &&indexPath.row == 4)||(indexPath.section == 1 &&indexPath.row == 2))
//    {
//        NSString * indentifer = @"CellTwo";
//        CreatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
//        if (!cell)
//        {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"CreatTableViewCell" owner:self options:nil]objectAtIndex:1];
//        }
//        cell.twoTitleLable.text = [[_titleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//        cell.twoTextField.text = [[_detailTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//        cell.twoTextField.tag = [[NSString stringWithFormat:@"11%ld",indexPath.row] integerValue];
//        cell.twoTextField.textColor = kLevelFourColor;
//        return cell;
//    }
    else
    {
        NSString * indentifer = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifer];
        }
       
        cell.textLabel.text = [[_titleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[_detailTitleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.textLabel.font = kLevelTwoFont;
        cell.detailTextLabel.font = kLevelFourFont;
        cell.detailTextLabel.textColor = kLevelFourColor;
        cell.detailTextLabel.tag = [[NSString stringWithFormat:@"11%ld",indexPath.row] integerValue];
        return cell;
    }
}
-(void)pushViewControllerWithTag:(NSNotification *)notifi
{
    UILabel *label = nil;
    NSString *inputTextField = [notifi.userInfo objectForKey:@"inputTextField"];
    NSString *twoTitleLable = [notifi.userInfo objectForKey:@"twoTitleLable"];
    
    if([twoTitleLable isEqualToString:@"频道名"])
    {
        label = (UILabel *)[self.view viewWithTag:110];
    }
    else if ([twoTitleLable isEqualToString:@"关键字"])
    {
        label = (UILabel *)[self.view viewWithTag:112];
    }
    else if ([twoTitleLable isEqualToString:@"简介"])
    {
        label = (UILabel *)[self.view viewWithTag:114];
    }
    label.text = inputTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    newInputViewController * vc = [[newInputViewController alloc]init];
    vc.twoTitleLable = [[_titleArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    switch (indexPath.section)
    {
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"相机", nil),NSLocalizedString(@"从相册选择", nil),nil];
            [sheet showInView:self.view];
        }
            break;
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [self presentViewController:nav animated:YES completion:nil];
                    break;
                }
                case 1:
                    [self addFenLei];
                    break;
                case 2:
                {
                    [self presentViewController:nav animated:YES completion:nil];
                    break;
                }
                case 3:
                    [self addAreaPicker];
                    break;
                case 4:
                {
                    [self presentViewController:nav animated:YES completion:nil];
                    break;
                }
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --添加分类pickerView--
- (void)addFenLei
{
    //CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"分类选择" delegate:self cates:@"3"];
    CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"城市选择" delegate:self cates:@"3" typeStr:@""];
    cpv.titleArray = _fenleiArr;
    [cpv showInView:self.view];
    cpv.fenleiBlock = ^(NewChannelModel *model)
    {
        _catagorlStr = model.number;
        NSString *str = [NSString stringWithFormat:@"%@",model.name];
        NSMutableArray * array = [NSMutableArray arrayWithArray:[_detailTitleArr objectAtIndex:1]];
        [array replaceObjectAtIndex:1 withObject:str];
        [_detailTitleArr replaceObjectAtIndex:1 withObject:array];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
    };
}
#pragma mark --添加地区picker--
- (void)addAreaPicker
{
    //CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"城市选择" delegate:self cates:@"1"];
    CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"城市选择" delegate:self cates:@"1" typeStr:@""];
    [cpv showInView:self.view];
    cpv.cityBlock = ^(ProvincesAndCitiesModel *proAndCitInfo)
    {
        NSString * str = [NSString stringWithFormat:@"%@ %@",proAndCitInfo.proName,proAndCitInfo.citName];
        
        self.areaCode= proAndCitInfo.code;
        NSMutableArray * array = [NSMutableArray arrayWithArray:[_detailTitleArr objectAtIndex:1]];
        [array replaceObjectAtIndex:3 withObject:str];
        [_detailTitleArr replaceObjectAtIndex:1 withObject:array];
        NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
    };
}
#pragma mark -选择头像 UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:NULL];
        } else {
            Alert(@"请在iOS'设置'-'隐私'-'相机'中打开");
        }
    } else if (buttonIndex == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        UINavigationBar *bar = imagePicker.navigationBar;
        [bar setTintColor:[UIColor whiteColor]];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

#pragma mark --头像UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        _userImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
