//
//  DetailInfoViewController.m
//  微密
//
//  Created by longlz on 14-7-14.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "MyViewController.h"
#import "ModiyPersonInfo.h"
#import "CityPickView.h"
#import "MobClick.h"
#import "PersonInfo.h"
#import "BindingViewController.h"

@class DataBase;


@interface DetailInfoViewController ()<UIAlertViewDelegate>
{
    ModelView *_modelView;
}
@end

@implementation DetailInfoViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"个人信息";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    if (_tableView != nil)
    {
        [self refrshShowData];
    }
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uiCofig];
    [self createSexPicker];    //创建性别选择器
    _isShowBaoCun = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshView" object:nil];  //刷新界面的通知
    [self showBigHeadIconViewNew];
}
#pragma mark - 查看大图黑色背景
- (void)showBigHeadIconViewNew
{
    NSString *senderUserHeadName = [PersonInfo sharePersonInfo].senderUserHeadName;
    _zoomScrollView = [[MRZoomScrollView alloc]init];
    _zoomScrollView.backgroundColor = [UIColor blackColor];
    _zoomScrollView.showsVerticalScrollIndicator = NO;
    _zoomScrollView.showsHorizontalScrollIndicator = NO;
    _zoomScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _zoomScrollView.imageView.frame = CGRectMake(ScreenWidth, 84, 0, 0);
    [_zoomScrollView.imageView sd_setImageWithURL:[NSURL URLWithString:senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    _zoomScrollView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_zoomScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    tap.numberOfTapsRequired = 1;//需要轻击的次数  默认为1
    tap.numberOfTouchesRequired = 1;//响应这个时间需要的手指个数 默认为1
    [_zoomScrollView addGestureRecognizer:tap];
    _zoomScrollView.hidden = YES;
    
    //长按
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
//    [_zoomScrollView addGestureRecognizer:longPress];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_zoomScrollView addGestureRecognizer:longPress];
}
#pragma mark -  点击事件
-(void)singleTap:(UIGestureRecognizer*)sender
{
    self.navigationController.navigationBarHidden = NO;
    _zoomScrollView.imageView.frame = CGRectMake(ScreenWidth, 84, 0, 0);
    _zoomScrollView.hidden = YES;
    _isShowBaoCun = NO;
}
#pragma mark - 长按事件
-(void)longPress:(UILongPressGestureRecognizer *)sender
{
    if(_isShowBaoCun)
    {
        _isShowBaoCun = !_isShowBaoCun;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        actionSheet.tag = 1128;
        [actionSheet showInView:self.view];
        
    }
}

#pragma mark - 设置UI界面数据
- (void)uiCofig
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    _userImageView = [[UIImageView alloc]init];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 5;
    _isfirst = YES;
    _dataArray = @[@[@"头像",@"昵称",@"IMEI",@"手机号",@"等级"],@[@"姓名",@"性别",@"地区",@"身份证"],@[@"车牌号",@"驾驶证"]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - 通知刷新界面
- (void)refreshView:(NSNotification *)notifi
{
    [self refrshShowData];
}

#pragma mark - 创建性别选择器
- (void)createSexPicker
{
    _sexArray = @[@"女",@"男"];
    
    if (_backView == nil)
    {
        _backView = [[UIView alloc]initWithFrame:self.view.bounds];
        _backView.backgroundColor = [UIColor colorWithRed:155/255.0 green:156/255.0 blue:156/255.0 alpha:0.5];
    }
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    
    _selectSexPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-250, ScreenWidth, 240)];
    _selectSexPickerView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_selectSexPickerView];
    //_selectSexPickerView.hidden = YES;
    
    _sexButton= [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-42, 0, 42, 42)];
    _sexButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_sexButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[_sexButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sexButton setImage:[UIImage imageNamed:@"btn_020.png"] forState:UIControlStateNormal];
    [_sexButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sexButton.tag = 101;
    [_selectSexPickerView addSubview:_sexButton];
    
    UIButton *cancelBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"btn_022.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 102;
    [_selectSexPickerView addSubview:cancelBtn];
    
    UILabel *pickerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-100)/2, 0, 100, 42)];
    pickerTitleLabel.text = @"性别选择";
    pickerTitleLabel.font = [UIFont systemFontOfSize:17];
    pickerTitleLabel.textAlignment = NSTextAlignmentCenter;
    pickerTitleLabel.textColor = [UIColor colorWithRed:22/255.0 green:165/255.0 blue:76/255.0 alpha:1];
    [_selectSexPickerView addSubview:pickerTitleLabel];
    
    _selectSexPicker = [[UIPickerView alloc]init];
    _selectSexPicker.delegate = self;
    _selectSexPicker.dataSource = self;
    _selectSexPicker.tag = 100;
    _selectSexPicker.showsSelectionIndicator = YES;
    _selectSexPicker.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _selectSexPicker.frame = CGRectMake(0, 42, ScreenWidth, 190);
    [_selectSexPickerView addSubview:_selectSexPicker];
}
#pragma mark - 性别选择完成
- (void)buttonClick:(UIButton *)button
{
    if(button.tag == 101)
    {
        [self UpDateUserSex:(int)_sexStr];
    }
    _backView.hidden = YES;
}
#pragma mark-几段
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
#pragma mark-行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _sexArray.count;
}
#pragma mark-行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
#pragma mark-行视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, _selectSexPicker.frame.size.width, 40)];
    label.text = _sexArray[row];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
#pragma mark - 选中一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _sexStr = row;
}
#pragma mark - 刷新数据
- (void)refrshShowData
{
    NSString *nickName =[PersonInfo sharePersonInfo].nicknameString;
    NSString *imeiString = [PersonInfo sharePersonInfo].IMEIString;
    NSString *phoneString = [PersonInfo sharePersonInfo].phoneString;
    NSString *nameString = [PersonInfo sharePersonInfo].nameString;
    NSString *sexString = [PersonInfo sharePersonInfo].sexString;
    NSString *carNumberString = [PersonInfo sharePersonInfo].carNumberString;
    NSString *driveString = [PersonInfo sharePersonInfo].driveString;
    NSString *area = [[NSUserDefaults standardUserDefaults] objectForKey:kArea];//地区
    NSString *idUserNumber = [PersonInfo sharePersonInfo].idNumber;//身份证号
    NSString *grade = [NSMutableString stringWithFormat:@"%@",[PersonInfo sharePersonInfo].grade];
    NSString *gradeTitle = [PersonInfo sharePersonInfo].gradeTitle;
    if(grade==nil||grade.length<=0)
    {
        grade = @"0";
    }
    else if (![grade hasPrefix:@"LV"])
    {
        if(grade==nil)
        {
            grade = @"0";
        }
        NSMutableString *gradeStr = [[NSMutableString alloc]initWithFormat:@"LV%@",grade];
        grade = gradeStr;
    }
    if(gradeTitle==nil||gradeTitle.length<=0)
    {
        gradeTitle = @"驾校学员";
    }
    NSString *gradeMsg = [NSString stringWithFormat:@"%@%@",grade,gradeTitle];
    if (imeiString.length < 1)
    {
        imeiString = @"未绑定";
    }
    
    if (nameString.length <1)
    {
        nameString = @" ";
    }
    
    if (phoneString.length <1)
    {
        phoneString = @"未绑定";
    }
    
    if (sexString.length > 0)
    {
        if ([sexString intValue] == 0)
        {
            sexString = @"女";
        }else
        {
            sexString = @"男";
        }
    }
    else
    {
        sexString = @" ";
    }
    
    if (carNumberString.length < 1)
    {
        carNumberString = @" ";
    }
    
    if (driveString.length < 1)
    {
        driveString = @" ";
    }
    if ([area isEqualToString:@""] || area == nil) {
        
        area = @"北京市北京市";
    }
    if(idUserNumber==nil||[idUserNumber isEqual:[NSNull null]])
    {
        idUserNumber = @"";
    }
    _dataDetailArray = [[NSMutableArray alloc] initWithObjects:@[@"",nickName,imeiString,phoneString,gradeMsg],@[nameString,sexString,area,idUserNumber],@[carNumberString,driveString],nil];
    
    [_tableView reloadData];
}
#pragma mark --表的配置--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [_dataArray objectAtIndex:section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row == 0 && indexPath.section == 0)
    {
        static NSString *cellID = @"firstCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        
        
        cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.detailTextLabel.hidden = YES;
        _userImageView.frame = CGRectMake(cell.frame.size.width-70, 10, 60, 60);
        [cell addSubview:_userImageView];
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
        UIButton *buttonIcon = [[UIButton alloc]initWithFrame:_userImageView.frame];
        [buttonIcon addTarget:self action:@selector(showBigImageView) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:buttonIcon];
    }
    else
    {
        static NSString *cellID = @"cellID";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[_dataDetailArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    cell.textLabel.font = kLevelTwoFont;
    
    cell.textLabel.textColor = kLevelTwoColor;
    
    cell.detailTextLabel.font = kLevelThreeFont;
    
    cell.detailTextLabel.textColor = kLevelThreeColor;
    
    return cell;
}

#pragma mark - 查看大图头像
- (void)showBigImageView
{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBarHidden = YES;
    _zoomScrollView.hidden = NO;
    _isShowBaoCun = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _zoomScrollView.imageView.frame = CGRectMake(0, (ScreenHeight-ScreenWidth)/2, ScreenWidth, ScreenWidth);
    }];
}

#pragma mark - 区域选择器
- (void)addAreaPicker
{
    CityPickView *cpv = [[CityPickView alloc]initWithTitle:@"城市选择" delegate:self cates:@"1" typeStr:@"people"];
    self.view.frame = CGRectMake(0, 24, ScreenWidth, ScreenHeight );
    [cpv showInView:self.view];
    
    cpv.cityBlock = ^(ProvincesAndCitiesModel *proAndCitInfo)
    {
        NSString * str = [NSString stringWithFormat:@"%@ %@",proAndCitInfo.proName,proAndCitInfo.citName];
        self.areaCode =[[NSString stringWithFormat:@"%@",proAndCitInfo.code] integerValue];
        [self updateFixUser:proAndCitInfo.code];
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:kArea];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self refrshShowData];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case  0:
            switch (indexPath.row)
        {
            case 0:
                //修改头像
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
                [actionSheet showInView:self.view];
            }
                break;
            case 1:
                [self showAlertView:@"昵称" andMessage:@"最长12个字符" andTag:12];
                break;
            case 2:
                //IMEI;
            {
                NSString *imeiString = [PersonInfo sharePersonInfo].IMEIString;
                MyViewController *my = [[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
                [self.navigationController pushViewController:my animated:YES];
                my.IMEIString = imeiString;
                if ([imeiString isEqualToString:@"未绑定"] || [imeiString isEqualToString:@""])
                {
                    my.isBound = NO;
                }
                else
                {
                    my.isBound = YES;
                }
            }
                break;
            case 3:{
                //修改手机号
                BindingViewController *bvc = [[BindingViewController alloc]init];
                bvc.isShowTiaoGuo = @"hide";
                bvc.oldPhoneNumber = [PersonInfo sharePersonInfo].phoneString;
                [self.navigationController pushViewController:bvc animated:YES];
            }
                //[self showAlertView:@"手机号" andMessage:@"" andTag:14];
                break;
            case 4:
                break;
                
            default:
                break;
        }
            
            break;
            
        case  1:
            switch (indexPath.row)
        {
            case 0:
                [self showAlertView:@"姓名" andMessage:@"" andTag:21];
                break;
            case 1:
            {
                _backView.hidden = NO;
            }
                break;
            case 2:
                //区域
                [self addAreaPicker];
                break;
                
            default:
                break;
        }
            
            break;
            
        case  2:
            
            switch (indexPath.row)
        {
            case 0:
                [self showAlertView:@"车牌号" andMessage:@"" andTag:31];
                break;
            case 1:
                [self showAlertView:@"驾照号" andMessage:@"" andTag:32];
                break;
            default:
                break;
        }
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 80;
    }
    else
        return 44;
}

#pragma mark - 选择照相或者照片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1128)
    {
        //保存头像
        if(buttonIndex==0)
        {
            NSString *senderUserHeadName = [PersonInfo sharePersonInfo].senderUserHeadName;
            UIImage *image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:senderUserHeadName]]];
             UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:index:), NULL);
        }
        else
        {
            //取消
        }
        _isShowBaoCun = YES;
    }
    else
    {
        UIImagePickerController *pc = [[UIImagePickerController alloc]init];
        pc.delegate = self;
        if(buttonIndex==0)//拍照
        {
            //设置资源类型
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [pc setSourceType:UIImagePickerControllerSourceTypeCamera];
                pc.allowsEditing = YES;
                [self presentViewController:pc animated:YES completion:nil];
            }
            else
            {
                Alert(@"主人,相机无法使用哦");
            }
        }
        else if (buttonIndex==1)//选择
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                [pc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                //设置允许编辑
                pc.allowsEditing = YES;
                [self presentViewController:pc animated:YES completion:nil];
            }
            else{
                Alert(@"主人,无法访问相册哦");
            }
        }
        else if (buttonIndex==2)//取消
        {
        }
    }
}

#pragma mark - 保存指定回调方法
- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo index:(NSInteger)index
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"主人,图片保存失败了哦" ;
    }
    else
    {
        msg = @"主人,图片保存成功了哦" ;
    }
    Alert(msg);
}

#pragma mark - UIImagePickerControllerDelegate相关
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //判断选择完的资源是image还是media
    NSString *str = [info objectForKey:UIImagePickerControllerMediaType];
    if ([str isEqualToString:(NSString *)kUTTypeImage])
    {
        _userImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self refreshWithStatus:YES];
        [RequestEngine uploadImageWithImage:_userImage completed:^(NSString *errorCode, NSString *result) {
            [self refreshWithStatus:NO];
            if ([errorCode isEqualToString:@"0"]) {
                [_tableView reloadData];
                [_zoomScrollView.imageView sd_setImageWithURL:[NSURL URLWithString:result] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
                //通知重新获取头像
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGetUserImage" object:nil userInfo:nil];
                Alert(@"主人,头像上传成功了哦");
            } else {
                Alert(@"主人,头像上传失败了哦");
            }
        }];
        [self putIconImageInDocuments:_userImage iconName:[[_dataDetailArray objectAtIndex:0] objectAtIndex:3]];
    }
    else
    {
        Alert(@"主人,头像上传失败了哦");
    }
}

- (void) showAlertView:(NSString*)title andMessage:(NSString*)msg andTag:(NSUInteger)tag
{
    UIAlertView * a = [[UIAlertView alloc] initWithTitle:title message:msg  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    a.alertViewStyle = UIAlertViewStylePlainTextInput;
    a.tag = tag;
    [a show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *tf=[alertView textFieldAtIndex:0]; //获得输入框
    NSString * requestedText=tf.text;                //获得值
    if (alertView.tag == 12)
    {
        if (buttonIndex == 1)
        {
            //昵称
            if(requestedText.length>0)
            {
                [self UpDateUserNikeName:requestedText];
            }
            else
            {
                Alert(@"主人,你还没有输入昵称呢");
            }
        }
    }
    else if (alertView.tag == 21)
    {
        if (buttonIndex == 1)
        {
            //姓名
            if(requestedText.length>0)
            {
                [self UpDateUserName:requestedText];
            }
            else
            {
                Alert(@"主人,你还没有输入你的姓名呢");
            }
        }
    }
    else if (alertView.tag == 22)
    {
        if (buttonIndex == 1)
        {
            //性别
            //[self UpDateUserSex:[requestedText intValue]];
        }
    }
    else if (alertView.tag == 31)
    {
        if (buttonIndex == 1)
        {
            //车牌号
            if(requestedText.length>0)
            {
                [self UpDateUserLicenceNumber:requestedText];
            }
            else
            {
                Alert(@"主人,你还没有输入车牌号呢");
            }
        }
    }
    else if (alertView.tag == 32)
    {
        if (buttonIndex == 1)
        {
            //驾照号
            if(requestedText.length>0)
            {
                [self UpDateUserDriverLicenseNumber:requestedText];
            }
            else
            {
                Alert(@"主人,你还没有输入驾照号呢");
            }
        }
    }
}
#pragma mark - 修改地区
- (void) updateFixUser:(NSString *)code
{
    [self refreshWithStatus:YES];
    NSString *accountID = [PersonInfo sharePersonInfo].accountIDString;
    NSString *nickName = [PersonInfo sharePersonInfo].nicknameString;
    [RequestEngine fixUserInfo:@{@"appKey":@"iOS",@"accountID":accountID,@"nickname":nickName,@"areaCode":code} completed:^(NSString *errorCode) {
        if([errorCode isEqualToString:@"0"])
        {
            [self refreshWithStatus:NO];
            Alert(@"主人,地区修改成功了哦");
        }
    }];
    
}
#pragma mark - 修改昵称
- (void)UpDateUserNikeName:(NSString *)textFieldValue
{
    [self refreshWithStatus:YES];
    if ([textFieldValue length] > 12)
    {
        textFieldValue = [textFieldValue substringToIndex:12];
    }
    
    ModiyPersonInfo *info = [[ModiyPersonInfo alloc]init];
    [info modifyPersonInfoNickname:textFieldValue info:^(BOOL isFinised)
     {
         [self refreshWithStatus:NO];
         if (isFinised)
         {
             [PersonInfo sharePersonInfo].nicknameString = textFieldValue;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
         }
         else
         {
             Alert(@"主人,网络不给力啊,请检查一下网络吧");
         }
         
     }];
}
#pragma mark - 修改姓名
- (void)UpDateUserName:(NSString *)textFieldValue
{
    [self refreshWithStatus:YES];
    ModiyPersonInfo *info = [[ModiyPersonInfo alloc]init];
    [info modifyPersonInfoName:textFieldValue info:^(BOOL isFinised)
     {
         [self refreshWithStatus:NO];
         if (isFinised)
         {
             [PersonInfo sharePersonInfo].nameString = textFieldValue;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
         }
         else
         {
             Alert(@"主人,网络不给力啊,请检查一下网络吧");
         }
         
     }];
}
#pragma mark - 修改性别
- (void)UpDateUserSex:(int)textFieldValue
{
    [self refreshWithStatus:YES];
    ModiyPersonInfo *info = [[ModiyPersonInfo alloc]init];
    [info modifyPersonInfoSex:textFieldValue info:^(BOOL isFinised)
     {
         [self refreshWithStatus:NO];
         if (isFinised)
         {
             [PersonInfo sharePersonInfo].sexString = [NSString stringWithFormat:@"%d",textFieldValue];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
         }else
         {
             Alert(@"主人,网络不给力啊,请检查一下网络吧");
         }
         
     }];
}

//#pragma mark - 车牌号
- (void)UpDateUserLicenceNumber:(NSString *)textFieldValue
{
    [self refreshWithStatus:YES];
    ModiyPersonInfo *info = [[ModiyPersonInfo alloc]init];
    [info modifyPersonInfoPlateNumber:textFieldValue info:^(BOOL isFinised)
     {
         [self refreshWithStatus:NO];
         if (isFinised)
         {
             [PersonInfo sharePersonInfo].carNumberString = textFieldValue;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];

         }else
         {
             Alert(@"主人,网络不给力啊,请检查一下网络吧");
         }

     }];
}
#pragma mark - 驾照号
- (void)UpDateUserDriverLicenseNumber:(NSString *)textFieldValue
{
    [self refreshWithStatus:YES];
    ModiyPersonInfo *info = [[ModiyPersonInfo alloc]init];
    [info modifyPersonInfoDrivingLicense:textFieldValue info:^(BOOL isFinised)
     {
         [self refreshWithStatus:NO];
         if (isFinised)
         {
             [PersonInfo sharePersonInfo].driveString = textFieldValue;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
         }else
         {
             Alert(@"主人,网络不给力啊,请检查一下网络吧");
         }

     }];
}
#pragma mark - 保存照片到沙河
- (void)putIconImageInDocuments:(UIImage *)iconImage iconName:(NSString *)iconName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",iconName]];
    BOOL result = [UIImagePNGRepresentation(iconImage)writeToFile:filePath atomically:YES];
    if(!result)
    {
        Alert(@"主人,网络不给力啊,请检查一下网络吧");
    }
}
#pragma mark - 获取沙河中的头像图片
- (UIImage *)getIconImageInDocuments:(NSString *)iconName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",[paths objectAtIndex:0],iconName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
