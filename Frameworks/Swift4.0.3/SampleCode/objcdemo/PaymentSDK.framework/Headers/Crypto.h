//
//  JSRSA.h
//  PaymentSDK
//
//  Created by Adesegun Adeyemo on 07/10/2015.
//  Copyright © 2015 Interswitch Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Crypto : NSObject

- (NSString *)rsaPublicEncrypt:(NSString *)plainText;
+ (Crypto *)sharedInstance;

@end
