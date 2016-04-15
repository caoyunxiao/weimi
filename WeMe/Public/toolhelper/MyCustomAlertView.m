//
//  MyCustomAlertView.m
//  微密
//
//  Created by weme on 15/10/16.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import "MyCustomAlertView.h"
@interface MyCustomAlertView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end
@implementation MyCustomAlertView

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource=dataSource;
    if (dataSource.count>0) {
        [self.tableView reloadData];
    }
}
-(instancetype)initWithXib{

    return [[NSBundle mainBundle]loadNibNamed:@"MyCustomAlertView" owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    CGRect frame=[[UIApplication sharedApplication].delegate window].frame;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    bgView.backgroundColor=[UIColor clearColor];
    [[[UIApplication sharedApplication].delegate window]addSubview:bgView];
    self.layer.cornerRadius=10.0f;
    self.bgView=bgView;
    self.tableView.scrollEnabled=NO;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.layer.borderColor=getRGB(128, 128, 128).CGColor;
    self.layer.borderWidth=1;
}
/**
 *  取消
 *
 *  @param sender <#sender description#>
 */
- (IBAction)cancelAction:(UIButton *)sender {
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}
/**
 *  去更新
 *
 *  @param sender <#sender description#>
 */
- (IBAction)goToUpdateAction:(UIButton *)sender {
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(goToAppStore)]) {
        [self.delegate goToAppStore];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *txt=self.dataSource[indexPath.row];
    CGSize size=[Tool sizeWithText:txt font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (txt.length>20) {
        return size.height*2;
    }else{
        return size.height;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"alertCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]init];
    }
//    cell.layer.borderWidth=1;
//    cell.layer.borderColor=[UIColor redColor].CGColor;
    cell.textLabel.text=self.dataSource[indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines=0;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
