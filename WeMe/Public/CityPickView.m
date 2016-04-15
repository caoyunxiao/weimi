//
//  CityPickView.m
//  微密
//
//  Created by iOS Dev on 14/11/7.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "CityPickView.h"

#define kDuration 0.3


@implementation BackView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchBegin)]) {
        [self.delegate touchBegin];
    }
}


@end

@implementation CityPickView


- (IBAction)completeBtnClick:(id)sender
{
    if ([self.isCateOrLocation isEqualToString:@"2"]) {
        if (self.mricoBlock) {
            self.mricoBlock(mricoDict);
        }
    }
    else if ([self.isCateOrLocation isEqualToString:@"1"])
    {
        if (self.cityBlock)
        {
            self.cityBlock(proAndCitInfo);
        }
    }
    else
    {
        if (self.fenleiBlock)
        {
            self.fenleiBlock(self.model);
        }
        if (_kind)
        {
            self.kind(_shopKindModel);
        }
    }
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"ModelView"];
    [backView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
}

- (IBAction)cancelBtnClick:(id)sender {
    
    [self closeView];
}

- (id)initWithTitle:(NSString *)title delegate:(id)delegate
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CityPickView" owner:self options:nil]lastObject];
   
    if (self)
    {
        self.titleString.text = title;
        
        self.locatePickView.delegate = self;
        self.locatePickView.dataSource = self;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        provinces = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        cities  = [[provinces objectAtIndex:0] objectForKey:@"list"];
        
        proAndCitInfo = [[ProvincesAndCitiesModel alloc]init];
        
        proAndCitInfo.proName = [[provinces objectAtIndex:0] objectForKey:@"name"];
        
        proAndCitInfo.citName = [[cities objectAtIndex:0] objectForKey:@"name"];
        
        proAndCitInfo.code = [[cities objectAtIndex:0] objectForKey:@"code"];
    }
    return self;
}

#pragma mark --调用的方法--
- (id)initWithTitle:(NSString *)title  delegate:(id)delegate cates:(NSString*)cate typeStr:(NSString *)typeStr
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CityPickView" owner:self options:nil]lastObject];
    if (self)
    {
        self.isCateOrLocation = cate;
        
        self.locatePickView.delegate = self;
        self.locatePickView.dataSource = self;
        
        if ([cate isEqualToString:@"2"])
        {
            NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *doc = [NSString stringWithFormat:@"%@/MricoCate.plist",documentDir];
            
            mricoCateArray = [[NSArray alloc]initWithContentsOfFile:doc];
            
            if ([mricoCateArray count] > 0)
            {
                mricoDict = [mricoCateArray objectAtIndex:0];
            }
        }
        else if ([cate isEqualToString:@"1"])
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
            NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            provinces = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([typeStr isEqualToString:@"people"])
            {
                [provinces removeObjectAtIndex:0];
            }
            cities  = [[provinces objectAtIndex:0] objectForKey:@"list"];
            
            proAndCitInfo = [[ProvincesAndCitiesModel alloc]init];
            
            proAndCitInfo.proName = [[provinces objectAtIndex:0] objectForKey:@"name"];
            
            proAndCitInfo.citName = [[cities objectAtIndex:0] objectForKey:@"name"];
            
            proAndCitInfo.code = [[cities objectAtIndex:0] objectForKey:@"code"];
        }
        else if ([cate isEqualToString:@"3"])
        {
        }
        
        self.titleString.text = title;
    }
    return self;
}

- (void)showInView:(UIView *)view
{
      _shopKindModel = _kindArray[0];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    backView = [[BackView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    backView.backgroundColor = [UIColor grayColor];
    backView.alpha = 0.6;
    backView.delegate = self;
    
    [view addSubview:backView];
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    
    [self.layer addAnimation:animation forKey:@"DDModelView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

- (void)touchBegin
{
    [self closeView];
}

- (void)closeView
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"ModelView"];
    [backView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
}


#pragma mark --有几区--
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([self.isCateOrLocation isEqualToString:@"2"] || [self.isCateOrLocation isEqualToString:@"3"]) {
        return 1;
    }
    return 2;
}
#pragma mark --每一区有多少行--
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.isCateOrLocation isEqualToString:@"2"]) {
        return [mricoCateArray count];
    }
    else if ([self.isCateOrLocation isEqualToString:@"1"])
    {
        switch (component) {
            case 0:
                return [provinces count];
                break;
            case 1:
                
                return [cities count];
                break;
            default:
                return 0;
                break;
        }
    }
    else if ([self.isCateOrLocation isEqualToString:@"3"])
    {
        return [_titleArray count];
    }else
    {
        return 0;
    }
    
}
#pragma mak --显示的文字--
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.model = [_titleArray objectAtIndex:0];
    if ([self.isCateOrLocation isEqualToString:@"2"])
    {
        return [[mricoCateArray objectAtIndex:row] objectForKey:@"name"];;
    }
    else if ([self.isCateOrLocation isEqualToString:@"1"])
    {
        switch (component)
        {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"name"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"name"];
                break;
            default:
                return nil;
                break;
        }
    }
    else if ([self.isCateOrLocation isEqualToString:@"3"])
    {
        NewChannelModel * model = [_titleArray objectAtIndex:row];
        return model.name;
    }else
    {
        return nil;
    }
    
}

#pragma mark --选择pickview调用的方法--
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
   
    
    if ([self.isCateOrLocation isEqualToString:@"2"])
    {
        mricoDict = [mricoCateArray objectAtIndex:row];
    }
    else if ([self.isCateOrLocation isEqualToString:@"1"])
    {
        switch (component)
        {
            case 0:
                cities  = [[provinces objectAtIndex:row] objectForKey:@"list"];
                
                [self.locatePickView selectRow:0 inComponent:1 animated:NO];
                [self.locatePickView reloadComponent:1];
                
                proAndCitInfo.proName = [[provinces objectAtIndex:row] objectForKey:@"name"];
                
                proAndCitInfo.citName = [[cities objectAtIndex:0] objectForKey:@"name"];
                
                proAndCitInfo.code = [[cities objectAtIndex:0] objectForKey:@"code"];
                
                break;
            case 1:
                proAndCitInfo.citName = [[cities objectAtIndex:row] objectForKey:@"name"];
                proAndCitInfo.code = [[cities objectAtIndex:row] objectForKey:@"code"];
                break;
                
            default:
                break;
        }

    }
    else if([self.isCateOrLocation isEqualToString:@"3"])
    {
        self.model = [_titleArray objectAtIndex:row];
        
    }else
    {
        return;
    }
}
@end
