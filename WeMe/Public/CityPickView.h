//
//  CityPickView.h
//  微密
//
//  Created by iOS Dev on 14/11/7.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvincesAndCitiesModel.h"
#import "ShopKind.h"



@protocol BackViewDelgate <NSObject>

- (void)touchBegin;

@end

@interface BackView : UIView

@property(assign,nonatomic)id<BackViewDelgate> delegate;

@end

typedef void (^FenLeiBlock)(NewChannelModel * model);
typedef void(^CityBlock)(ProvincesAndCitiesModel *proAndCitInfo);


typedef void(^MricoBlock)(NSDictionary *mricoDict);


typedef void(^ShoppingKindBlock)(ShopKind * kind);


@interface CityPickView : UIView<BackViewDelgate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BackView *backView;
@private
    NSMutableArray *provinces;
    NSArray	*cities;
    NSArray *mricoCateArray;

    
    ProvincesAndCitiesModel *proAndCitInfo;
    ShopKind * _shopKindModel;
    NSDictionary            *mricoDict;
    
    //NSString *cityNameString;
    //NSString *cityCodeString;
}
@property(nonatomic,strong)NewChannelModel * model;
@property(copy,nonatomic)FenLeiBlock fenleiBlock;
@property (copy,nonatomic)CityBlock cityBlock;
@property (copy,nonatomic)MricoBlock mricoBlock;
@property (copy,nonatomic)ShoppingKindBlock kind;
@property (nonatomic,strong)NSArray* kindArray;
@property(nonatomic,strong)NSArray * titleArray;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePickView;

@property (strong, nonatomic) IBOutlet UILabel *titleString;


@property (strong, nonatomic) IBOutlet UIButton *completeBtn;


@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (assign,nonatomic)NSString *   isCateOrLocation;

- (IBAction)completeBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;


- (id)initWithTitle:(NSString *)title delegate:(id)delegate;

- (void)showInView:(UIView *)view;

- (id)initWithTitle:(NSString *)title  delegate:(id)delegate cates:(NSString*)cate typeStr:(NSString *)typeStr;


@end
