//
//  ViewController.m
//  ObjC_PaymentDemo
//
//  Created by Efe Ariaroo on 5/26/16.
//  Copyright © 2016 Efe Ariaroo. All rights reserved.
//

#import "ViewController.h"

#import "ObjC_PaymentDemo-Bridging-Header.h"
@import PaymentSDK;

@interface ViewController ()

@end

@implementation ViewController


NSString *yourClientId = @"IKIA7B379B0114CA57FAF8E19F5CC5063ED2220057EF";
NSString *yourClientSecret = @"MiunSQ5S/N219UCVP1Lt2raPfwK9lMoiV/PdBX5v/R4=";

NSString *theCustomerId = @"9689808900";     // This should be a value that identifies your customer uniquely e.g email or phone number etc
NSString *paymentDescription = @"Payment for goods";
NSString *theAmount = @"200";
NSString *theCurrency = @"NGN";

NSString *theToken = @"5060990580000217499"; //This should be a valid token value that was stored after a previously successful payment
NSString *theCardType = @"verve";            //This should be a valid card type e.g mastercard, verve, visa etc

NSString *theExpiryDate = @"2004";
NSString *panLast4Digits = @"7499";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [Payment overrideApiBase: @"https://sandbox.interswitchng.com"];
    [Passport overrideApiBase: @"https://sandbox.interswitchng.com/passport"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
    //--
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat yTopMargin = 10.0;
    CGFloat buttonsWidth = 250;
    CGFloat buttonsHeight = 40;
    
    CGFloat XPosition = (screenWidth - buttonsWidth)/2;
    
    //--
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPosition, 60, 250, 40)];
    headerLabel.text = @"Payment demo";
    
    //headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0 ];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0 ];
    headerLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:headerLabel];
    
    //--
    //Pay with card or wallet button
    
    UIButton *payWithCardOrWalletButton = [UIButton buttonWithType:UIButtonTypeSystem];
    payWithCardOrWalletButton.frame = CGRectMake(XPosition, 100 + yTopMargin, buttonsWidth, buttonsHeight);
    [payWithCardOrWalletButton setTitle:@"Pay with Card or Wallet" forState:UIControlStateNormal];
    //[payWithCardOrWalletButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [payWithCardOrWalletButton addTarget:self action:@selector(payWithCardOrWallet:) forControlEvents:UIControlEventTouchUpInside];
    [self styleButton: payWithCardOrWalletButton];
    [self.view addSubview: payWithCardOrWalletButton];
    
    //--
    //Pay with card button
    UIButton *payWithCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    payWithCardButton.frame = CGRectMake(XPosition, 150 + yTopMargin, buttonsWidth, buttonsHeight);
    [payWithCardButton setTitle:@"Pay with Card" forState:UIControlStateNormal];
    //[payWithCardOrWalletButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [payWithCardButton addTarget:self action:@selector(payWithCard:) forControlEvents:UIControlEventTouchUpInside];
    [self styleButton: payWithCardButton];
    [self.view addSubview: payWithCardButton];
    
    //--
    //Pay with wallet button
    UIButton *payWithWalletButton = [UIButton buttonWithType:UIButtonTypeSystem];
    payWithWalletButton.frame = CGRectMake(XPosition, 190 + 2 * yTopMargin, buttonsWidth, buttonsHeight);
    [payWithWalletButton setTitle:@"Pay with Wallet" forState:UIControlStateNormal];
    //[payWithCardOrWalletButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [payWithWalletButton addTarget:self action:@selector(payWithWallet:) forControlEvents:UIControlEventTouchUpInside];
    [self styleButton: payWithWalletButton];
    [self.view addSubview: payWithWalletButton];
    
    //--
    //Pay with token button
    UIButton *payWithToken = [UIButton buttonWithType:UIButtonTypeSystem];
    payWithToken.frame = CGRectMake(XPosition, 230 + 3 * yTopMargin, buttonsWidth, buttonsHeight);
    [payWithToken setTitle:@"Pay with token" forState:UIControlStateNormal];
    //[payWithCardOrWalletButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [payWithToken addTarget:self action:@selector(payWithToken:) forControlEvents:UIControlEventTouchUpInside];
    [self styleButton: payWithToken];
    [self.view addSubview: payWithToken];
    //--
    //Validate card button
    UIButton *validateCardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    validateCardButton.frame = CGRectMake(XPosition, 270 + 4 * yTopMargin, buttonsWidth, buttonsHeight);
    [validateCardButton setTitle:@"Validate card" forState:UIControlStateNormal];
    //[payWithCardOrWalletButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [validateCardButton addTarget:self action:@selector(validateCard:) forControlEvents:UIControlEventTouchUpInside];
    [self styleButton: validateCardButton];
    [self.view addSubview: validateCardButton];
}

- (void) styleButton: (UIButton*) theButton {
    theButton.layer.cornerRadius = 5.0;
    
    theButton.backgroundColor = [UIColor blackColor];
    
    [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[theButton setTitleColor:[UIColor colorWithRed:36/255.0 green:71/255.0 blue:113/255.0 alpha:1.0] forState:UIControlStateNormal];
}

- (void) payWithCardOrWallet:(id)sender {
    Pay *pwcw = [[Pay alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId
                                   description: paymentDescription amount: theAmount currency: theCurrency];
    UIViewController *vc = [pwcw start:^(PurchaseResponse *purchaseResponse, NSError *error) {
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            
            [self showError: errMsg];
        } else if(purchaseResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;

            [self showError:errMsg];
        } else {
            //NSLog(@"Payment success: %@", purchaseResponse.message);
            [self showSuccess:purchaseResponse.message];
        }
    }];
    [self.navigationController pushViewController:vc animated:true];
}

//--
- (void) payWithCard: (id)sender {
    PayWithCard *pwc = [[PayWithCard alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId
                                                   description: paymentDescription amount: theAmount currency: theCurrency];
    UIViewController *vc = [pwc start:^(PurchaseResponse *purchaseResponse, NSError *error) {
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            
            [self showError: errMsg];
        } else if(purchaseResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;
            
            [self showError: errMsg];
        } else {
            //NSLog(@"Payment success: %@", purchaseResponse.message);
            
            [self showSuccess:purchaseResponse.message];
        }
    }];
    [self.navigationController pushViewController:vc animated:true];
}

- (void) payWithWallet:(id)sender {
    PayWithWallet *pww = [[PayWithWallet alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId
                                                       description: paymentDescription amount: theAmount currency: theCurrency];
    UIViewController *vc = [pww start:^(PurchaseResponse *purchaseResponse, NSError *error) {
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            //NSLog(@"Normal error ... %@", errMsg);
            
            [self showError: errMsg];
        } else if(purchaseResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;
            //NSLog(@"Failure: %@", errMsg);
            
            [self showError: errMsg];
        } else {
            //NSLog(@"Payment success: %@", purchaseResponse.message);
            [self showSuccess:purchaseResponse.message];
        }
    }];
    [self.navigationController pushViewController:vc animated:true];
}

- (void) payWithToken: (id) sender {
    PayWithToken *pwt = [[PayWithToken alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId
                                                   description: paymentDescription amount: theAmount token: theToken
                                                      currency: theCurrency expiryDate: theExpiryDate cardType: theCardType last4Digits: panLast4Digits];
    UIViewController *vc = [pwt start:^(PurchaseResponse *purchaseResponse, NSError *error) {
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            //NSLog(@"Normal error ... %@", errMsg);
            
            [self showError: errMsg];
        } else if(purchaseResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;
            //NSLog(@"Failure: %@", errMsg);
            
            [self showError: errMsg];
        } else {
            //NSLog(@"Payment success: %@", purchaseResponse.message);
            [self showSuccess:purchaseResponse.message];
        }
    }];
    [self.navigationController pushViewController:vc animated:true];
}

- (void) validateCard:(id)sender {
    ValidateCard *validateCard = [[ValidateCard alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId];
    
    UIViewController *vc = [validateCard start:^(ValidateCardResponse *validateResponse, NSError *error) {
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            //NSLog(@"Normal error ... %@", errMsg);
            
            [self showError: errMsg];
        } else if(validateResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;
            //NSLog(@"Failure: %@", errMsg);
            
            [self showError: errMsg];
        } else {
            NSLog(@"Validate card success! Transaction ref: %@", validateResponse.transactionRef);
            
            [self showSuccess:@"Validating your card was successful."];
        }
    }];
    [self.navigationController pushViewController:vc animated:true];
}


- (void) showError:(NSString*)message {
    [self showAlert:message :@"Error"];
}

- (void) showSuccess:(NSString*)message {
    [self showAlert:message :@"Success"];
}

- (void) showAlert:(NSString*)alertMessage :(NSString*) alertTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
