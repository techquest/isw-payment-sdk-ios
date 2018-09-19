## Payment SDK for ​iOS Migration to Swift 3 Guide

The latest release for the Payment SDK introduces API-breaking changes.

This guide is provided in order to ease the transition of existing applications using the earlier versions of Swift ( < 3.0) to the latest APIs, as well as explain the design and structure of updated functionality.

### Outline
- [Requirements](#Requirements)
- [Benefits of Upgrading](#Benefits)
- [Before you begin](#BeforeYouBegin)
- [Using the SDK](#UsingSDK)


### <a id='Requirements'></a>Requirements
* iOS 9.0+ /macOS 10.10+
* Xcode 10.0 +
* Swift 4.2+

### <a id='Benefits'></a>Benefits of Upgrading
* **Complete Swift 3 Compatibility** includes the full adoption of the new <a href = "https://swift.org/documentation/api-design-guidelines/">API Design Guidelines</a>

### <a id='BeforeYouBegin'></a>Before you begin


* Install **Xcode 8.3.2** or later

* Install the latest **CocoaPods**

  ```terminal
  $ sudo gem install cocoapods
  ```

* (Optional) Try the PaymentDemoApp project, which is in the SampleCode directory in the SDK.
* **Note: Only iOS 9 and later are supported by the SDK**

### Step 1. Create a Swift 3 Payment App

Create a payment app using **Xcode** with Swift 3.1 as the language.

Alternatively, you can also create an Objective-C project.

If you haven’t registered your app on DevConsole register the app and get your Client ID and Client Secret


### Step 2 Update Podfile

* Close the **Xcode** project

* Open Terminal and navigate to the directory that contains your project by using the **cd** command

  ```terminal
  $ cd ~/Path/To/Folder/Containing/YourProject
  ```


* Open the Podfile and replace the two commented lines with the following

	```
	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, "9.0"
	use_frameworks!
	```

* Update the dependency versions in your Podfile, inside the first target block:

	```
	pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift.git', :tag => '0.6.9'
	pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '4.4.0'
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git', :tag => '3.1.4'
	pod 'OpenSSL-Universal', '1.0.2.10'
	```

* Enter the following command:
	​```terminal
	$ pod install
	​```

	You should see output similar to the following:

	```
	Analyzing dependencies
	Pre-downloading: `Alamofire` from `https://github.com/Alamofire/Alamofire.git`
	Pre-downloading: `SwiftyJSON` from `https://github.com/SwiftyJSON/SwiftyJSON.git`
	Downloading dependencies
	Installing Alamofire (4.4.0)
	Installing CryptoSwift (0.6.9)
	Installing OpenSSL (1.0.2.10)
	Installing SwiftyJSON (2.4.0)
	Generating Pods project
	Integrating client project

	[!] Please close any current Xcode sessions and use `YourProject.xcworkspace` for this project from now on.
	```

* Open `YourProject.xcworkspace`

### Step 3. Add SDK to your Xcode Project

Open the **~/Documents/PaymentSDK** directory

Drag the ​ **PaymentSDK.framework** file to the ``Embedded Binaries`` section of your app's **TARGETS** settings(`General` tab).

In the dialog that appears, make sure ‘Copy items if needed’ is checked in the ‘Choose options for adding these files’

## <a id='UsingSDK'></a>Using the SDK
Here is an example of using the SDK with Swift 3.

### <a id='PayWithCardOrWalletWithUi'></a>Pay with Card or Wallet


*Swift*

```swift
//Swift 2.3

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

})

//Swift 3

let vc = payWithCardOrWallet.start({(purchaseResponse: PurchaseResponse?, error: Error?) in
    guard error == nil else {
        //let errMsg = (error?.localizedDescription)!
        // Handle error.
        // Payment not successful.

        return
    }
    guard let response = purchaseResponse else {
        //let failureMsg = (error?.localizedDescription)!
        // Handle error.
        // Payment not successful.

        return
    }

})
```

There are two changes to the payment calls worth noting. The first major change worth noting on the ``NSError`` is that it has been renamed to ``Error``. This change applies to all payment APIs.

The other minor change is that in the response block, the member ``localizedFailureReason`` on the error variable has been replaced by ``localizedDescription``.