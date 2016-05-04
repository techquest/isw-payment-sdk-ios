##Cordova iOS Payment Plugin

* You'll need to have **Xcode 7.3** or later installed.

* Create the cordova project
```terminal
cordova create testapp com.develop.testapp TestApp
```

* **cd** to the cordova project

* Add cordova payment plugin
```
cordova plugin add ../cordova-payment-plugin
```

* Add ```ios``` platform. Make sure to add the platform after adding the plugin.
```terminal
cordova platform add ios
```

* In Finder, go to the **platforms/ios** directory. Open the .xcodeproj file in XCode. A dialog may appear asking: Convert to latest Swift Syntax? Click the **Cancel** button.

* In Finder, go to the ```/platforms/ios/<NameOfApp>/plugins/com.interswitchng.sdk.payment``` directory

* Drag the ​ **PaymentSDK.framework** file to the **Embedded Binaries** section of your app's **TARGETS** settings(`General` tab).

* In the dialog that appears, make sure ```Copy items if needed``` is unchecked.

* **Important**: With XCode still open, click the project to view its settings. Under the **info** tab find the **Configurations** section and change the values for ```Debug``` and ```Release``` to **None**. You can change it back once our installation are done.

The **PaymentSDK.framework** needs some [Cocoapods](https://cocoapods.org/) dependencies so we'll need to install them.

* Close Xcode. **cd** into ```platforms/ios``` directory

* Run: 
```terminal
pod init
```

* Open the Podfile created and replace its entire contents with

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "8.0"
use_frameworks!

pod 'CryptoSwift'
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'OpenSSL'
```

* Now run:
```terminal
pod install
```

* After the pods are installed successfully you can go to the directory ```platforms/ios``` and open the ```<NameOfApp>.xcworkspace``` file in XCode. You can now begin developing.


