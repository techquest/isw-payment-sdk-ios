//
//  ViewController.m
//  ObjC_WalletDemo
//
//  Created by Efe Ariaroo on 6/2/16.
//  Copyright © 2016 Efe Ariaroo. All rights reserved.
//

#import "ViewController.h"
@import PaymentSDK;


@interface ViewController ()

@end

@implementation ViewController


NSString *yourClientId = @"IKIAB9CAC83B8CB8D064799DB34A58D2C8A7026A203B";
NSString *yourClientSecret = @"z+xzMgCB8cUu1XRlzj06/TiFgT9p2wuA6q5wiZc5HZo=";

WalletSDK *walletSdk = nil;

bool shouldLoadWalletFromServer = YES;
NSArray *paymentMethods;

NSString *tokenOfUserSelectedPM = nil;    //PM stands for payment method
NSString *tokenExpiryOfSelectedPM = @"";

NSString *requstorId = @"12345678901";      //Specify your own requestorId here
//--

UITextField *customerId = nil;
UITextField *amount = nil;
UITextField *cvvTextField = nil;
UITextField *pin = nil;
UITextField *paymentMethodTextField = nil;

UIPickerView *uiPickerView;

UIActivityIndicatorView *activityIndicator = nil;
//--
bool loadingWallet = NO;


- (id)init {
    self = [super init];
    if (self) {
        paymentMethods = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //--
    [self initializeSdk];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //--
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat headerXPos = (screenWidth - 250)/2;
    
    //--
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerXPos, 60, 250, 40)];
    headerLabel.text = @"Wallet payment demo";
    
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.view addSubview:headerLabel];
    
    //--
    [self initializeUIComponents];
}

- (void) initializeSdk
{
    [Payment overrideApiBase: @"https://sandbox.interswitchng.com"];
    [Passport overrideApiBase: @"https://sandbox.interswitchng.com/passport"];
    
    walletSdk = [[WalletSDK alloc] initWithClientId: yourClientId clientSecret: yourClientSecret];
}

- (void) initializeUIComponents
{
    CGFloat screenWidth = self.view.bounds.size.width;
    
    CGFloat textfieldsWidth = 250;
    CGFloat textfieldsHeight = 40;
    
    CGFloat XPosition = (screenWidth - textfieldsWidth)/2;
    CGFloat yTopMargin = 10.0;
    //--
    customerId = [[UITextField alloc] initWithFrame:CGRectMake(XPosition, 120, textfieldsWidth, textfieldsHeight)];
    customerId.text = @"07012122323"; // This should be a value that identifies your customer uniquely e.g email or phone number etc
    customerId.placeholder = @" Customer ID";
    customerId.layer.borderColor = [[UIColor blackColor] CGColor];
    customerId.layer.borderWidth = 2.0;
    [self.view addSubview: customerId];
    
    [self addPaymentMethodFunctions: XPosition :(160 + yTopMargin) :textfieldsWidth :textfieldsHeight];
    //--
    amount = [[UITextField alloc] initWithFrame:CGRectMake(XPosition, 200 + 2 * yTopMargin, textfieldsWidth, textfieldsHeight)];
    amount.text = @"200";
    amount.keyboardType = UIKeyboardTypeDecimalPad;
    amount.placeholder = @" Amount";
    amount.layer.borderColor = [[UIColor blackColor] CGColor];
    amount.layer.borderWidth = 2.0;
    
    [self.view addSubview: amount];
    //--
    cvvTextField = [[UITextField alloc] initWithFrame:CGRectMake(XPosition, 240 + 3 * yTopMargin, textfieldsWidth, textfieldsHeight)];
    cvvTextField.text = @"";
    cvvTextField.keyboardType = UIKeyboardTypeNumberPad;
    cvvTextField.placeholder = @" CVV";
    cvvTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    cvvTextField.layer.borderWidth = 2.0;
    
    [self.view addSubview: cvvTextField];
    //--
    pin = [[UITextField alloc] initWithFrame:CGRectMake(XPosition, 280 + 4 * yTopMargin, textfieldsWidth, textfieldsHeight)];
    pin.text = @"";
    pin.keyboardType = UIKeyboardTypeNumberPad;
    pin.placeholder = @" PIN";
    pin.layer.borderColor = [[UIColor blackColor] CGColor];
    pin.layer.borderWidth = 2.0;
    
    [self.view addSubview: pin];
    //--
    
    //Pay with card button
    UIButton *payWithWalletButton = [UIButton buttonWithType:UIButtonTypeSystem];
    payWithWalletButton.frame = CGRectMake(XPosition, 320 + 5 * yTopMargin, textfieldsWidth, textfieldsHeight);
    [payWithWalletButton setTitle:@"Pay with Wallet" forState:UIControlStateNormal];
    
    [payWithWalletButton addTarget:self action:@selector(makePayment:) forControlEvents:UIControlEventTouchUpInside];
    [self styleButton: payWithWalletButton];
    [self.view addSubview: payWithWalletButton];
    //--
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((screenWidth - 40)/2, 440, 40, textfieldsHeight)];
    
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //activityIndicator.center = view.center
    
    [self.view addSubview: activityIndicator];
    [activityIndicator bringSubviewToFront: self.view];
}

- (void) addPaymentMethodFunctions: (CGFloat) xPosition :(CGFloat) yPosition :(CGFloat) textfieldsWidth : (CGFloat) textfieldsHeight
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.translucent = YES;
    toolBar.tintColor = [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1.0];
    [toolBar sizeToFit];
    //--
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                    target:self action:@selector(cancelPicker:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, nil] animated:NO];
    toolBar.userInteractionEnabled = YES;
    //--
    paymentMethodTextField = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, yPosition, textfieldsWidth, textfieldsHeight)];
    paymentMethodTextField.text = @"";
    paymentMethodTextField.placeholder = @" Select Payment Method";
    
    paymentMethodTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    paymentMethodTextField.layer.borderWidth = 2.0;

    //--
    uiPickerView = [[UIPickerView alloc] init];
    uiPickerView.dataSource = self;
    uiPickerView.delegate = self;
    uiPickerView.showsSelectionIndicator = YES;
    
    //--
    paymentMethodTextField.inputView = uiPickerView;
    paymentMethodTextField.inputAccessoryView = toolBar;
    
    paymentMethodTextField.delegate = self;
    
    [self.view addSubview: paymentMethodTextField];
}

- (void) styleButton: (UIButton*) theButton {
    theButton.layer.cornerRadius = 5.0;
    theButton.backgroundColor = [UIColor blackColor];
    [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

//--
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(paymentMethods.count == 0 || shouldLoadWalletFromServer == YES) {
        [self loadWallet];
    }
}

- (void) loadWallet
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [activityIndicator startAnimating];
    
    [walletSdk getPaymentMethods:^(WalletResponse *walletResponse, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [activityIndicator stopAnimating];
        
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            //NSLog(@"error getting payment methods ... %@", errMsg);
            
            [self.view endEditing: true];
            [self showError: errMsg];
        } else if(walletResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;
            //NSLog(@"Failure: %@", errMsg);
            
            [self.view endEditing: true];
            [self showError: errMsg];
        } else if (walletResponse.paymentMethods.count > 0) {
            paymentMethods = walletResponse.paymentMethods;
            
            PaymentMethod *aPaymentMethod = [paymentMethods objectAtIndex:0];
            paymentMethodTextField.text = aPaymentMethod.cardProduct;
            tokenOfUserSelectedPM = aPaymentMethod.token;
            tokenExpiryOfSelectedPM = aPaymentMethod.tokenExpiry;
            
            shouldLoadWalletFromServer = NO;
            [uiPickerView reloadAllComponents];
        }
    }];
}

//--

- (void) makePayment :(id)sender
{
    if( [self isOkToMakePaymentRequest]) {
        PurchaseRequest *request = [[PurchaseRequest alloc] initWithCustomerId:customerId.text amount:amount.text pan: tokenOfUserSelectedPM
                                                                           pin: pin.text expiryDate: tokenExpiryOfSelectedPM
                                                                          cvv2: cvvTextField.text transactionRef: [Payment randomStringWithLength: 12]
                                                                      currency: @"NGN" requestorId: requstorId];

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [activityIndicator startAnimating];
        
        [walletSdk purchase:request completionHandler: ^(PurchaseResponse *purchaseResponse, NSError *error) {
            if(error != nil) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 [activityIndicator stopAnimating];
                
                NSString *errMsg = error.localizedDescription;
                NSLog(@"Normal error ... %@", errMsg);
                
                [self showError: errMsg];
            } else if(purchaseResponse == nil) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 [activityIndicator stopAnimating];
                
                NSString *errMsg = error.localizedFailureReason;
                NSLog(@"Failure: %@", errMsg);
                
                [self showError: errMsg];
            } else {
                if (purchaseResponse.otpTransactionIdentifier != nil) {
                    [self handleOTP:purchaseResponse.otpTransactionIdentifier :purchaseResponse.transactionRef :purchaseResponse.message];
                } else {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                     [activityIndicator stopAnimating];
                    
                    [self showSuccess: purchaseResponse.message];
                }
            }
        }];
    }
}

- (bool) isOkToMakePaymentRequest
{
    bool isOk = NO;
    
    if(!customerId.hasText) {
        [self showError: @"Customer ID is required"];
    } else if(!amount.hasText) {
        [self showError: @"Amount is required"];
    } else if(!pin.hidden && !pin.hasText) {
        [self showError: @"PIN is required"];
    } else if (tokenOfUserSelectedPM == nil || tokenOfUserSelectedPM.length == 0) {
        [self showError: @"Select a Payment Method" ];
    } else {
        isOk = true;
    }
    return isOk;
}

- (void) handleOTP: (NSString*)theOtpTransactionId :(NSString*)theOtpTransactionRef :(NSString*) otpMessage
{
    UIAlertController *otpAlertController = [UIAlertController alertControllerWithTitle: @"OTP transaction authorization"
                                                                                message: otpMessage
                                                                         preferredStyle: UIAlertViewStyleDefault];
    otpAlertController.view.tintColor = [UIColor greenColor];
    [otpAlertController addTextFieldWithConfigurationHandler:^(UITextField *otpTextField) {
        //otpTextField.placeholder = @"";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        [activityIndicator stopAnimating];
        NSString *theUserEnteredOtpValue = ((UITextField *)[otpAlertController.textFields objectAtIndex:0]).text;
        
        if(theUserEnteredOtpValue.length > 0) {
            [self showSuccess: @"You didn't enter an otp value"];
        } else if(theOtpTransactionId == nil) {
            [self showSuccess: @"Otp transaction identifier does not exist"];
        } else {
            AuthorizeOtpRequest *otpRequest = [[AuthorizeOtpRequest alloc] initWithOtpTransactionIdentifier:theOtpTransactionId
                                                                                                    otp: theUserEnteredOtpValue
                                                                                         transactionRef: theOtpTransactionRef];
            [walletSdk authorizeOtp:otpRequest completionHandler: ^(AuthorizeOtpResponse *authorizeOtpResponse, NSError *error) {
                if(error != nil) {
                    NSString *errMsg = error.localizedDescription;
                    NSLog(@"Normal error ... %@", errMsg);
                    
                    [self showSuccess: errMsg];
                } else if(authorizeOtpResponse == nil) {
                    NSString *errMsg = error.localizedFailureReason;
                    NSLog(@"Failure: %@", errMsg);
                    
                    [self showSuccess: errMsg];
                } else {
                    NSLog(@"Authorize Otp: %@", @"Authorize otp successful.");
                    
                    [self showSuccess: @"OTP authorization success"];
                }
            }];
        }
    }];
    [otpAlertController addAction:okAction];
                                            
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: nil];
    
    [self presentViewController: otpAlertController animated: true completion: nil];
}

//--

- (void) cancelPicker: (id) sender
{
    [paymentMethodTextField resignFirstResponder];
}

//--
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return paymentMethods.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PaymentMethod *selectedPaymentMethod = [paymentMethods objectAtIndex:row];
    
    tokenOfUserSelectedPM = selectedPaymentMethod.token;
    tokenExpiryOfSelectedPM = selectedPaymentMethod.tokenExpiry;
    
    return selectedPaymentMethod.cardProduct;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row >= 0 && row < paymentMethods.count) {
        PaymentMethod *thePaymentMethod = [paymentMethods objectAtIndex:row];
        
        NSString *cardProduct = thePaymentMethod.cardProduct;
        paymentMethodTextField.text = cardProduct;
        tokenOfUserSelectedPM = thePaymentMethod.token;
        
        if([cardProduct.lowercaseString containsString: @"ecash"] || [cardProduct.lowercaseString containsString: @"m-pin"]) {
            cvvTextField.hidden = YES;
        } else {
            cvvTextField.hidden = NO;
        }
        [self.view endEditing: true];
    }
}
//--


- (void) showError:(NSString*)message
{
    [self showAlert:message :@"Error"];
}

- (void) showSuccess:(NSString*)message
{
    [self showAlert:message :@"Success"];
}

- (void) showAlert:(NSString*)alertMessage :(NSString*) alertTitle
{
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


@interface NSString ( containsCategory )
- (BOOL) containsString: (NSString*) substring;
@end

@implementation NSString ( containsCategory )

- (BOOL) containsString: (NSString*) substring
{
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    
    return found;
}

@end
