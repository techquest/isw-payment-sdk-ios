##Payment SDK for ​iOS

Interswitch payment SDK allows you to accept payments from customers within your mobile application.

### Outline
- [Before you begin](#BeforeYouBegin)
- [Using the SDK in Sandbox Mode](#UsingSDKInSandboxMode)
- [Using the SDK with UI](#UsingSDKWithUi)
  *  [Pay with Card](#PayWithCardWithUi)
  *  [Pay With Wallet](#PayWithWalletWithUi)
  *  [Validate Card](#ValidateCardWithUi)
  *  [Pay with Token](#PayWithTokenWithUi)
- [Using the SDK without UI](#UsingSDKWithoutUi)
    * [Pay with Card / Token](#PayWithCardOrTokenWithoutUi)
    * [Pay with Wallet](#PayWithWalletWithoutUi)
    * [Validate Card and Get Token](#ValidateCardWithoutUi)
    * [Authorize PayWithCard using OTP](#AuthorizePayWithCardWithoutUi)
    * [Authorize Card Validation using OTP](#AuthorizeCardValidationWithoutUi)
    * [Authorize PayWithWallet using OTP](#AuthorizeWalletPurchaseWithoutUi)
    * [Get Payment Status](#GetPaymentStatusWithoutUi)

### <a id='BeforeYouBegin'></a>Before you begin


* The first step to ​using the ​iOS SDK is to register as a merchant. This is described [here] (http://merchantxuat.interswitchng.com/paymentgateway/getting-started/overview/sign-up-as-a-merchant)

* Install **Xcode 7.3** or later 

* Install the latest **CocoaPods**

  ```terminal
  $ sudo gem install cocoapods
  ```

* (Optional) Try the PaymentDemoApp project, which is in the SampleCode directory in the SDK.
* **Note: Only iOS 8 and later are supported by the SDK**

###Step 1. Download the SDK

Download the SDK from the link below and unzip the archive to **~/Documents/PaymentSDK**.

https://github.com/techquest/isw-payment-sdk-ios/releases


###Step 2. Create a Swift Payment App

Create a payment app using **Xcode** with Swift as the language.

Alternatively, you can also create an Objective-C project.

If you haven’t registered your app on DevConsole register the app and get your Client ID and Client Secret


###Step 3 Add the SDK dependencies to your Xcode project

* Close the **Xcode** project

* Open Terminal and navigate to the directory that contains your project by using the **cd** command

  ```terminal
  $ cd ~/Path/To/Folder/Containing/YourProject
  ```


* Next, enter this command

  ```terminal
  $ pod init
  ```

This creates a Podfile for your project

* Open the Podfile and replace the two commented lines with the following

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"
use_frameworks!
```

* Add the following to your Podfile, inside the first target block:
```
pod 'CryptoSwift'
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'OpenSSL'
```

Enter the following command:
	​```terminal
	$ pod install
	​```

You should see output similar to the following:

```
Analyzing dependencies
Pre-downloading: `Alamofire` from `https://github.com/Alamofire/Alamofire.git`
Pre-downloading: `SwiftyJSON` from `https://github.com/SwiftyJSON/SwiftyJSON.git`
Downloading dependencies
Installing Alamofire (3.0.1)
Installing CryptoSwift (0.1.1)
Installing OpenSSL (1.0.204.1)
Installing SwiftyJSON (2.3.0)
Generating Pods project
Integrating client project
 
[!] Please close any current Xcode sessions and use `YourProject.xcworkspace` for this project from now on.
```

* Open `YourProject.xcworkspace`

###Step 4. Add SDK to your Xcode Project

Open the **~/Documents/PaymentSDK** directory

Drag the ​ **PaymentSDK.framework** file to the ``Embedded Binaries`` section of your app's **TARGETS** settings(`General` tab).

In the dialog that appears, make sure ‘Copy items if needed’ is checked in the ‘Choose options for adding these files’


### <a id='UsingSDKInSandboxMode'></a>USING THE SDK IN SANDBOX MODE

The procedure to use the SDK in sandbox mode is just as easy,

* Use sandbox client id and secret got from the developer console after signup(usually you have to wait for 5 minutes for you to see the sandbox details) 
* Override the api base as follows

*Swift*
```swift
Passport.overrideApiBase("https://sandbox.interswitchng.com/passport"); 
Payment.overrideApiBase("https://sandbox.interswitchng.com");
```

*Objective C*
```Objective-C
[Passport overrideApiBase: @"https://sandbox.interswitchng.com/passport"];
[Payment overrideApiBase: @"https://sandbox.interswitchng.com"];
```

* Make sure you include the following import statement

*Swift*
```swift
import PaymentSDK
```

*Objective C*
```Objective-C
@import PaymentSDK;
```
* Follow the remaining steps in the documentation



## <a id='UsingSDKWithUi'></a>Using the SDK with UI (In PCI-DSS Scope: No )
Now that you created and configured your Xcode project, you can add your choice of Payment SDK features to your app:

-  [Pay with Card or Wallet](#PayWithCardOrWalletWithUi)
-  [Pay with Card](#PayWithCardWithUi)
-  [Pay With Wallet](#PayWithWalletWithUi)
-  [Validate Card](#ValidateCardWithUi)
-  [Pay with Token](#PayWithTokenWithUi)

### <a id='PayWithCardOrWalletWithUi'></a>Pay with Card or Wallet
    
* To allow for Payment with Card or Wallet
* Create a Pay UIButton
* Add a target to the button that will call the below code.

  Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
let yourClientId = "IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276"
let yourClientSecret = "Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A="
let theCustomerId = "9689808900" // This should be a value that identifies your customer uniquely e.g email or phone number etc
let paymentDescription = "Payment for goods"
let theAmount = "200"

let payWithCardOrWallet = Pay(clientId: yourClientId, clientSecret: yourClientSecret, 
                              customerId: theCustomerId, description: paymentDescription,
                              amount: theAmount, currency: "NGN")
let vc = payWithCardOrWallet.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
    guard error == nil else {
        //let errMsg = (error?.localizedDescription)!                
        // Handle error.
        // Payment not successful.
        
        return
    }
    guard let response = purchaseResponse else {
        //let failureMsg = (error?.localizedFailureReason)!
        // Handle error.
        // Payment not successful.
        
        return
    }
    /*  Handle success
        Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits and transactionRef.
        Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
     */
})
```

*Objective C*
```Objective-C
NSString *yourClientId = @"IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276";
NSString *yourClientSecret = @"Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=";

NSString *theCustomerId = @"9689808900";     // This should be a value that identifies your customer uniquely e.g email or phone number etc
NSString *paymentDescription = @"Payment for goods";
NSString *theAmount = @"200";
NSString *theCurrency = @"NGN";

Pay *pwcw = [[Pay alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId
                              description: paymentDescription amount: theAmount currency: theCurrency];
UIViewController *vc = [pwcw start:^(PurchaseResponse *purchaseResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        // Handle error.
        // Payment not successful.

    } else if(purchaseResponse == nil) {
        NSString *failureMsg = error.localizedFailureReason;
        // Handle error.
        // Payment not successful.

    } else {
      /*  Handle success 
          Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits and transactionRef. 
          Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
      */
    }
}];
```


### <a id='PayWithCardWithUi'></a>Pay with Card
    
* To allow for Payment with Card only
* Create a Pay UIButton
* Add a target to the button that will call the below code.

Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
let clientId = "IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276"
let clientSecret = "Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A="
let theCustomerId = "" // This should be a value that identifies your customer uniquely e.g email or phone number etc
let paymentDescription = "Payment for goods"
let amount = "200"
let currency = "NGN"

let payWithCard = PayWithCard(clientId: clientId, clientSecret: clientSecret,
                      customerId: theCustomerId, description: paymentDescription,
                      amount: amount, currency: currency)
let vc = payWithCard.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
    guard error == nil else {
        //let errMsg = (error?.localizedDescription)!                
        // Handle error.
        // Payment not successful.
        
        return
    }
    guard let response = purchaseResponse else {
        //let failureMsg = (error?.localizedFailureReason)!
        // Handle error.
        // Payment not successful.
        
        return
    }
    /*  Handle success
        Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits and transactionRef.
        Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
     */
})
```

*Objective C*
```Objective-C
NSString *clientId = @"IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276";
NSString *clientSecret = @"Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=";

NSString *theCustomerId = @"9689808900";     // This should be a value that identifies your customer uniquely e.g email or phone number etc
NSString *paymentDescription = @"Payment for goods";
NSString *theAmount = @"200";
NSString *theCurrency = @"NGN";

PayWithCard *pwc = [[PayWithCard alloc] initWithClientId:clientId clientSecret:clientSecret customerId:theCustomerId
                                             description: paymentDescription amount: theAmount currency: theCurrency];
UIViewController *vc = [pwc start:^(PurchaseResponse *purchaseResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        // Handle error.
        // Payment not successful.

    } else if(purchaseResponse == nil) {
        NSString *failureMsg = error.localizedFailureReason;
        // Handle error.
        // Payment not successful.

    } else {
      /*  Handle success
          Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits and transactionRef.
          Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
      */
    }
}];
```

### <a id='PayWithWalletWithUi'></a>Pay With Wallet

* To allow for Payment with Wallet only
* Create a Pay UIButton
* Add a target to the button that will call the below code.

Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
let yourClientId = "IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276"
let yourClientSecret = "Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A="
let theCustomerId = "" // This should be a value that identifies your customer uniquely e.g email or phone number etc
let paymentDescription = "Payment for goods"
let theAmount = "200"

let payWithWallet = PayWithWallet(clientId: yourClientId, clientSecret: yourClientSecret,
                        customerId: theCustomerId, description: paymentDescription,
                        amount: theAmount, currency: "NGN")
let vc = payWithWallet.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
    guard error == nil else {
        // let errMsg = (error?.localizedDescription)!
        // Handle error
        // Payment not successful.
        
        return
    }
    
    guard let response = purchaseResponse else {
        //let failureMsg = (error?.localizedFailureReason)!
        // Handle error
        // Payment not successful.
        
        return
    }
    /*  Handle success
        Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits, otpTransactionIdentifier and transactionRef.
        Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
     */
})
```

*Objective C*
```Objective-C
NSString *yourClientId = @"IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276";
NSString *yourClientSecret = @"Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=";

NSString *theCustomerId = @"9689808900";     // This should be a value that identifies your customer uniquely e.g email or phone number etc
NSString *paymentDescription = @"Payment for goods";
NSString *theAmount = @"200";
NSString *theCurrency = @"NGN";

PayWithWallet *pww = [[PayWithWallet alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId
                                                   description: paymentDescription amount: theAmount currency: theCurrency];
UIViewController *vc = [pww start:^(PurchaseResponse *purchaseResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        // Handle error
        // Payment not successful.

    } else if(purchaseResponse == nil) {
        NSString *failureMsg = error.localizedFailureReason;
        // Handle error
        // Payment not successful.

    } else {
        /*  Handle success
          Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits, otpTransactionIdentifier and transactionRef.
          Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
        */
    }
}];
```

### <a id='ValidateCardWithUi'></a>Validate Card

Validate card is used to check if a card is a valid card. It returns the card balance and token.

* To validate a card, use the below code.

Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
let yourClientId = "IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276"
let yourClientSecret = "Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A="
let theCustomerId = "" // This should be a value that identifies your customer uniquely e.g email or phone number etc

let validateCard = ValidateCard(clientId: yourClientId, clientSecret: yourClientSecret,
                       customerId: theCustomerId)
let vc = validateCard.start({(validateCardResponse: ValidateCardResponse?, error: NSError?) in
    guard error == nil else {
        //let errMsg = (error?.localizedDescription)!
        // Handle error.
        // Card validation not successful
        
        return
    }
    
    guard let response = validateCardResponse else {
        //let failureMsg = (error?.localizedFailureReason)!
        // Handle error.
        // Card validation not successful
        
        return
    }
    /*  Handle success.
        Card validation successful. The response object contains fields token, tokenExpiryDate, panLast4Digits and transactionRef.
        Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
    */
})
```

*Objective C*
```Objective-C
NSString *yourClientId = @"IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276";
NSString *yourClientSecret = @"Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=";
NSString *theCustomerId = @"9689808900";     // This should be a value that identifies your customer uniquely e.g email or phone number etc

ValidateCard *validateCard = [[ValidateCard alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId];

UIViewController *vc = [validateCard start:^(ValidateCardResponse *validateResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        // Handle error.
        // Card validation not successful

    } else if(validateResponse == nil) {
        NSString *failureMsg = error.localizedFailureReason;
        // Handle error.
        // Card validation not successful

    } else {
      /*  Handle success.
          Card validation successful. The response object contains fields token, tokenExpiryDate, panLast4Digits and transactionRef.
          Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
      */
    }
}];
```

### <a id='PayWithTokenWithUi'></a>Pay with Token

* To allow for Payment with Token only
* Create a Pay UIButton
* Add a target to the button that will call the below code.

Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
let yourClientId = "IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276"
let yourClientSecret = "Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A="
let theCustomerId = "" // This should be a value that identifies your customer uniquely e.g email or phone number etc
let paymentDescription = "Payment for goods"
let theAmount = "200"
let theToken = ""       //This should be a valid token value that was stored after a previously successful payment
let theCardType = ""   //This should be a valid card type e.g mastercard, verve, visa etc

let payWithToken = PayWithToken(clientId: yourClientId, clientSecret: yourClientSecret,
                       customerId: theCustomerId, description: paymentDescription,
                       amount: theAmount, token: theToken, currency: "NGN",
                       expiryDate: "2004", cardType: theCardType, last4Digits: "7499")
let vc = payWithToken.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
    guard error == nil else {
        //let errMsg = (error?.localizedDescription)!
        // Handle error
        // Payment not successful.
        
        return
    }
    
    guard let response = purchaseResponse else {
        //let failureMsg = (error?.localizedFailureReason)!
        // Handle error
        // Payment not successful.
        
        return
    }
    /*  Handle success
        Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits and transactionRef.
        Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
    */
})
```

*Objective C*
```Objective-C
NSString *yourClientId = @"IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276";
NSString *yourClientSecret = @"Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=";
NSString *theCustomerId = @"9689808900";     // This should be a value that identifies your customer uniquely e.g email or phone number etc
NSString *paymentDescription = @"Payment for goods";
NSString *theAmount = @"200";
NSString *theCurrency = @"NGN";

NSString *theToken = @"5060990580000217499"; //This should be a valid token value that was stored after a previously successful payment
NSString *theCardType = @"verve";            //This should be a valid card type e.g mastercard, verve, visa etc

NSString *theExpiryDate = @"2004";
NSString *panLast4Digits = @"7499";

PayWithToken *pwt = [[PayWithToken alloc] initWithClientId:yourClientId clientSecret:yourClientSecret customerId:theCustomerId
                                               description: paymentDescription amount: theAmount token: theToken
                                                  currency: theCurrency expiryDate: theExpiryDate cardType: theCardType last4Digits: panLast4Digits];
UIViewController *vc = [pwt start:^(PurchaseResponse *purchaseResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        // Handle error
        // Payment not successful.

    } else if(purchaseResponse == nil) {
        NSString *failureMsg = error.localizedFailureReason;
        // Handle error
        // Payment not successful.
        
    } else {
      /*  Handle success
          Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits and transactionRef.
          Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
      */
    }
}];
```


## <a id='UsingSDKWithoutUi'></a>Using the SDK without UI (In PCI-DSS Scope: Yes)

### <a id='PayWithCardOrTokenWithoutUi'></a>Pay with Card / Token

To allow for Payment with Card or Token
* Create a UI to collect amount and card details
* Create a Pay UIButton
* Add a target to the button that will call the below code.

Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
let sdk = PaymentSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")

let customerId = "1407002510"                               // Optional email, mobile number, BVN etc to uniquely identify the customer.
let amount = "100"                                          // Amount in Naira
let pan = "5060990580000217499"                             // Card Pan or Token
let pin = "1111"                                            // Optional Card PIN for card payment
let expiryDate = "2004"                                     // Card or Token expiry date in YYMM format
let cvv2 = ""
let transactionRef = Payment.randomStringWithLength(12)     // Generate a unique transaction reference.
let requestorId = "12345678901"                             // Requestor Identifier

let request = PurchaseRequest(customerId: customerId, amount: amount, pan: pan, pin: pin, expiryDate: expiryDate, cvv2: cvv2, transactionRef: transactionRef, requestorId: "12345678901")

sdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: NSError?) in
    guard error == nil else {
        //handle error
        return
    }

    guard let response = purchaseResponse else {
        //handle error
        return
    }
    guard let responseCode = response.responseCode else {
        // OTP not required, payment successful. A token for the card details is returned in the response   
        return
    }
    self.purchaseResponse = response
    
    // At this point, further authorization is required depending on the value of responseCode
    // Please see below: Authorize PayWithCard
})
```

*Objective C*
```Objective-C
NSString *yourClientId = @"IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E";
NSString *yourClientSecret = @"SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=";

NSString *theCustomerId = @"9689808900"; // This should be a value that identifies your customer uniquely e.g email or phone number etc
NSString *theAmount = @"200";

NSString *thePan = @"5060990580000217499";
NSString *theCvv = @"111";
NSString *thePin = @"1111";
NSString *theExpiryDate = @"2004";
NSString *theRequestorId = @"12345678901";

PaymentSDK *sdk = [[PaymentSDK alloc] initWithClientId:yourClientId clientSecret:yourClientSecret];

PurchaseRequest *request = [[PurchaseRequest alloc] initWithCustomerId:theCustomerId amount:theAmount pan: thePan
                                                                   pin: thePin expiryDate: theExpiryDate cvv2: theCvv
                                                        transactionRef: [Payment randomStringWithLength: 12] currency: @"NGN" requestorId: theRequestorId];

[sdk purchase:request completionHandler: ^(PurchaseResponse *purchaseResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        
        NSLog(@"Error: %@", errMsg);
    } else if(purchaseResponse == nil) {
        NSString *errMsg = error.localizedFailureReason;
        
        NSLog(@"Failure: %@", errMsg);
    } else if(purchaseResponse.responseCode == nil || [purchaseResponse.responseCode length] == 0) {
        NSLog(@"Success: %@", @"Card validation successful");
    } else {
        NSString *responseCode = validateCardResponse.responseCode;
        // At this point further authorization is required depending on the value of responseCode
        // Please see below: Authorize PayWithCard
    }
}];
```

###	<a id='PayWithWalletWithoutUi'></a>Pay with Wallet

To allow for Payment with Wallet only
- Create a UI with `UITextField`s to collect customerID, amount, CVV, PIN and to display the user's Payment Method(s). 
- Use the code below to retrieve the Payment Method(s) array

Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
//Replace with your own client id and secret
let walletSdk = WalletSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")

walletSdk.getPaymentMethods({ (response: WalletResponse?, error: NSError?) -> Void in
    guard error == nil else {
        print("error getting payment methods")
        print(error)
        return
    }
    
    guard let walletResponse = response else {
        print("error getting payment methods")
        return
    }
    if !walletResponse.paymentMethods.isEmpty{
        print(walletResponse.paymentMethods[0].cardProduct)
    }
})
```

*Objective C*
```Objective-C
NSString *yourClientId = @"IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E";
NSString *yourClientSecret = @"SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=";

WalletSDK *walletSdk = [[WalletSDK alloc] initWithClientId:yourClientId clientSecret:yourClientSecret];

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
```

* Create a Pay UIButton
* Add a target to the button that will call the below code if the user has entered the required input information.

*Swift*
```swift
let tokenOfUserSelectedPaymentMethod = "5060990580000217499"

let request = PurchaseRequest(customerId: customerId.text, amount: amount.text!, pan: tokenOfUserSelectedPaymentMethod,
                                          pin: pin.text!, cvv2: cvv2Field.text!,
                                          transactionRef: Payment.randomStringWithLength(12), requestorId: yourRequestorId)
            
walletSdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: NSError?) in
    guard error == nil else {
        // let errMsg = (error?.localizedDescription)!
        // Handle error
        return
    }
    
    guard let response = purchaseResponse else {
        //let failureMsg = (error?.localizedFailureReason)!
        // Handle error
        return
    }
    
    guard let otpTransactionIdentifier = response.otpTransactionIdentifier else {
        // OTP not required, payment successful.  
        return
    }
    
    //handle OTP
    //To handle OTP see below: Authorize Transaction With OTP
})
```

*Objective C*
```Objective-C
NSString *yourClientId = @"IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276";
NSString *yourClientSecret = @"Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A=";

NSString *theCustomerId = "1407002510"; // This should be a value that identifies your customer uniquely e.g email or phone number etc
NSString *theAmount = @"200";
NSString *theCurrency = @"NGN";

NSString *tokenOfUserSelectedPM = @"5060990580000217499";
NSString *theCvv = @"111";
NSString *thePin = @"1111";
NSString *theExpiryDate = @"2004";
NSString *theRequestorId = @"12345678901";

WalletSDK *walletSdk = [[WalletSDK alloc] initWithClientId:yourClientId clientSecret:yourClientSecret];

PurchaseRequest *request = [[PurchaseRequest alloc] initWithCustomerId:theCustomerId amount:theAmount pan: tokenOfUserSelectedPM
                                                                   pin: thePin expiryDate: theExpiryDate cvv2: theCvv
                                                        transactionRef: [Payment randomStringWithLength: 12] currency: theCurrency requestorId: theRequestorId];

[walletSdk purchase:request completionHandler: ^(PurchaseResponse *purchaseResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        
        NSLog(@"Error: %@", errMsg);
    } else if(purchaseResponse == nil) {
        NSString *errMsg = error.localizedFailureReason;
        
        NSLog(@"Failure: %@", errMsg);
    } else {
      if (purchaseResponse.otpTransactionIdentifier != nil) {
        //To handle OTP see below: Authorize PayWithWallet using OTP
      } else {
        // OTP not required, payment successful.  
        NSLog(@"Purchase success response: %@", purchaseResponse.message);
      }
    }
}];
```


### <a id='ValidateCardWithoutUi'></a>Validate Card and Get Token
* To check if a card is valid and get a token
* Create a UI to collect card details
* Create a Validate/Add Card button
* In the onClick listener of the Validate/Add Card button, use this code.

Note: Supply your Client Id and Client Secret you got after registering as a Merchant

*Swift*
```swift
let request = ValidateCardRequest(customerId: customerIdLabel.text, pan: pan, pin: pinTextField.text!, expiryDate: expiry, cvv2: cvvTextField.text!, transactionRef: Payment.randomStringWithLength(12), requestorId: "12345678901")

sdk!.validateCard(request, completionHandler:{(validateCardResponse: ValidateCardResponse?, error: NSError?) in
    guard error == nil else {
        // let errMsg = (error?.localizedDescription)!
        // Handle error
        return
    }
    guard let response = validateCardResponse else {
        //let failureMsg = (error?.localizedFailureReason)!
        // Handle error
        return
    }
    guard let responseCode = response.responseCode else {
        // Further authorization not required, card validation successful. 
        return
    }
    // At this point, further authorization is required depending on the value of responseCode
    // Please see below: Authorize Card Validation
})
```

*Objective C*
```Objective-C
NSString *clientId = @"IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E";
NSString *clientSecret = @"SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=";

NSString *customerId = @"9689808900"; // This should be a value that identifies your customer uniquely e.g email or phone number etc

NSString *pan = @"5060990580000217499";
NSString *cvv = @"111";
NSString *pin = @"1111";
NSString *expiryDate = @"2004";
NSString *requestorId = @"12345678901";

PaymentSDK *paymentSdk = [[PaymentSDK alloc] initWithClientId: clientId clientSecret: clientSecret];
[paymentSdk validateCard:request completionHandler: ^(ValidateCardResponse *validateCardResponse, NSError *error) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [activityIndicator stopAnimating];
    
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        NSLog(@"Error: %@", errMsg);
    } else if(validateCardResponse == nil) {
        NSString *errMsg = error.localizedFailureReason;
        NSLog(@"Failure: %@", errMsg);
    } else if(validateCardResponse.responseCode == nil || [validateCardResponse.responseCode length] == 0) {
        NSLog(@"Success: %@", @"Card validation successful");
    } else {
        NSString *responseCode = validateCardResponse.responseCode;
        // At this point further authorization is required depending on the value of responseCode
        // Please see below: Authorize Card Validation
    }
}];
```


### <a id='AuthorizePayWithCardWithoutUi'></a>Authorize PayWithCard

Import PaymentSDK and use the following code snippet

*Swift*
```swift
if responseCode == PaymentSDK.SAFE_TOKEN_RESPONSE_CODE {
    let otpReq = AuthorizePurchaseRequest()
    otpReq.paymentId = purchaseResponse!.paymentId!          // Set the payment identifier for the request
    otpReq.otp = "123456"                                    // Accept OTP from user
    otpReq.authData = request.authData                       // Set the request Auth Data
  
    let paymentSdk = PaymentSDK(clientId: clientId, clientSecret: clientSecret)
    paymentSdk.authorizePurchase(otpReq, completionHandler: {(AuthorizePurchaseResponse: authorizePurchaseResponse?, error: NSError?) in
        guard error == nil else {
            // Handle and notify user of error
            return
        }
        guard let authPurchaseResponse = authorizePurchaseResponse else {
            // Handle and notify user of error
            return
        }
        //Handle and notify user of successful transaction
    })
} else if (responseCode == PaymentSDK.CARDINAL_RESPONSE_CODE) {
    let authorizeHandler = {() -> Void in
        //self.navigationController?.popViewControllerAnimated(true)        // To dismiss the authorize webview before proceeding
      
        let authorizeRequest = AuthorizePurchaseRequest()
        authorizeRequest.authData = request.authData                        // Set the authData from the request object used to make the purchase
        authorizeRequest.paymentId = purchaseResponse!.paymentId!           // Set the paymentId from the purchaseResponse
        authorizeRequest.transactionId = purchaseResponse!.transactionId    // Set the transactionId from the purchaseResponse
        authorizeRequest.eciFlag = purchaseResponse!.eciFlag!               // Set the eciFlag from the purchaseResponse
      
        let paymentSdk = PaymentSDK(clientId: clientId, clientSecret: clientSecret)
        paymentSdk.authorizePurchase(authorizeRequest, completionHandler:{(purchaseResponse: AuthorizePurchaseResponse?, error: NSError?) in
            guard error == nil else {
                // Handle and notify user of error
                return
            }
            guard purchaseResponse != nil else {
                // Handle and notify user of error
                return
            }
            //Handle and notify user of successful transaction
        })
    }
    let authorizePurchaseVc = AuthorizeViewController(response: purchaseResponse!, authorizeHandler: authorizeHandler)
    self.navigationController?.pushViewController(authorizePurchaseVc, animated: true)
}
```

*Objective C*
```Objective-C
if (responseCode == PaymentSDK.SAFE_TOKEN_RESPONSE_CODE) {
    AuthorizePurchaseRequest *otpReq = [[AuthorizePurchaseRequest alloc] init];
    otpReq.paymentId = purchaseResponse.paymentId;                          // Set the paymentId from the purchaseResponse
    otpReq.otp = @"123456";                                                 // Accept OTP from user
    otpReq.authData = request.authData;                                     // Set the authData from the request object used to make the purchase
    
    PaymentSDK *paymentSdk = [[PaymentSDK alloc] initWithClientId: clientId clientSecret: clientSecret];
    [paymentSdk authorizePurchase:otpReq completionHandler: ^(AuthorizePurchaseResponse *authorizePurchaseResponse, NSError *error) {
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            NSLog(@"Error: %@", errMsg);
        } else if(authorizePurchaseResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;
            NSLog(@"Failure: %@", errMsg);
        } else {
            NSLog(@"Purchase: %@", @"successful.");
        }
    }];
} else if (responseCode == PaymentSDK.CARDINAL_RESPONSE_CODE) {
    AuthorizeViewController *authorizePurchaseVc = [[AuthorizeViewController alloc] initWithResponse:purchaseResponse authorizeHandler:^() {
        //[self.navigationController popViewControllerAnimated:YES];                       // To dismiss the authorize webview before proceeding
        
        AuthorizePurchaseRequest *authorizeRequest = [[AuthorizePurchaseRequest alloc] init];
        authorizeRequest.authData = request.authData;                                      // Set the authData from the request object used to make the purchase
        authorizeRequest.paymentId = purchaseResponse.paymentId;                           // Set the paymentId from the purchaseResponse
        authorizeRequest.transactionId = purchaseResponse.transactionId;                   // Set the transactionId from the purchaseResponse
        authorizeRequest.eciFlag = purchaseResponse.eciFlag;                               // Set the eciFlag from the purchaseResponse
        
        PaymentSDK *paymentSdk = [[PaymentSDK alloc] initWithClientId: clientId clientSecret: clientSecret];
        [paymentSdk authorizePurchase:authorizeRequest completionHandler: ^(AuthorizePurchaseResponse *authorizePurchaseResponse, NSError *error) {
            if(error != nil) {
                NSString *errMsg = error.localizedDescription;
                NSLog(@"Error: %@", errMsg);
            } else if(authorizePurchaseResponse == nil) {
                NSString *errMsg = error.localizedFailureReason;
                NSLog(@"Failure: %@", errMsg);
            } else {
                NSLog(@"Authorize purchase: %@", @"successful.");
            }
        }];
    }];
    [self.navigationController pushViewController:authorizePurchaseVc animated:YES];
}
```

### <a id='AuthorizeCardValidationWithoutUi'></a>Authorize Card Validation

*Swift*
```swift
if responseCode == PaymentSDK.SAFE_TOKEN_RESPONSE_CODE {
    let otpReq = AuthorizeCardRequest()
    otpReq.transactionRef = validateCardResponse!.transactionRef               // Set the transaction reference using the transactionRef gotten from the validateCardResponse
    otpReq.otp = "123456"                                                      // Accept OTP from user
    otpReq.authData = request.authData                                         // Set the authData from the request object used to initiate the card validation
    
    let sdk = PaymentSDK(clientId: clientId, clientSecret: clientSecret)
    sdk.authorizeCard(otpReq, completionHandler: {(authorizeCardResponse: AuthorizeCardResponse?, error: NSError?) in        
        guard error == nil else {
            // let errMsg = (error?.localizedDescription)!
            // Handle and notify user of error
            return
        }
        guard let authCardResponse = authorizeCardResponse else {
            // let failureMsg = (error?.localizedFailureReason)!
            // Handle and notify user of error
            return
        }
        //Handle and notify user of successful card validation
    })
} else if (responseCode == PaymentSDK.CARDINAL_RESPONSE_CODE) {
    let authorizeHandler = {() -> Void in
        //self.navigationController?.popViewControllerAnimated(true)                      // To dismiss the authorize webview before proceeding
        
        let authorizeCardinalRequest = AuthorizeCardRequest()
        authorizeCardinalRequest.authData = request.authData                              // Set the authData from the request object used to initiate the card validation
        authorizeCardinalRequest.transactionId = validateCardResponse!.transactionId      // Set the transactionId from the validateCardResponse
        authorizeCardinalRequest.eciFlag = validateCardResponse!.eciFlag!                 // Set the eciFlag from the validateCardResponse
        authorizeCardinalRequest.transactionRef = validateCardResponse!.transactionRef    // Set the transaction reference from the validateCardResponse
        
        let sdk = PaymentSDK(clientId: self.clientId!, clientSecret: self.clientSecret!)
        sdk.authorizeCard(authorizeCardinalRequest, completionHandler:{(validateCardResponse: AuthorizeCardResponse?, error: NSError?) in      
            guard error == nil else {
                self.completionHandler!(nil, error)
                return
            }
            guard validateCardResponse != nil else {
                self.completionHandler!(nil, error)
                return
            }
            self.completionHandler!(validateCardResponse!, error)
        })
    }
    let authorizeCardVc = AuthorizeViewController(response: self.validateCardResponse!, authorizeHandler: authorizeHandler)
    self.navigationController?.pushViewController(authorizeCardVc, animated: true)
}
```


*Objective C*
```Objective-C
if (responseCode == PaymentSDK.SAFE_TOKEN_RESPONSE_CODE) {
    AuthorizeCardRequest *otpReq = [[AuthorizeCardRequest alloc] init];
    otpReq.transactionRef = validateCardResponse.transactionRef;
    otpReq.otp = "123456";
    otpReq.authData = request.authData;
    
    PaymentSDK *paymentSdk = [[PaymentSDK alloc] initWithClientId: clientId clientSecret: clientSecret];
    [paymentSdk authorizeCard:otpReq completionHandler: ^(AuthorizeCardResponse *authorizeCardResponse, NSError *error) {
        if(error != nil) {
            NSString *errMsg = error.localizedDescription;
            NSLog(@"Error: %@", errMsg);
        } else if(authorizeCardResponse == nil) {
            NSString *errMsg = error.localizedFailureReason;
            NSLog(@"Failure: %@", errMsg);
        } else {
            NSLog(@"Authorize Card: %@", @"Authorize Card successful.");
        }
    }];
} else if (responseCode == PaymentSDK.CARDINAL_RESPONSE_CODE) {
    AuthorizeViewController *authorizeCardVc = [[AuthorizeViewController alloc] initWithResponse:validateCardResponse authorizeHandler:^() {
        //[self.navigationController popViewControllerAnimated:YES];                       // To dismiss the authorize webview before proceeding
        
        AuthorizeCardRequest *authorizeRequest = [[AuthorizeCardRequest alloc] init];
        authorizeRequest.authData = request.authData;                                      // Set the authData from the initial request
        authorizeRequest.transactionId = validateCardResponse.transactionId;               // Set the transactionId from the response
        authorizeRequest.eciFlag = validateCardResponse.eciFlag;                           // Set the eciFlag from the response 
        authorizeRequest.transactionRef = validateCardResponse.transactionRef;             // Set the transaction reference from the request
        
        PaymentSDK *paymentSdk = [[PaymentSDK alloc] initWithClientId: clientId clientSecret: clientSecret];
        [paymentSdk authorizeCard:authorizeRequest completionHandler: ^(AuthorizeCardResponse *authorizeCardResponse, NSError *error) {
            if(error != nil) {
                NSString *errMsg = error.localizedDescription;
                NSLog(@"Error: %@", errMsg);
            } else if(authorizeCardResponse == nil) {
                NSString *errMsg = error.localizedFailureReason;
                NSLog(@"Failure: %@", errMsg);
            } else {
                NSLog(@"Authorize Card Validation: %@", @"successful.");
            }
        }];
    }];
    [self.navigationController pushViewController:authorizeCardVc animated:YES];
}
```

###	<a id='AuthorizeWalletPurchaseWithoutUi'></a>Authorize PayWithWallet using OTP

*Swift*
```swift
//Replace with your own client id and secret
let sdk = PaymentSDK(clientId: "IKIAD6F6ABB40ABE2CD1030E4F87C132CFD5EB3F6D28", clientSecret: "8jPfKyXs9Pzll2BRDIj3O3N7Ljraz39IVrfBYNIsfDk=")

let otpTransactionId = "5060990580000217499"
let userEnteredOtpValue = "54343"
let otpTransactionRef = "1234543211"

let otpReq = AuthorizeOtpRequest(otpTransactionId: theOtpTransactionId, otp: userEnteredOtpValue, transactionRef: otpTransactionRef)
 
sdk.authorizeOtp(otpReq, completionHandler: {(authorizeOtpResponse: AuthorizeOtpResponse?, error: NSError?) in
    guard error == nil else {
        // handle error
        return
    }
     
    guard let otpResponse = authorizeOtpResponse else {
        //handle error
        return
    }
    //OTP successful
})
```

*Objective C*
```Objective-C
//Replace with your own client id and secret
PaymentSDK *sdk = [[PaymentSDK alloc] initWithClientId:yourClientId clientSecret:yourClientSecret];

NSString *otpTransactionId = @"5060990580000217499";
NSString *userEnteredOtpValue = @"54343";
NSString *otpTransactionRef = @"1234543211";

AuthorizeOtpRequest *request = [[AuthorizeOtpRequest alloc] initWithOtpTransactionIdentifier:otpTransactionId otp: userEnteredOtpValue transactionRef: otpTransactionRef];

[sdk authorizeOtp:request completionHandler: ^(AuthorizeOtpResponse *authorizeOtpResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        
        NSLog(@"Error: %@", errMsg);
    } else if(authorizeOtpResponse == nil) {
        NSString *errMsg = error.localizedFailureReason;
        
        NSLog(@"Failure: %@", errMsg);
    } else {
        NSLog(@"Authorize Otp: %@", @"Authorize otp successful.");
    }
}];
```

###<a id='GetPaymentStatusWithoutUi'></a>Get Payment Status

To check the status of a payment made, use the code below

*Swift*
```swift
//Replace with your own client id and secret
let sdk = PaymentSDK(clientId: "IKIAD6F6ABB40ABE2CD1030E4F87C132CFD5EB3F6D28", clientSecret: "8jPfKyXs9Pzll2BRDIj3O3N7Ljraz39IVrfBYNIsfDk=")

let transactionRef = "583774306964"
let amount = "100"

sdk.getPaymentStatus(transactionRef, amount: amount, completionHandler: {(paymentStatusResponse: PaymentStatusResponse?, error: NSError?) in
    guard error == nil else {
        print("error getting payment status")
        print(error)
        return
    }
    
    guard let statusResponse = paymentStatusResponse else {
        print("error getting payment status")
        return
    }
    print(statusResponse.message)        
})
```

*Objective C*
```Objective-C
//Replace with your own client id and secret
PaymentSDK *sdk = [[PaymentSDK alloc] initWithClientId:@"IKIAD6F6ABB40ABE2CD1030E4F87C132CFD5EB3F6D28" clientSecret:@"8jPfKyXs9Pzll2BRDIj3O3N7Ljraz39IVrfBYNIsfDk="];

NSString *transactionRef = @"583774306964";
NSString *amount = @"100";

[sdk getPaymentStatus:transactionRef amount: amount completionHandler: ^(PaymentStatusResponse *paymentStatusResponse, NSError *error) {
    if(error != nil) {
        NSString *errMsg = error.localizedDescription;
        
        NSLog(@"Error getting payment status: %@", errMsg);
    } else if(paymentStatusResponse == nil) {
        NSString *errMsg = error.localizedFailureReason;
        
        NSLog(@"Failed to get payment status: %@", errMsg);
    } else {
        NSLog(@"Payment status: %@", paymentStatusResponse.message);
    }
}];
```

