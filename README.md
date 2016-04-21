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
    * [Authorize Transaction With OTP](#AuthorizeOtpWithoutUi)
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
```swift
Passport.overrideApiBase("https://sandbox.interswitchng.com/passport"); 
Payment.overrideApiBase("https://sandbox.interswitchng.com");
```
* Make sure you include the following import statement
```swift
import PaymentSDK
```
* Follow the remaining steps in the documentation



## <a id='UsingSDKWithUi'></a>Using the SDK with UI (In PCI-DSS Scope: No )
Now that you created and configured your Xcode project, you can add your choice of Payment SDK features to your app:

-  [Pay with Card](#PayWithCardWithUi)
-  [Pay With Wallet](#PayWithWalletWithUi)
-  [Validate Card](#ValidateCardWithUi)
-  [Pay with Token](#PayWithTokenWithUi)

### <a id='PayWithCardWithUi'></a>Pay with Card
    
* To allow for Payment with Card only
* Create a Pay UIButton
* Add a target to the button that will call the below code.

  Note: Supply your Client Id and Client Secret you got after registering as a Merchant

```swift
let yourClientId = "IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276"
let yourClientSecret = "Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A="
let theCustomerId = "" // This should be a value that identifies your customer uniquely e.g email or phone number etc
let paymentDescription = "Payment for goods"
let theAmount = "200"

let payWithCard = PayWithCard(clientId: yourClientId, clientSecret: yourClientSecret,
                      customerId: theCustomerId, description: paymentDescription,
                      amount: theAmount, currency: "NGN")
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


### <a id='PayWithWalletWithUi'></a>Pay With Wallet

* To allow for Payment with Wallet only
* Create a Pay UIButton
* Add a target to the button that will call the below code.

  Note: Supply your Client Id and Client Secret you got after registering as a Merchant

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
        Payment successful. The response object contains fields transactionIdentifier, message, amount, token, tokenExpiryDate, panLast4Digits, otpTransactionIdentifier and transactionRef.
        Save the token, tokenExpiryDate and panLast4Digits in order to pay with the token in the future.
     */
})
```


### <a id='ValidateCardWithUi'></a>Validate Card

Validate card is used to check if a card is a valid card. It returns the card balance and token.

* To validate a card, use the below code.

  Note: Supply your Client Id and Client Secret you got after registering as a Merchant

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


### <a id='PayWithTokenWithUi'></a>Pay with Token

* To allow for Payment with Token only
* Create a Pay UIButton
* Add a target to the button that will call the below code.

  Note: Supply your Client Id and Client Secret you got after registering as a Merchant

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



## <a id='UsingSDKWithoutUi'></a>Using the SDK without UI (In PCI-DSS Scope: Yes)

### <a id='PayWithCardOrTokenWithoutUi'></a>Pay with Card / Token

Import PaymentSDK and use the following code snippet

```swift
//Replace with your own client id and secret
let sdk = PaymentSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")

//You can pay with Pan or Token 
//Optional card pin for card payment
//Card or Token expiry
let request = PurchaseRequest(customerId: "1407002510", amount: "100", pan: "5060990580000217499", pin: "1111", expiryDate: "2004", cvv2: "", transactionRef: Payment.randomStringWithLength(12), requestorId: "12345678901")

sdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: NSError?) in
     
	guard error == nil else {
	    //handle error
	    return
	}

	guard let response = purchaseResponse else {
	    //handle error
	    return
	}
	 
	guard let otpId = response.otpTransactionIdentifier else {
	    // OTP not required, payment successful. A token for the card details is returned in the response       
	    return
	}
 
	//OTP required, ask user for OTP and authorize OTP
	let otpReq = AuthorizeOtpRequest(otpTransactionIdentifier: otpId, otp: "123456", transactionRef: Payment.randomStringWithLength(12))
	 
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
})
```


###	<a id='PayWithWalletWithoutUi'></a>Pay with Wallet

To load Verve wallet, add this code 

```swift
//Replace with your own client id and secret
let sdk = WalletSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")
            sdk.getPaymentMethods({ (response: WalletResponse?, error: NSError?) -> Void in
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


###	<a id='AuthorizeOtpWithoutUi'></a>Authorize Transaction With OTP

Import PaymentSDK and use the following code snippet

```swift
let otpReq = AuthorizeOtpRequest(otpTransactionIdentifier: otpId, otp: "123456", transactionRef: Payment.randomStringWithLength(12))
 
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
###	<a id='GetPaymentStatusWithoutUi'></a>Get Payment Status

Use the code below to check payment status

```swift
//Replace with your own client id and secret
let sdk = PaymentSDK(clientId: "IKIAD6F6ABB40ABE2CD1030E4F87C132CFD5EB3F6D28", clientSecret: "8jPfKyXs9Pzll2BRDIj3O3N7Ljraz39IVrfBYNIsfDk=")

sdk.getPaymentStatus("441469400958", amount: "100", completionHandler: {(paymentStatusResponse: PaymentStatusResponse?, error: NSError?) in
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
