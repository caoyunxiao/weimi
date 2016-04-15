//
//  Encryption.h
//  CeshiDismiss
//
//  Created by iOS Dev on 14-9-3.
//  Copyright (c) 2014年 语境. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

#pragma mark -- jiami

@interface Encryption : NSObject

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

- (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;

- (NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

@end
