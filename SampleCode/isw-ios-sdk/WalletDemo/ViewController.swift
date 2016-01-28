//
//  ViewController.swift
//  WalletDemo
//
//  Created by Adesegun Adeyemo on 07/10/2015.
//  Copyright © 2015 Interswitch Limited. All rights reserved.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var customerId: UITextField
    var amount: UITextField
    var pin: UITextField
    var paymentMethod: UITextField
    var activityIndicator: UIActivityIndicatorView
    var otpTransactionIdentifier: String?
    var transactionIdentifier: String?
    let sdk = WalletSDK(clientId: "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E", clientSecret: "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=")
    var loadingWallet = false
    var paymentMethods = [PaymentMethod]()
    var selectedMethod: String?
    required init?(coder aDecoder: NSCoder) {
        customerId = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 30))
        paymentMethod = UITextField(frame: CGRect(x: 20, y: 140, width: 250, height: 30))
        amount = UITextField(frame: CGRect(x: 20, y: 180, width: 250, height: 30))
        pin = UITextField(frame: CGRect(x: 20, y: 220, width: 250, height: 30))
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        super.init(coder: aDecoder)
        
    }
    
    //    override func viewDidAppear(animated: Bool) {
    //        if !loadingWallet{
    //            loadingWallet = true
    //            loadWallet()
    //        }
    //    }
    
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
        
        pin.placeholder = "PIN"
        pin.borderStyle = UITextBorderStyle.Line
        pin.keyboardType = .NumberPad
        pin.text = "1111"
        view.addSubview(pin)
        
        let uiPickerView = UIPickerView()
        uiPickerView.dataSource = self
        uiPickerView.delegate = self
        uiPickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "canclePicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        paymentMethod.placeholder = "Select Payment Method"
        paymentMethod.borderStyle = UITextBorderStyle.Line
        paymentMethod.inputView = uiPickerView
        paymentMethod.inputAccessoryView = toolBar
        paymentMethod.delegate = self
        view.addSubview(paymentMethod)
        
        //        let refresh = UIButton(type: UIButtonType.RoundedRect)
        //        refresh.frame = CGRect(x: 180, y: 138, width: 140, height: 40)
        //        refresh.setTitle("Load", forState: UIControlState.Normal)
        //        refresh.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        //        refresh.addTarget(self, action: "loadWallet", forControlEvents: UIControlEvents.TouchUpInside)
        //        view.addSubview(refresh)
        
        let payNow = UIButton(type: UIButtonType.RoundedRect)
        payNow.frame = CGRect(x: 20, y: 260, width: 40, height: 40)
        payNow.setTitle("Pay", forState: UIControlState.Normal)
        payNow.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        payNow.addTarget(self, action: "pay", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(payNow)
        
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(view)
    }
    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        paymentMethod.hidden = false
//        return false
//    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        if paymentMethods.count < 1{
            loadWallet()
        }
    }
    
    func donePicker(){
        paymentMethod.resignFirstResponder()    }
    
    func canclePicker(){
        paymentMethod.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return paymentMethods.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentMethods[row].cardProduct
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if row > 0 && row <= paymentMethods.count{
            paymentMethod.text = paymentMethods[row].cardProduct
            selectedMethod = paymentMethods[row].token
            self.view.endEditing(true)
        }
    }
    
    func pay(){
        if !customerId.hasText() {
            showError("Customer ID is required")
        } else if !amount.hasText(){
            showError("Amount is required")
        }else if !pin.hasText(){
            showError("PIN is required")
        }else if (selectedMethod == nil){
            showError("Select a Payment Method")
        }else if (selectedMethod?.isEmpty == true){
            showError("Select a Payment Method")
        }else{
            Passport.overrideApiBase("http://172.25.20.91:6060/passport")
            Payment.overrideApiBase("http://172.25.20.56:9080")
            let request = PurchaseRequest(customerId: customerId.text, amount: amount.text!, pan: selectedMethod!, pin: pin.text!, expiryDate: "", cvv2: "", transactionRef: Payment.randomStringWithLength(12), requestorId: "12345678901")
            
            
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

    
    func loadWallet(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        Passport.overrideApiBase("http://qa.interswitchng.com/passport")
        Payment.overrideApiBase("http://qa.interswitchng.com")
        sdk.getPaymentMethods({ (response: WalletResponse?, error: NSError?) -> Void in
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                self.loadingWallet = false
                self.showError((error?.localizedDescription)!)
                return
            }
            
            guard let walletResponse = response else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                self.loadingWallet = false
                self.showError((error?.localizedDescription)!)
                return
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityIndicator.stopAnimating()
            self.loadingWallet = false
            self.paymentMethods = walletResponse.paymentMethods
            if self.paymentMethods.count > 0{
                self.paymentMethod.text = self.paymentMethods[0].cardProduct
            }
        })
        
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
    
}

