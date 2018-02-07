//
//  ViewController.m
//  objcdemo
//
//  Created by gabriel izebhigie on 15/01/2018.
//  Copyright © 2018 Interswitch. All rights reserved.
//

#import "ViewController.h"
@import PaymentSDK;

@interface ViewController ()

@property (strong, nonatomic) UITextField *customerId;
@property (strong, nonatomic) UITextField *amount;
@property (strong, nonatomic) UITextField *pan;
@property (strong, nonatomic) UITextField *expiry;
@property (strong, nonatomic) UITextField *pin;
@property (strong, nonatomic) UITextField *cvv;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIButton *payNow;

@end

@implementation ViewController


NSString *myclientId  = @"IKIA7B379B0114CA57FAF8E19F5CC5063ED2220057EF";
NSString *myclientSecret  = @"MiunSQ5SN219UCVP1Lt2raPfwK9lMoiV/PdBX5v/R4=";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [Passport overrideApiBase:@"https://qa.interswitchng.com/passport"];
    [Payment overrideApiBase:@"https://qa.interswitchng.com/passport"];
    
      self.customerId = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
      self.amount = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 200, 30)];
      self.pan = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, 200, 30)];
      self.expiry = [[UITextField alloc] initWithFrame:CGRectMake(20, 220, 200, 30)];
      self.cvv = [[UITextField alloc] initWithFrame:CGRectMake(20, 260, 200, 30)];
      self.pin = [[UITextField alloc] initWithFrame:CGRectMake(20, 300, 200, 30)];
    
      self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,40,40)];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.customerId.placeholder = @"Customer ID";
    self.customerId.borderStyle = UITextBorderStyleLine;
    self.customerId.text = @"1407002510";
    [self.view addSubview:self.customerId];
    
    self.amount.placeholder = @"Amount";
    self.amount.borderStyle = UITextBorderStyleLine;
    self.amount.text = @"1";
    [self.view addSubview:self.amount];
    
    self.pan.placeholder = @"Card No";
    self.pan.borderStyle = UITextBorderStyleLine;
    self.pan.keyboardType = UIKeyboardTypeNumberPad;
    self.pan.text = @"5060990580000217499";
    [self.view addSubview:self.pan];
    
    self.pin.placeholder = @"Card PIN";
    self.pin.borderStyle = UITextBorderStyleLine;
    self.pin.keyboardType = UIKeyboardTypeNumberPad;
    self.pin.text = @"1111";
    [self.view addSubview:self.pin];
    
    self.expiry.placeholder = @"Expiry";
    self.expiry.borderStyle = UITextBorderStyleLine;
    self.expiry.keyboardType = UIKeyboardTypeNumberPad;
    self.expiry.text = @"2004";
    [self.view addSubview:self.expiry];
    
    self.cvv.placeholder = @"CVV";
    self.cvv.borderStyle = UITextBorderStyleLine;
    self.cvv.keyboardType = UIKeyboardTypeNumberPad;
    self.cvv.text = @"111";
    [self.view addSubview:self.cvv];
    
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [self.view bringSubviewToFront:self.activityIndicator];
    
    //UIButton *payNow = [[UIButton alloc] initWithFrame:CGRectMake(20, 340, 40, 40)];
    self.payNow = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payNow.frame = CGRectMake(20, 340, 40, 40);
    //[payNow setTitle:@"Pay" forState:UIControlStateSelected];
    self.payNow.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    self.payNow.backgroundColor = UIColor.blackColor;
    self.payNow.titleLabel.textColor = UIColor.whiteColor;
    self.payNow.titleLabel.text = @"Pay";
    [self.view addSubview:self.payNow];
    [self.payNow addTarget:self action:@selector(onPayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.modalPresentationStyle = UIModalPresentationPopover;
    
}


-(void)onPayButtonClicked {
    if (!self.customerId.hasText) {
        [self showError:@"Customer ID is required"];
    } else if (!self.amount.hasText) {
        [self showError:@"Amount is required"];
    }else if (!self.pan.hasText) {
        [self showError:@"Card No is required"];
    }else if (!self.cvv.hasText) {
        [self showError:@"CVV is required"];
    }else if (!self.pin.hasText) {
        [self showError:@"Card PIN is required"];
    }else if (!self.expiry.hasText) {
        [self showError:@"Expiry is required"];
    }else {
         //[self showSuccess:@"Good Job"];
        
//        PaymentSDK *sdk = [[PaymentSDK alloc] initWithClientId:myclientId clientSecret:myclientSecret];
//
//        PurchaseRequest *purchase = [[PurchaseRequest alloc] initWithCustomerId:self.customerId.text amount:self.amount.text pan:self.pan.text pin:self.pin.text expiryDate:self.expiry.text cvv2:self.cvv.text transactionRef:[Payment randomStringWithLength: 12] currency:@"NGN" requestorId:@"12345678901"];
//
//
//        [sdk purchase:purchase completionHandler:^(PurchaseResponse * _Nullable purchaseResponse, NSError * _Nullable error) {
//
//            if(error != nil) {
//                NSString *errMsg = error.localizedDescription;
//
//                NSLog(@"Error: %@", errMsg);
//            } else if(purchaseResponse == nil) {
//                NSString *errMsg = error.localizedFailureReason;
//
//                NSLog(@"Failure: %@", errMsg);
//            } else if(purchaseResponse.responseCode == nil || [purchaseResponse.responseCode length] == 0) {
//                // OTP not required, payment successful.
//                // The response object contains fields transactionIdentifier, message,
//                // amount, token, tokenExpiryDate, panLast4Digits, otpTransactionIdentifier,
//                // transactionRef and cardType.
//                // Save the token, tokenExpiryDate, cardType and panLast4Digits in order to pay with the token in the future.
//            } else {
//                //NSString *responseCode = validateCardResponse.responseCode;
//                // At this point further authorization is required depending on the value of responseCode
//                // Please see below: Authorize PayWithCard
//            }
//        }];
        
        
//        PayWithCard *payWithCard = [[PayWithCard alloc] initWithClientId:myclientId clientSecret:myclientSecret customerId:self.customerId.text description:@"Payment" amount:self.amount.text currency:@"NGN"];
//
//        UIViewController *viewCtrl =[payWithCard start:^(PurchaseResponse * _Nullable purchaseResponse, NSError * _Nullable error) {
//            [self showError:error.localizedDescription];
//        }];
//
        WalletSDK *walletSdk = [[WalletSDK alloc] initWithClientId:myclientId clientSecret:myclientSecret];
        
        [walletSdk getPaymentMethods:^(WalletResponse *walletResponse, NSError *error) {
            if(error != nil) {
                NSString *errMsg = error.localizedDescription;
                
                NSLog(@"error getting payment methods ... %@", errMsg);
            } else if(walletResponse == nil) {
                NSString *errMsg = error.localizedFailureReason;
                
                NSLog(@"Failure: %@", errMsg);
            } else {
                if ([walletResponse.paymentMethods count] > 0) {
                    for (int i = 0; i < [walletResponse.paymentMethods count]; i++) {
                        PaymentMethod *aPaymentMethod = [walletResponse.paymentMethods objectAtIndex:i];
                        
                        NSLog(@"Payment Method card product: %@", aPaymentMethod.cardProduct);
                    }
                }
            }
        }];
        
    }
    
}

-(void)showError:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil ];
}

-(void)showSuccess:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil ];
}

-(void)handleOTP:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OTP2" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter OTP";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(alert.textFields.firstObject.hasText != nil){
            NSString *otp = alert.textFields.firstObject.text;
            //AuthorizeOtpRequest *otpReq =
        }
    }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
