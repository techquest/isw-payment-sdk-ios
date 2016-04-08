##Payment SDK for ​iOS

Interswitch payment SDK allows you to accept payments from customers within your mobile application.
The first step to ​using the ​iOS SDK is to register as a merchant. This is described [here] (http://merchantxuat.interswitchng.com/paymentgateway/getting-started/overview/sign-up-as-a-merchant)

###Before you begin


* Install **Xcode 7.0.1** or later 

* Install the latest **CocoaPods**

    ```terminal
	$ sudo gem install cocoapods
	```

* (Optional) Try the PaymentDemoApp project, which is in the SampleCode directory in the SDK.
* **Note: Only iOS 8 and later are supported by the SDK**
 
###Step 1. Download the SDK

Download the SDK from link below and unzip the archive to **~/Documents/PaymentSDK**.

https://github.com/techquest/isw-payment-sdk-ios/releases


###Step 2. Create a Swift Payment App

Create a payment app using **Xcode** with Swift as the language.

Alternatively, you can also create an Objective-C project.

If you haven’t registered your app on DevConsole register the app and get your Client ID and Client Secret


###Step 3 Add the SDK dependencies to your Xcode project

* Close the **Xcode** project

* Open Terminal and navigate to the directory that contains your project by using cd command
 
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
	```terminal
    $ pod install
	```


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

If you experience an error similar to the below

```
[MT] DVTAssertions: ASSERTION FAILURE in /Library/Caches/com.apple.xbs/Sources/IDEFrameworks/IDEFrameworks-8227/IDEFoundation/Initialization/IDEInitialization.m:590
Details: Assertion failed: _initializationCompletedSuccessfully
Function: BOOL IDEIsInitializedForUserInteraction()
Thread: {number = 1, name = main}
Hints: None
Backtrace:
0 0x000000010462aa5c -DVTAssertionHandler handleFailureInFunction:fileName:lineNumber:assertionSignature:messageFormat:arguments:
1 0x000000010462a1e9 _DVTAssertionHandler (in DVTFoundation)
2 0x000000010462a455 _DVTAssertionFailureHandler (in DVTFoundation)
3 0x000000010462a3b7 _DVTAssertionFailureHandler (in DVTFoundation)
4 0x0000000107191f5c IDEIsInitializedForUserInteraction (in IDEFoundation)
5 0x0000000109da8eb9 +PBXProject projectWithFile:errorHandler:readOnly:
6 0x0000000109daaa3e +PBXProject projectWithFile:errorHandler:
7 0x00007fff8bc68f44 ffi_call_unix64 (in libffi.dylib)
Abort trap: 6
```

You may have to
```
run 'gem list --local | grep cocoapods' to find all cocoa pods installed on machine
'gem uninstall' each pod returned by step1
'[sudo] gem uninstall cocoapods'
'[sudo] gem install cocoapods'
Now try to run: pod install 
```

* Open `YourProject.xcworkspace`

###Step 4. Add SDK to your Xcode Project

Open **~/Documents/PaymentSDK**
Drag the ​ **PaymentSDK.framework** to Embedded Binaries section of your app target setting. Make sure ‘Copy items if needed’ is checked in the ‘Choose options for adding these files’

###USING THE SDK IN SANDBOX MODE

The procedure to use the SDK on sandbox mode is just as easy,

* Use sandbox client id and secret got from the developer console after signup(usually you have to wait for 5 minutes for you to see the sandbox details) 
* Override the api base as follows
```swift
    Passport.overrideApiBase("https://sandbox.interswitchng.com/passport"); 
    Payment.overrideApiBase("https://sandbox.interswitchng.com");
```
* Follow the remaining steps in the documentation


###Next Steps

Now that you created and configured your Xcode project, you can add your choice of Payment SDK features to your app:

1.	Make Payment with Card Details
2.	Make Payment with Wallet Item
3.	Authorize OTP
4.	Get Payment Status

* Make Payment with Card / Token

Import PaymentSDK and use the following code snippet

```swift
//Replace with your own client id and secret
let sdk = PaymentSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")
//You can pay with Pan or Token 
//Optional card pin for card payment
//Card or Token expiry
let request = PurchaseRequest(customerId: "1407002510", amount: "100", pan: "5060990580000217499", pin: "1111", expiryDate: "2004", cvv2: "", transactionRef: Payment.randomStringWithLength(12), requestorId: "12345678901")
        l
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
```



*	Make Payment with Wallet Item    
    * To load Verve wallet, add this code 
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
    

*	Authorize OTP

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
* Get Payment Status
    * use the code below to check payment status
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