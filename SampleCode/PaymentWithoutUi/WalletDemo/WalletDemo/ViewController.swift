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
    var uiPickerView : UIPickerView
    
    var activityIndicator : UIActivityIndicatorView
    var otpTransactionRef : String = ""
    var otpTransactionIdentifier : String = ""
    var transactionIdentifier : String?
    
    let walletSdk : WalletSDK
    var loadingWallet = false
    var paymentMethods = [PaymentMethod]()
    var tokenOfUserSelectedPM : String?    //PM stands for payment method
    
    let yourClientId = "IKIA7B379B0114CA57FAF8E19F5CC5063ED2220057EF"
    let yourClientSecret = "MiunSQ5S/N219UCVP1Lt2raPfwK9lMoiV/PdBX5v/R4="
    
    let yourRequestorId = "12345678901"     //Specify your own requestorId here

    
    required init?(coder aDecoder: NSCoder) {
        customerId = UITextField()
        paymentMethod = UITextField()
        amount = UITextField()
        cvvTextField = UITextField()
        pin = UITextField()
        uiPickerView = UIPickerView()
        
        activityIndicator = UIActivityIndicatorView()
        
        walletSdk = WalletSDK(clientId: yourClientId, clientSecret: yourClientSecret)
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Passport.overrideApiBase("https://qa.interswitchng.com/passport")
        Payment.overrideApiBase("https://qa.interswitchng.com")
        
        view.backgroundColor = UIColor.white
        
        let screenWidth = self.view.bounds.width
        let yTopMargin : CGFloat = 10.0
        let textfieldsWidth : CGFloat = 250
        let textfieldsHeight : CGFloat = 40
        
        let XPosition : CGFloat = (screenWidth - textfieldsWidth)/2
        
        //--
        let headerLabel = UILabel()
        headerLabel.text = "Wallet payment demo"
        
        headerLabel.frame = CGRect(x: XPosition, y: 50, width: 250, height: 40)
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        
        
        customerId.frame = CGRect(x: XPosition, y: 100, width: textfieldsWidth, height: textfieldsHeight)
        customerId.placeholder = "Customer ID"
        customerId.borderStyle = UITextBorderStyle.line
        customerId.text = "1407002510"   // This should be a value that identifies your customer uniquely e.g email or phone number etc
        view.addSubview(customerId)
        
        addPaymentMethodFieldFunctionality(XPosition, yPosition: (140 + yTopMargin), textfieldsWidth: textfieldsWidth, textfieldsHeight: textfieldsHeight)
        
        amount.frame = CGRect(x: XPosition, y: 180 + 2 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        amount.placeholder = "Amount"
        amount.borderStyle = UITextBorderStyle.line
        amount.keyboardType = .decimalPad
        amount.text = "100"
        view.addSubview(amount)
        
        
        cvvTextField.frame = CGRect(x: XPosition, y: 220 + 3 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        cvvTextField.placeholder = "CVV"
        cvvTextField.borderStyle = UITextBorderStyle.line
        cvvTextField.keyboardType = .numberPad
        cvvTextField.text = "111"
        view.addSubview(cvvTextField)
        
        pin.frame = CGRect(x: XPosition, y: 260 + 4 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        pin.placeholder = "PIN"
        pin.borderStyle = UITextBorderStyle.line
        pin.keyboardType = .numberPad
        pin.text = "1111"
        view.addSubview(pin)
        
        let payNow = UIButton(type: UIButtonType.roundedRect)
        payNow.frame = CGRect(x: XPosition, y: 370, width: textfieldsWidth, height: textfieldsHeight)
        payNow.setTitle("Pay", for: UIControlState())
        payNow.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        styleButton(payNow)
        
        payNow.addTarget(self, action: #selector(ViewController.pay), for: UIControlEvents.touchUpInside)
        view.addSubview(payNow)
        
        
        activityIndicator.frame = CGRect(x: (screenWidth - 40)/2, y: 420, width: 40, height: textfieldsHeight)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.bringSubview(toFront: view)
    }

    func styleButton(_ theButton : UIButton) {
        theButton.layer.cornerRadius = 5.0
        theButton.backgroundColor  = UIColor.black
        theButton.setTitleColor(UIColor.white, for: UIControlState())
    }

    func addPaymentMethodFieldFunctionality(_ xPosition: CGFloat, yPosition: CGFloat,
                                              textfieldsWidth: CGFloat, textfieldsHeight: CGFloat) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self,
                                         action: #selector(ViewController.donePicker))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self,
                                           action: #selector(ViewController.cancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //--
        paymentMethod.frame = CGRect(x: xPosition, y: yPosition, width: textfieldsWidth, height: textfieldsHeight)
        paymentMethod.placeholder = "Select Payment Method"
        paymentMethod.borderStyle = UITextBorderStyle.line
        
        uiPickerView.dataSource = self
        uiPickerView.delegate = self
        uiPickerView.showsSelectionIndicator = true
        paymentMethod.inputView = uiPickerView
        
        paymentMethod.inputAccessoryView = toolBar
        paymentMethod.delegate = self
        view.addSubview(paymentMethod)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return paymentMethods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentMethods[row].cardProduct
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row >= 0 && row < paymentMethods.count {
            let thePaymentMethod : PaymentMethod = paymentMethods[row]
            
            let cardProduct = thePaymentMethod.cardProduct
            paymentMethod.text = cardProduct
            tokenOfUserSelectedPM = thePaymentMethod.token
            
            if(cardProduct.lowercased().contains("eCash".lowercased()) || cardProduct.lowercased().contains("m-Pin".lowercased())){
                cvvTextField.isHidden = true
            } else {
                cvvTextField.isHidden = false
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
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            activityIndicator.startAnimating()
            
            walletSdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: Error?) in
                guard error == nil else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedDescription)!)
                    return
                }
                
                guard let response = purchaseResponse else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedDescription)!)
                    return
                }
                
                guard let otpTransactionIdentifier = response.otpTransactionIdentifier else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showSuccess("Ref: " + response.transactionIdentifier)
                    return
                }
                
                print("Got the otp transaction identifier")
                self.handleOTP(otpTransactionIdentifier, otpTransactionRef: response.transactionRef, otpMessage: response.message)
            } )
        }
    }
    
    func isOkToMakePaymentRequest() -> Bool {
        var isOk = false
        
        if !customerId.hasText {
            showError("Customer ID is required")
        } else if !amount.hasText {
            showError("Amount is required")
        } else if !pin.isHidden && !pin.hasText {
            showError("PIN is required")
        } else if (tokenOfUserSelectedPM == nil || tokenOfUserSelectedPM?.isEmpty == true) {
            showError("Select a Payment Method")
        } else {
            isOk = true
        }
        return isOk
    }
    
    func loadWallet() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        
        walletSdk.getPaymentMethods({ (response: WalletResponse?, error: Error?) -> Void in
            guard error == nil else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                self.loadingWallet = false
                
                self.view.endEditing(true)
                self.showError((error?.localizedDescription)!)
                return
            }
            
            guard let walletResponse = response else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                self.loadingWallet = false
                
                self.view.endEditing(true)
                self.showError((error?.localizedDescription)!)
                return
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicator.stopAnimating()
            
            self.loadingWallet = false
            self.paymentMethods = walletResponse.paymentMethods
            print("Got the payment methods!")
            
            if self.paymentMethods.count > 0 {
                self.paymentMethod.text = self.paymentMethods[0].cardProduct
                self.uiPickerView.reloadAllComponents()
            }
        } )
    }
    
    func handleOTP(_ theOtpTransactionIdentifier: String, otpTransactionRef: String, otpMessage: String) {
        let otpAlertController = UIAlertController(title: "OTP transaction authorization", message: otpMessage, preferredStyle: .alert)
        otpAlertController.view.tintColor = UIColor.green
        
        otpAlertController.addTextField(configurationHandler: { (textField) -> Void in
            //Customize textField however you want
            textField.text = ""
        })
        
        otpAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
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
            
            self.walletSdk.authorizeOtp(otpReq, completionHandler: {(authorizeOtpResponse: AuthorizeOtpResponse?, error: Error?) in
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
            } )
        }))
        otpAlertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            //Does nothing after cancel button is clicked
        }))
        
        self.present(otpAlertController, animated: true, completion: nil)
    }
    
    
    func showError(_ message: String) {
        let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertVc.addAction(action)
        
        self.present(alertVc, animated: true, completion: nil)
    }
    
    func showSuccess(_ message: String) {
        let alertVc = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertVc.addAction(action)
        
        self.present(alertVc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

