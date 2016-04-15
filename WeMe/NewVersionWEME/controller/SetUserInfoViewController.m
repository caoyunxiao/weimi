//
//  SetUserInfoViewController.m
//  微密
//
//  Created by APP on 15/5/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "SetUserInfoViewController.h"
#import "BindWMViewController.h"

@interface SetUserInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation SetUserInfoViewController
{
    NSArray *_sexArray;
    UIView *_backView;
    UIView *_selectSexPickerView;
    UIPickerView *_selectSexPicker;
    UIButton *_sexButton;
    NSInteger _sexStr;
    
    NSMutableArray *_dataArray;
    UIPickerView *_selectAddressPicker;
    NSMutableArray *_provinceArray;//省份的数组
    NSMutableArray *_cityArray;//城市的数组，在接下来的代码中会有根据省份的选择进行数据更新的操作
    UIView *_addressBackView;
    UIView *_selectAddressPickerView;
    UIButton *_addressButton;
    NSString *_addressStr;
    NSInteger _rowInProvince;
    NSInteger _rowInCity;
    NSMutableArray *_codeArray;//地理位置编码
    NSString *_cityCode;//
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人信息";
    _sexArray = @[@"女",@"男"];
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 5;
    [self setUserInfors];
    [self.navigationItem setHidesBackButton:YES];
    [self createSexPicker];
    [self createAddressPicker];
    self.nickNameTextField.returnKeyType = UIReturnKeyDone;
}
#pragma mark - 完善个人信息 加载已有的信息
- (void)setUserInfors
{
    if([self.pressType isEqualToString:@"presentViewController"])
    {
        PersonInfo *presonInfo = [PersonInfo sharePersonInfo];
        NSString *nicknameString = presonInfo.nicknameString;
        NSString *areaStr = presonInfo.areaStr;
        NSString *sexString = presonInfo.sexString;
        if(nicknameString!=nil&&![nicknameString isEqual:[NSNull null]]&&nicknameString.length!=0)
        {
            self.nickNameTextField.text = nicknameString;
        }
        if(areaStr!=nil&&![areaStr isEqual:[NSNull null]]&&areaStr.length!=0)
        {
            self.areaTextField.text = areaStr;
        }
        if(sexString!=nil&&![sexString isEqual:[NSNull null]]&&sexString.length!=0)
        {
            _sexStr = [sexString integerValue];
            
            self.sexTextField.text = _sexArray[_sexStr>2?1:_sexStr];
        }
        NSString *iconString = presonInfo.senderUserHeadName;
        if(iconString.length>0)
        {
            _userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconString]]];
            [self.headButton setBackgroundImage:_userImage forState:UIControlStateNormal];
            self.tishiLabel.hidden = YES;
        }
        else
        {
            //没有头像
            self.tishiLabel.hidden = NO;
        }
    }
}

#pragma mark - 创建地址选择器
- (void)createAddressPicker
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    _dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_dataArray removeObjectAtIndex:0];
    _provinceArray = [[NSMutableArray alloc] init];
    _cityArray = [[NSMutableArray alloc] init];
    _codeArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in _dataArray) {
        [_provinceArray addObject:dic[@"name"]];
    }
    for (NSDictionary *dic in _dataArray[_rowInProvince][@"list"]) {
        [_cityArray addObject:dic[@"name"]];
        [_codeArray addObject:dic[@"code"]];
    }
    if (_addressBackView == nil)
    {
        _addressBackView = [[UIView alloc]initWithFrame:self.view.bounds];
        _addressBackView.backgroundColor = [UIColor colorWithRed:155/255.0 green:156/255.0 blue:156/255.0 alpha:0.5];
    }
    [self.view addSubview:_addressBackView];
    _addressBackView.hidden = YES;
    
    _selectAddressPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-250, ScreenWidth, 240)];
    _selectAddressPickerView.backgroundColor = [UIColor whiteColor];
    [_addressBackView addSubview:_selectAddressPickerView];
    
    _addressButton= [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-42, 0, 42, 42)];
    _addressButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addressButton setImage:[UIImage imageNamed:@"btn_020.png"] forState:UIControlStateNormal];
    [_addressButton addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _addressButton.tag = 201;
    [_selectAddressPickerView addSubview:_addressButton];
    
    UIButton *cancelBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"btn_022.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 202;
    [_selectAddressPickerView addSubview:cancelBtn];
    
    UILabel *pickerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-100)/2, 0, 100, 42)];
    pickerTitleLabel.text = @"城市选择";
    pickerTitleLabel.font = [UIFont systemFontOfSize:17];
    pickerTitleLabel.textAlignment = NSTextAlignmentCenter;
    pickerTitleLabel.textColor = [UIColor colorWithRed:22/255.0 green:165/255.0 blue:76/255.0 alpha:1];
    [_selectAddressPickerView addSubview:pickerTitleLabel];
    
    _selectAddressPicker = [[UIPickerView alloc]init];
    _selectAddressPicker.delegate = self;
    _selectAddressPicker.dataSource = self;
    _selectAddressPicker.showsSelectionIndicator = YES;
    _selectAddressPicker.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _selectAddressPicker.frame = CGRectMake(0, 42, ScreenWidth, 180);
    [_selectAddressPickerView addSubview:_selectAddressPicker];
    
}
#pragma mark - 地址选择完成
- (void)addressButtonClick:(UIButton *)button
{
    if(button.tag == 201)
    {
        if (_provinceArray.count < _rowInProvince || _cityArray.count < _rowInCity) {
            return;
        }
        NSString *proString = _provinceArray[_rowInProvince];
        NSString *cityString = _cityArray[_rowInCity];
        _cityCode = _codeArray[_rowInCity];
        if ([proString isEqualToString:cityString]) {
            _areaTextField.text = proString;
        }else{
            _areaTextField.text = [NSString stringWithFormat:@"%@ %@",proString,cityString];
        }
    }
    _addressBackView.hidden = YES;
}
#pragma mark - 创建性别选择器
- (void)createSexPicker
{
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
    
    _sexButton= [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-42, 0, 42, 42)];
    _sexButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_sexButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sexButton setImage:[UIImage imageNamed:@"btn_020.png"] forState:UIControlStateNormal];
    [_sexButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sexButton.tag = 101;
    [_selectSexPickerView addSubview:_sexButton];
    
    UIButton *cancelBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
        self.sexTextField.text = _sexArray[_sexStr];
    }
    _backView.hidden = YES;
}
#pragma mark-几段
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _selectAddressPicker) {
        return 2;
    }
    return 1;
}
#pragma mark-行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _selectAddressPicker) {
        if (component == 0) {//省份个数
            return [_provinceArray count];
        } else if (component == 1){//市的个数
            return [_cityArray count];
        }
    }
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
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _selectAddressPicker.frame.size.width/2, 40)];
    label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
    if (pickerView == _selectSexPicker) {
        
        label.text = _sexArray[row];
       // return label;
    }else{
        if (component == 0) {//选择省份名
            label.text =  [_provinceArray objectAtIndex:row];
        } else{//选择市名
            label.text =  [_cityArray objectAtIndex:row];
        }
    }
    return label;
}
#pragma mark-选中一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _selectSexPicker) {
        _sexStr = row;
    }else{
        if (component == 0) {
            _rowInProvince = row;
            [_cityArray removeAllObjects];
            [_codeArray removeAllObjects];
            for (NSDictionary *dic in _dataArray[row][@"list"]) {
                [_cityArray addObject:dic[@"name"]];
                [_codeArray addObject:dic[@"code"]];
            }
            
            [_selectAddressPicker reloadComponent:1];
        }else{
            _rowInCity = row;
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.sexTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.areaTextField)
    {
        [self.nickNameTextField resignFirstResponder];
        _addressBackView.hidden = NO;
        return NO;
    }
    else if (textField == self.sexTextField)
    {
        [self.nickNameTextField resignFirstResponder];
        _backView.hidden = NO;
        return NO;
    }
    return YES;
}
- (IBAction)headerButtonClick:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    actionSheet.tag = 1999;
    [actionSheet showInView:self.view];
}
#pragma mark - 选择照相或者照片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1999)
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
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,相机无法使用哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
                
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
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,无法访问相册哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [av show];
            }
        }
        else if (buttonIndex==2)//取消
        {
        }

    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //判断选择完的资源是image还是media
    NSString *str = [info objectForKey:UIImagePickerControllerMediaType];
    if ([str isEqualToString:(NSString *)kUTTypeImage])
    {
        _userImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [RequestEngine uploadImageWithImage:_userImage completed:^(NSString *errorCode, NSString *result) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([errorCode isEqualToString:@"0"])
            {
                //通知重新获取头像
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGetUserImage" object:nil userInfo:nil];
                [self.headButton setBackgroundImage:_userImage forState:UIControlStateNormal];
                self.tishiLabel.text = @"";
                Alert(@"主人,头像上传成功了哦");
            } else {
                Alert(@"主人,头像上传失败了哦");
            }
        }];
        [self putIconImageInDocuments:_userImage iconName:[PersonInfo sharePersonInfo].phoneString];
    }
    else
    {
        Alert(@"主人,头像上传失败了哦");
    }
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
#pragma mark - 下一步
- (IBAction)nextButtonClick:(id)sender
{
    //与服务器交互 成功后执行：上传数据  数据本地存储
    if(self.nickNameTextField.text.length<=0)
    {
        Alert(@"主人,你忘记填写昵称了");
        return;
    }
    if (self.nickNameTextField.text.length>18)
    {
        Alert(@"主人,昵称不要超过18个字符哦");
    }
    if(self.sexTextField.text.length<=0)
    {
        Alert(@"主人,告诉我一下你的性别嘛");
        return;
    }
    if(self.areaTextField.text.length<=0)
    {
        Alert(@"主人,你还没有选择地区呢");
        return;
    }
    [self uploadUserInforWith];
}
#pragma mark - 上传个人信息
- (void)uploadUserInforWith
{
    if (_cityCode.length==0)
    {
        _cityCode = @"0";
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine uploadUserInforWith:self.nickNameTextField.text areaCode:_cityCode gender:[NSString stringWithFormat:@"%ld",_sexStr] completed:^(NSString *errorCode, NSString *resultStr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([errorCode isEqualToString:@"0"])
        {
            [PersonInfo sharePersonInfo].nicknameString = self.nickNameTextField.text;
            [PersonInfo sharePersonInfo].sexString = [NSString stringWithFormat:@"%ld",_sexStr];
            [PersonInfo sharePersonInfo].areaStr = self.areaTextField.text;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.nickNameTextField.text forKey:kNickName];
            [defaults setObject:[NSString stringWithFormat:@"%ld",_sexStr] forKey:kSex];
            [defaults setObject:self.areaTextField.text forKey:@"areaCode"];
            [defaults setObject:self.areaTextField.text forKey:kArea];
            [defaults synchronize];
            if([self.pressType isEqualToString:@"presentViewController"])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                //跳转绑定页面
                BindWMViewController *bvc = [[BindWMViewController alloc]init];
                [self.navigationController pushViewController:bvc animated:YES];
            }
        }
        else
        {
            Alert(@"主人,信息提交失败了,再试一下嘛");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
