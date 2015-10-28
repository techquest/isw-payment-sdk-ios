# isw-payment-sdk-ios

##Payment SDK for ​iOS

Interswitch payment SDK allows you to accept payments from customers within your mobile application.
The first step to ​using the ​iOS SDK is to register as a merchant. This is described [here] (http://merchantxuat.interswitchng.com/paymentgateway/getting-started/overview/sign-up-as-a-merchant)

###Before you begin

**Note: Only iOS 8 and later are supported by the SDK**

Install **Xcode 7.0.1** or later 

Install the latest **CocoaPods**

    $ sudo gem install cocoapods

Try the PaymentDemoApp project, which is in the SampleCode directory in the SDK. (Optional)
 
###Step 1. Download the SDK

Download the SDK from link below and unzip the archive to ~/Documents/PaymentSDK.

https://github.com/techquest/isw-payment-sdk-ios/releases


###Step 2. Create a Swift Payment App

Create a payment app using **Xcode** with Swift as the language.

Alternatively, you can also create an Objective-C project.

If you haven’t registered your app on DevConsole register the app and get your Client ID and Client Secret


###Step 3 Add the SDK dependencies to your Xcode project

Close the **Xcode** project
Open Terminal and navigate to the directory that contains your project by using cd command
 
    $ cd ~/Path/To/Folder/Containing/YourProject


Next, enter this command

    $ pod init

This creates a Podfile for your project

Open the Podfile and replace the two commented lines with the following
 
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"
use_frameworks!
```

Add the following to your Podfile, inside the first target block:
```
pod 'CryptoSwift'
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'OpenSSL'
```

Enter the following command:

    $ pod install


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
Open `YourProject.xcworkspace`
###Step 4. Add SDK to your Xcode Project

Open **~/Documents/PaymentSDK**
Drag the ​ **PaymentSDK.framework** to Embedded Binaries section of your app target setting. Make sure ‘Copy items if needed’ is checked in the ‘Choose options for adding these files’
###Step ​5  Accepting Payments 

Import PaymentSDK and use the following code snippet
```
//Replace with your own client id and secret
let sdk = PaymentSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")
 
//Override API bases for testing
Passport.overrideApiBase("https://qa.interswitchng.com/passport")
Payment.overrideApiBase("https://qa.interswitchng.com")
 
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
    // OTP not required, payment successful          
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