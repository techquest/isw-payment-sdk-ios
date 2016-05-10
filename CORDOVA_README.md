## Cordova iOS Payment Plugin

Interswitch payment SDK allows you to accept payments from customers within your mobile application.

**Please Note: *The current supported currency is naira (NGN). Support for other currencies would be added later***.

The first step to ​using the plugin is to register as a merchant. This is described [here](merchantxuat.interswitchng.com)

* You'll need to have **Xcode 7.3** or later installed.

* **cd** to a directory of your choice. 

* Clone the plugin 
```
git clone https://github.com/...
```

* Create the cordova project
```terminal
cordova create testapp com.develop.testapp TestApp
```

* **cd** to the cordova project

* Add cordova payment plugin
```
cordova plugin add ../cordova-payment-plugin
```

* Add ```ios``` platform. Make sure to add the platform **after** adding the plugin.
```terminal
cordova platform add ios
```

* In ```Finder```, go to the **platforms/ios** directory. Open the .xcodeproj file in XCode. A dialog may appear asking: Convert to latest Swift Syntax? Click the **Cancel** button.

* In ```Finder```, go to the ```/platforms/ios/<NameOfApp>/plugins/com.interswitchng.sdk.payment``` directory

* Drag the ​ **PaymentSDK.framework** file from ```Finder``` to XCode's **Embedded Binaries** section for your app's **TARGETS** settings.

* In the dialog that appears, make sure ```Copy items if needed``` is unchecked.

* **Important**: With ```XCode``` still open, click the project to view its settings. Under the **info** tab find the **Configurations** section and change the values for ```Debug``` and ```Release``` to **None**. You can change it back once our setups are done.

The **PaymentSDK.framework** needs some [Cocoapods](https://cocoapods.org/) dependencies so we'll need to install them.

* Close Xcode. **cd** into ```platforms/ios``` directory

* Run: 
```terminal
pod init
```

* Open the **Podfile** created and replace ```#``` commented parts with the following.

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"
use_frameworks!
```

* Add the following to the **Podfile**, inside the first ```target``` block.

```
pod 'CryptoSwift'
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'OpenSSL'
```

* Now run:
```terminal
pod install
```

* After the pods are installed successfully you can go to the directory ```platforms/ios``` and open the ```<NameOfApp>.xcworkspace``` file in XCode. 

### <a name='SandBoxMode'></a> Using The Plugin in Sandbox Mode

During development of your app, you should use the Plugin in sandbox mode to enable testing. Different Client Id and Client Secret are provided for Production and Sandbox mode. The procedure to use the Plugin on sandbox mode is just as easy:

* Use Sandbox Client Id and Client Secret gotten from the Sandbox Tab of the Developer Console after signup (usually you have to wait up to 5 minutes after signup for you to see the Sandbox details) everywhere you are required to supply Client Id and Client Secret in the remainder of this documentation

* In your code, override the api base as follows
```javascript
    function init(){
    	var userDetails = {
    	    clientId :"IKIAF8F70479A6902D4BFF4E443EBF15D1D6CB19E232",
    	    clientSecret : "ugsmiXPXOOvks9MR7+IFHSQSdk8ZzvwQMGvd0GJva30=",
    	    paymentApi : "https://sandbox.interswitchng.com",
    	    passportApi : "https://sandbox.interswitchng.com/passport"
    	}
    	var initial = PaymentPlugin.init(userDetails);				 
    	initial.done(function(response){    			
    	    alert(response); // success response if the initialization was successful
    	});
    	initial.fail(function (response) {    			
    		alert(response); // error response if the initialization failed
    	});
    }
```

* Follow the remaining steps in the documentation.
* call the init function inside the onDeviceReady function of your cordova app
* NOTE: When going into Production mode, use the Client Id and the Client Secret got from the Production Tab of Developer Console instead.

## <a name='SDKWithUI'></a>Using the Plugin with UI (In PCI-DSS Scope: No )

### <a name='PayWithCard'>Pay with Card

* To allow for Payment with Card only
* Create a Pay button and set the payment request
*Set up payment request like this: 
```javascript
    var payRequest = {			
        amount : "100",                     // Amount in Naira
        customerId : "1234567890",          // Value to uniquely identify the customer e.g email, phone no etc
        currency : "NGN",                   // ISO Currency code
        description : "Purchase Phone"      // Description of product to purchase
    }
```
* In the onclick event of the Pay button, use this code.
```javascript
    var payWithCard = PaymentPlugin.payWithCard(payRequest);
    payWithCard.done(function(response){
        alert(response); // transaction success reponse
    });
    payWithCard.fail(function (response) {        
        alert(response); // transaction failure reponse
    });
```

### <a name='PayWithWallet'>Pay With Wallet

* To allow for Payment with Wallet only
* Create a Pay button and set the payment request
* Set up payment request like this: 
```javascript
    var payWithWalletRequest = {			
        amount : "100",                     // Amount in Naira
        customerId : "1234567890",          // Value to uniquely identify the customer e.g email, phone no etc
        description : "Purchase Phone"      // Description of product to purchase
    }
```
* In the onclick event of the Pay button, use this code.
```javascript
    var payWithWallet = PaymentPlugin.payWithWallet(payWithWalletRequest);				 
    payWithWallet.done(function(response){				 
        alert(response); // transaction success reponse
    });
    payWithWallet.fail(function (response) {        			
        alert(response); // transaction failure reponse
    });
```

### <a name='ValidateCard'></a>Validate Card

* Validate card is used to check if a card is a valid card, it returns the card balance and token
* Set up payment request like this: 
```javascript
    var validateCardRequest = {
        customerId : "1234567890"          // Value to uniquely identify the customer e.g email, phone no etc
    }
```
* To call validate card, use this code.
```javascript
    var validateCard = PaymentPlugin.validatePaymentCard(validateCardRequest);
    validateCard.done(function(response){         
        alert(response); // transaction success reponse
    });
    validateCard.fail(function (response) {        
        alert(response); // transaction failure reponse
    });
```

### <a name='PayWithToken'></a> Pay with Token

* To allow for Payment with Token only
* Create a Pay button
* Set up payment request like this: 
```javascript
    var payWithTokenRequest = {
        pan : "5060990580000217499",         // Token
        amount : "100",                      // Amount in Naira
        currency : "NGN",                    // ISO Currency code		
        cardtype : "Verve",                  // Card Type	
        expiryDate : "2004",                 // Card or Token expiry date in YYMM format
        customerId : "1234567890",	         // Optional email, mobile no, BVN etc to uniquely identify the customer.	
        panLast4Digits : "7499",		     // Last 4digit of the pan card
        description : "Pay for gown"         // Description of product to purchase
    }
```
* In the onclick event of the Pay button, use this code.
```javascript
    var payment = PaymentPlugin.payWithToken(payWithTokenRequest);	
	payment.done(function(response){
		alert(response); // transaction success reponse
	});
	payment.fail(function (response) {		
		alert(response); // transaction failure reponse
	});
```

