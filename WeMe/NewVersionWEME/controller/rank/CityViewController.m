//
//  CityViewController.m
//  微密
//
//  Created by APP on 15/5/23.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "CityViewController.h"
#import "CityTableViewCell.h"
@interface CityViewController ()

@end

@implementation CityViewController
{
    NSArray *_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}
- (void)requestData
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine getArriveCity:^(NSString *errorcode, NSArray *cityArray) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([errorcode isEqualToString:@"0"]) {
            _dataArray = cityArray;
            [self.tableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _dataArray.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2"];
//    cell.textLabel.text = _dataArray[indexPath.row][@"cityName"];
    static NSString *cellId = @"cellId";
    if (indexPath.row == 0) {
        CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil][0];
        }
        cell.cityNameLabel.text = @"城市";
        cell.firstArriveTimeLabel.text = @"第一次去该城市的时间";
        return cell;
    }
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil][0];
    }
    cell.cityNameLabel.text = _dataArray[indexPath.row-1][@"cityName"];
    cell.firstArriveTimeLabel.text = _dataArray[indexPath.row-1][@"firstArriveTime"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
