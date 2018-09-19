//
//  ViewController.swift
//  SdkTest
//
//  Created by gabriel izebhigie on 11/01/2018.
//  Copyright © 2018 Interswitch. All rights reserved.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController {
    
    var customerId: UITextField
    var amount: UITextField
    var pan: UITextField
    var pin: UITextField
    var cvv: UITextField
    var expiry: UITextField
    var activityIndicator: UIActivityIndicatorView
    var otpTransactionIdentifier: String?
    var transactionIdentifier: String?
    let sdk = PaymentSDK(clientId: "IKIA7B379B0114CA57FAF8E19F5CC5063ED2220057EF", clientSecret: "MiunSQ5S/N219UCVP1Lt2raPfwK9lMoiV/PdBX5v/R4=")
    
    required init?(coder aDecoder: NSCoder) {
        customerId = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
        amount = UITextField(frame: CGRect(x: 20, y: 140, width: 200, height: 30))
        pan = UITextField(frame: CGRect(x: 20, y: 180, width: 200, height: 30))
        expiry = UITextField(frame: CGRect(x: 20, y: 220, width: 200, height: 30))
        cvv = UITextField(frame: CGRect(x: 20, y: 260, width: 200, height: 30))
        pin = UITextField(frame: CGRect(x: 20, y: 300, width: 200, height: 30))
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view.
        Passport.overrideApiBase("https://qa.interswitchng.com/passport")
        Payment.overrideApiBase("https://qa.interswitchng.com")
        view.backgroundColor = UIColor.white
        customerId.placeholder = "Customer ID"
        customerId.borderStyle = UITextBorderStyle.line
        customerId.text = "1407002510"
        view.addSubview(customerId)
        
        amount.placeholder = "Amount"
        amount.borderStyle = UITextBorderStyle.line
        amount.keyboardType = .decimalPad
        amount.text = "1"
        view.addSubview(amount)
        
        pan.placeholder = "Card No"
        pan.borderStyle = UITextBorderStyle.line
        pan.keyboardType = .numberPad
        pan.text = "5060990580000217499"
        view.addSubview(pan)
        
        pin.placeholder = "Card PIN"
        pin.borderStyle = UITextBorderStyle.line
        pin.keyboardType = .numberPad
        pin.text = "1111"
        view.addSubview(pin)
        
        expiry.placeholder = "Expiry"
        expiry.borderStyle = UITextBorderStyle.line
        expiry.keyboardType = .numberPad
        expiry.text = "2004"
        view.addSubview(expiry)
        
        cvv.placeholder = "CVV"
        cvv.borderStyle = UITextBorderStyle.line
        cvv.keyboardType = .numberPad
        cvv.text = "111"
        view.addSubview(cvv)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.bringSubview(toFront: view)
        
        
        let payNow = UIButton(type: UIButtonType.roundedRect)
        payNow.frame = CGRect(x: 20, y: 340, width: 40, height: 40)
        payNow.setTitle("Pay", for: UIControlState())
        payNow.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        payNow.addTarget(self, action: #selector(ViewController.pay), for: UIControlEvents.touchUpInside)
        view.addSubview(payNow)
        modalPresentationStyle = .popover
    }
    
    @objc func pay(){
        if !customerId.hasText {
            showError("Customer ID is required")
        } else if !amount.hasText{
            showError("Amount is required")
        }else if !pan.hasText{
            showError("Card No is required")
        }else if !cvv.hasText{
            showError("CVV is required")
        }else if !pin.hasText{
            showError("Card PIN is required")
        }else if !expiry.hasText{
            showError("Expiry is required")
        }else{
            let request = PurchaseRequest(customerId: customerId.text, amount: amount.text!, pan: pan.text!, pin: pin.text!, expiryDate: expiry.text!, cvv2: cvv.text!, transactionRef: Payment.randomStringWithLength(12), requestorId: "12345678901")
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            activityIndicator.startAnimating()
            sdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: Error?) in
                self.otpTransactionIdentifier = "1234567"
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
                self.otpTransactionIdentifier = otpTransactionIdentifier
                self.transactionIdentifier = response.transactionIdentifier
                self.handleOTP(response.message)
            } )
            
        }
    }
    func showError(_ message: String){
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccess(_ message: String){
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func handleOTP(_ message: String){
        let alert = UIAlertController(
            title: "OTP2",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "Enter OTP"
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            if ((alert.textFields?.first?.hasText) != nil){
                let otp = alert.textFields?.first?.text
                let otpReq = AuthorizeOtpRequest(otpTransactionIdentifier: self.otpTransactionIdentifier!, otp: otp!, transactionRef: Payment.randomStringWithLength(12))
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.activityIndicator.startAnimating()
                self.sdk.authorizeOtp(otpReq, completionHandler: {(authorizeOtpResponse: AuthorizeOtpResponse?, error: Error?) in
                    guard error == nil else {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.activityIndicator.stopAnimating()
                        self.showError((error?.localizedDescription)!)
                        return
                    }
                    
                    guard authorizeOtpResponse != nil else {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.activityIndicator.stopAnimating()
                        self.showError((error?.localizedDescription)!)
                        return
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showSuccess("Ref: " + self.transactionIdentifier!)
                } )
                
            }else{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
            }
            
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

