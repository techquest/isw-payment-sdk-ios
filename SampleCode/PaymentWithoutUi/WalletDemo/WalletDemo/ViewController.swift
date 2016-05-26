//
//  ViewController.swift
//  WalletDemo
//
//  Created by Efe Ariaroo on 4/21/16.
//  Copyright © 2016 Interswitch Limited. All rights reserved.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var customerId : UITextField
    var amount : UITextField
    var cvvTextField : UITextField
    var pin : UITextField
    var paymentMethod : UITextField
    
    var activityIndicator : UIActivityIndicatorView
    var otpTransactionRef : String = ""
    var otpTransactionIdentifier : String = ""
    var transactionIdentifier : String?
    
    let walletSdk : WalletSDK
    var loadingWallet = false
    var paymentMethods = [PaymentMethod]()
    var tokenOfUserSelectedPM : String?    //PM stands for payment method
    
    let yourClientId = "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E"
    let yourClientSecret = "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY="
    
    let yourRequestorId = "12345678901"     //Specify your own requestorId here

    
    required init?(coder aDecoder: NSCoder) {
        customerId = UITextField()
        paymentMethod = UITextField()
        amount = UITextField()
        cvvTextField = UITextField()
        pin = UITextField()
        activityIndicator = UIActivityIndicatorView()
        
        walletSdk = WalletSDK(clientId: yourClientId, clientSecret: yourClientSecret)
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Passport.overrideApiBase("https://sandbox.interswitchng.com/passport")
        Payment.overrideApiBase("https://sandbox.interswitchng.com")
        
        view.backgroundColor = UIColor.whiteColor()
        
        let screenWidth = self.view.bounds.width
        let yTopMargin : CGFloat = 10.0
        let textfieldsWidth : CGFloat = 250
        let textfieldsHeight : CGFloat = 40
        
        let XPosition : CGFloat = (screenWidth - textfieldsWidth)/2
        
        //--
        let headerLabel = UILabel()
        headerLabel.text = "Wallet payment demo"
        
        headerLabel.frame = CGRectMake(XPosition, 50, 250, 40)
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        headerLabel.font = UIFont.boldSystemFontOfSize(16.0)
        headerLabel.textAlignment = .Center
        view.addSubview(headerLabel)
        
        
        customerId.frame = CGRect(x: XPosition, y: 100, width: textfieldsWidth, height: textfieldsHeight)
        customerId.placeholder = "Customer ID"
        customerId.borderStyle = UITextBorderStyle.Line
        customerId.text = "1407002510"   // This should be a value that identifies your customer uniquely e.g email or phone number etc
        view.addSubview(customerId)
        
        addPaymentMethodFieldFunctionality(XPosition, yPosition: (140 + yTopMargin), textfieldsWidth: textfieldsWidth, textfieldsHeight: textfieldsHeight)
        
        amount.frame = CGRect(x: XPosition, y: 180 + 2 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        amount.placeholder = "Amount"
        amount.borderStyle = UITextBorderStyle.Line
        amount.keyboardType = .DecimalPad
        amount.text = "100"
        view.addSubview(amount)
        
        
        cvvTextField.frame = CGRect(x: XPosition, y: 220 + 3 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        cvvTextField.placeholder = "CVV"
        cvvTextField.borderStyle = UITextBorderStyle.Line
        cvvTextField.keyboardType = .NumberPad
        cvvTextField.text = "111"
        view.addSubview(cvvTextField)
        
        pin.frame = CGRect(x: XPosition, y: 260 + 4 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        pin.placeholder = "PIN"
        pin.borderStyle = UITextBorderStyle.Line
        pin.keyboardType = .NumberPad
        pin.text = "1111"
        view.addSubview(pin)
        
        let payNow = UIButton(type: UIButtonType.RoundedRect)
        payNow.frame = CGRect(x: XPosition, y: 370, width: textfieldsWidth, height: textfieldsHeight)
        payNow.setTitle("Pay", forState: UIControlState.Normal)
        payNow.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        styleButton(payNow)
        
        payNow.addTarget(self, action: #selector(ViewController.pay), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(payNow)
        
        
        activityIndicator.frame = CGRect(x: (screenWidth - 40)/2, y: 420, width: 40, height: textfieldsHeight)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        //activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(view)
    }

    func styleButton(theButton : UIButton) {
        theButton.layer.cornerRadius = 5.0
        theButton.backgroundColor  = UIColor.blackColor()
        theButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }

    func addPaymentMethodFieldFunctionality(xPosition: CGFloat, yPosition: CGFloat,
                                              textfieldsWidth: CGFloat, textfieldsHeight: CGFloat) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self,
                                         action: #selector(ViewController.donePicker))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self,
                                           action: #selector(ViewController.cancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        //--
        paymentMethod.frame = CGRect(x: xPosition, y: yPosition, width: textfieldsWidth, height: textfieldsHeight)
        paymentMethod.placeholder = "Select Payment Method"
        paymentMethod.borderStyle = UITextBorderStyle.Line
        
        let uiPickerView = UIPickerView()
        uiPickerView.dataSource = self
        uiPickerView.delegate = self
        uiPickerView.showsSelectionIndicator = true
        paymentMethod.inputView = uiPickerView
        
        paymentMethod.inputAccessoryView = toolBar
        paymentMethod.delegate = self
        view.addSubview(paymentMethod)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if paymentMethods.count < 1 {
            loadWallet()
        }
    }
    //--
    func cancelPicker(){
        paymentMethod.resignFirstResponder()
    }
    
    func donePicker() {
        paymentMethod.resignFirstResponder()
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row >= 0 && row < paymentMethods.count {
            let thePaymentMethod : PaymentMethod = paymentMethods[row]
            
            let cardProduct = thePaymentMethod.cardProduct
            paymentMethod.text = cardProduct
            tokenOfUserSelectedPM = thePaymentMethod.token
            
            if(cardProduct.lowercaseString.containsString("eCash".lowercaseString) || cardProduct.lowercaseString.containsString("m-Pin".lowercaseString)){
                cvvTextField.hidden = true
            } else {
                cvvTextField.hidden = false
            }
            self.view.endEditing(true)
        }
    }
    
    func pay() {
        if isOkToMakePaymentRequest() {
            self.otpTransactionIdentifier = ""
            self.otpTransactionRef = ""
            
            let request = PurchaseRequest(customerId: customerId.text, amount: amount.text!, pan: tokenOfUserSelectedPM!,
                                          pin: pin.text!, cvv2: cvvTextField.text!, transactionRef: Payment.randomStringWithLength(12),
                                          requestorId: yourRequestorId)
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            activityIndicator.startAnimating()
            
            walletSdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: NSError?) in
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
                
                print("Got the otp transaction identifier")
                self.handleOTP(otpTransactionIdentifier, otpTransactionRef: response.transactionRef, otpMessage: response.message)
            })
        }
    }
    
    func isOkToMakePaymentRequest() -> Bool {
        var isOk = false
        
        if !customerId.hasText() {
            showError("Customer ID is required")
        } else if !amount.hasText() {
            showError("Amount is required")
        } else if !pin.hidden && !pin.hasText() {
            showError("PIN is required")
        } else if (tokenOfUserSelectedPM == nil || tokenOfUserSelectedPM?.isEmpty == true) {
            showError("Select a Payment Method")
        } else {
            isOk = true
        }
        return isOk
    }
    
    func loadWallet() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        
        walletSdk.getPaymentMethods({ (response: WalletResponse?, error: NSError?) -> Void in
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
            print("Got the payment methods!")
            
            if self.paymentMethods.count > 0 {
                self.paymentMethod.text = self.paymentMethods[0].cardProduct
            }
        })
    }
    
    func handleOTP(theOtpTransactionIdentifier: String, otpTransactionRef: String, otpMessage: String) {
        let otpAlertController = UIAlertController(title: "OTP transaction authorization", message: otpMessage, preferredStyle: .Alert)
        otpAlertController.view.tintColor = UIColor.greenColor()
        
        otpAlertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //Customize textField however you want
            textField.text = ""
        })
        
        otpAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = otpAlertController.textFields![0] as UITextField
            
            guard !textField.text!.isEmpty else {
                self.activityIndicator.stopAnimating()
                
                self.showError("You didn't enter an otp value")
                return
            }
            guard !self.otpTransactionIdentifier.isEmpty else {
                self.activityIndicator.stopAnimating()
                
                self.showError("Otp transaction identifier does not exist")
                return
            }
            //--
            let otpReq = AuthorizeOtpRequest(otpTransactionIdentifier: theOtpTransactionIdentifier,
                otp: textField.text!, transactionRef: otpTransactionRef)
            
            self.walletSdk.authorizeOtp(otpReq, completionHandler: {(authorizeOtpResponse: AuthorizeOtpResponse?, error: NSError?) in
                guard error == nil else {
                    // handle error
                    self.activityIndicator.stopAnimating()
                    
                    self.showError((error?.localizedDescription)!)
                    return
                }
                
                guard authorizeOtpResponse != nil else {
                    //handle error
                    self.activityIndicator.stopAnimating()
                    
                    self.showError("Otp validation was NOT successful")
                    return
                }
                //OTP successful
                self.showSuccess("OTP authorization success")
            })
        }))
        otpAlertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            //Does nothing after cancel button is clicked
        }))
        
        self.presentViewController(otpAlertController, animated: true, completion: nil)
    }
    
    
    func showError(message: String) {
        let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)
        
        self.presentViewController(alertVc, animated: true, completion: nil)
    }
    
    func showSuccess(message: String) {
        let alertVc = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertVc.addAction(action)
        
        self.presentViewController(alertVc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

