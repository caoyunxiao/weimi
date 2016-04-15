//
//  GoodsView.h
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsViewDelegate <NSObject>

- (void)applyExchangeGoods:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany name:(NSString *)name telephone:(NSString *)telephone address:(NSString *)address exchangeReason:(NSString *)exchangeReason;

@end


@interface GoodsView : UIView<UITextFieldDelegate>{
    
    NSArray *_textFieldArray;
}

@property(assign,nonatomic)id<GoodsViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *cashPassworldTextField;
//@property (weak, nonatomic) IBOutlet UITextField *tx1;


@property (weak, nonatomic) IBOutlet UITextField *manifestNumberTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

@property (weak, nonatomic) IBOutlet UITextField *reasonTextFeild;


@property (weak, nonatomic) IBOutlet UITextField *nameTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *phoneNameTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *adressTextFeild;

- (IBAction)confirmButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *confirmbtn;



@end
