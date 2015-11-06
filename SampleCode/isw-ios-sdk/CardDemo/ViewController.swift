//
//  ViewController.swift
//  CardDemo
//
//  Created by Adesegun Adeyemo on 06/10/2015.
//  Copyright © 2015 Interswitch Limited. All rights reserved.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController, UIAlertViewDelegate {
    
    var customerId: UITextField
    var amount: UITextField
    var pan: UITextField
    var pin: UITextField
    var expiry: UITextField
    var activityIndicator: UIActivityIndicatorView
    var otpTransactionIdentifier: String?
    var transactionIdentifier: String?
    let sdk = PaymentSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")
    required init?(coder aDecoder: NSCoder) {
        customerId = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
        amount = UITextField(frame: CGRect(x: 20, y: 140, width: 200, height: 30))
        pan = UITextField(frame: CGRect(x: 20, y: 180, width: 200, height: 30))
        pin = UITextField(frame: CGRect(x: 20, y: 220, width: 200, height: 30))
        expiry = UITextField(frame: CGRect(x: 20, y: 260, width: 200, height: 30))
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        
        customerId.placeholder = "Customer ID"
        customerId.borderStyle = UITextBorderStyle.Line
        customerId.text = "1407002510"
        view.addSubview(customerId)
        
        amount.placeholder = "Amount"
        amount.borderStyle = UITextBorderStyle.Line
        amount.keyboardType = .DecimalPad
        amount.text = "100"
        view.addSubview(amount)
        
        pan.placeholder = "Card No"
        pan.borderStyle = UITextBorderStyle.Line
        pan.keyboardType = .NumberPad
        pan.text = "5060990580000217499"
        view.addSubview(pan)
        
        pin.placeholder = "Card PIN"
        pin.borderStyle = UITextBorderStyle.Line
        pin.keyboardType = .NumberPad
        pin.text = "1111"
        view.addSubview(pin)
        
        expiry.placeholder = "Expiry"
        expiry.borderStyle = UITextBorderStyle.Line
        expiry.keyboardType = .NumberPad
        expiry.text = "2004"
        view.addSubview(expiry)
        
        
        let payNow = UIButton(type: UIButtonType.RoundedRect)
        payNow.frame = CGRect(x: 20, y: 300, width: 40, height: 40)
        payNow.setTitle("Pay", forState: UIControlState.Normal)
        payNow.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        payNow.addTarget(self, action: "pay", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(payNow)
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(view)
        
        //        let webViewController = WebViewController(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E")
        //        webViewController.handle(nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pay(){
        if !customerId.hasText() {
            showError("Customer ID is required")
        } else if !amount.hasText(){
            showError("Amount is required")
        }else if !pan.hasText(){
            showError("Card No is required")
        }else if !pin.hasText(){
            showError("Card PIN is required")
        }else if !expiry.hasText(){
            showError("Expiry is required")
        }else{
            Passport.overrideApiBase("http://172.25.20.91:6060/passport")
            Payment.overrideApiBase("http://172.25.20.56:9080")
            let request = PurchaseRequest(customerId: customerId.text, amount: amount.text!, pan: pan.text!, pin: pin.text!, expiryDate: expiry.text!, cvv2: "", transactionRef: Payment.randomStringWithLength(12), requestorId: "12345678901")
            
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            activityIndicator.startAnimating()
            sdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: NSError?) in
                guard error == nil else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedDescription)!)
                    return
                }
                
                guard let response = purchaseResponse else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedFailureReason)!)
                    return
                }
                
                guard let otpTransactionIdentifier = response.otpTransactionIdentifier else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showSuccess("Ref: " + response.transactionIdentifier)
                    return
                }
                self.otpTransactionIdentifier = otpTransactionIdentifier
                self.transactionIdentifier = response.transactionIdentifier
                self.handleOTP(response.message)
            })
            
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if (buttonIndex == 0 && alertView.textFieldAtIndex(0)?.hasText() != nil){
            let otp = alertView.textFieldAtIndex(0)?.text
            let otpReq = AuthorizeOtpRequest(otpTransactionIdentifier: otpTransactionIdentifier!, otp: otp!, transactionRef: Payment.randomStringWithLength(12))
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            activityIndicator.startAnimating()
            sdk.authorizeOtp(otpReq, completionHandler: {(authorizeOtpResponse: AuthorizeOtpResponse?, error: NSError?) in
                guard error == nil else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedFailureReason)!)
                    return
                }
                
                guard let otpResponse = authorizeOtpResponse else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedFailureReason)!)
                    return
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                self.showSuccess("Ref: " + self.transactionIdentifier!)
            })
            
        }else{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    func showError(message: String){
        let alertView = UIAlertView()
        alertView.title = "Error"
        alertView.addButtonWithTitle("OK")
        alertView.message = message
        alertView.show()
    }
    
    func showSuccess(message: String){
        let alertView = UIAlertView()
        alertView.title = "Success"
        alertView.addButtonWithTitle("OK")
        alertView.message = message
        alertView.show()
    }
    
    func handleOTP(message: String){
        let alertView = UIAlertView()
        alertView.title = "OTP"
        alertView.addButtonWithTitle("OK")
        alertView.addButtonWithTitle("Cancel")
        alertView.message = message
        alertView.delegate = self
        alertView.cancelButtonIndex = 1
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.show()
    }
    
    
    
    func login(){
        //        let oAuth2WebViewController = OAuth2WebViewController()
        //        let clientId = "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E"
        //        let redirectUri = "com.interswitchng.sdk.payment://oauthCallback"
        //        let params = redirectUri + "&response_type=code&client_id=" + clientId + "&scope=profile"
        //        oAuth2WebViewController.handle(NSURL(string: Passport.getApiBase() + "/oauth/authorize?redirect_uri=" + params)!)
        
        Passport.overrideApiBase("http://172.25.20.91:6060/passport")
        Payment.overrideApiBase("http://172.25.20.56:9080")
        let sdk = WalletSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        sdk.getPaymentMethods({ (response: WalletResponse?, error: NSError?) -> Void in
            guard error == nil else {
                print("error getting payment methods")
                print(error)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            }
            
            guard let walletResponse = response else {
                print("error getting payment methods")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            }
            if !walletResponse.paymentMethods.isEmpty{
                print(walletResponse.paymentMethods[0].cardProduct)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
        
    }
    
}

class OAuth2WebViewController: UIViewController, UIWebViewDelegate {
    /// Login URL for OAuth.
    var targetURL : NSURL = NSURL()
    /// WebView intance used to load login page.
    var webView : UIWebView = UIWebView()
    
    /// Overrride of viewDidLoad to load the login page.
    override internal func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = UIScreen.mainScreen().bounds
        webView.delegate = self
        self.view.addSubview(webView)
        loadAddressURL()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = self.view.bounds
    }
    
    override internal func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadAddressURL() {
        let req = NSURLRequest(URL: targetURL)
        webView.loadRequest(req)
    }
    
    func handle(url: NSURL) {
        targetURL = url
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(
            self, animated: true, completion: nil)
    }
    
    internal func dismissWebViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where (url.scheme == "oauth-swift"){
            self.dismissWebViewController()
        }
        return true
    }
}

