//
//  ViewController.swift
//  CardDemo
//
//  Created by Efe Ariaroo on 4/22/16.
//  Copyright © 2016 Interswitch Limited. All rights reserved.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController, UIAlertViewDelegate {
    
    var customerId: UITextField
    var amount: UITextField
    var pan: UITextField
    var cvv2Field : UITextField
    var pin: UITextField
    var expiry: UITextField
    
    var activityIndicator: UIActivityIndicatorView
    var otpTransactionIdentifier: String = ""
    
    let clientId = "IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E"
    let clientSecret = "SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY="
    
    let yourRequestorId = "12345678901"     //Specify your own requestorId here
    
    let sdk : PaymentSDK
    
    
    required init?(coder aDecoder: NSCoder) {
        customerId = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
        amount = UITextField(frame: CGRect(x: 20, y: 140, width: 200, height: 30))
        
        pan = UITextField(frame: CGRect(x: 20, y: 180, width: 200, height: 30))
        cvv2Field = UITextField()
        pin = UITextField(frame: CGRect(x: 20, y: 220, width: 200, height: 30))
        expiry = UITextField(frame: CGRect(x: 20, y: 260, width: 200, height: 30))
        
        activityIndicator = UIActivityIndicatorView()

        sdk = PaymentSDK(clientId: clientId, clientSecret: clientSecret)
        
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
        headerLabel.text = "Card payment demo"
        
        headerLabel.frame = CGRectMake(XPosition, 50, 250, 40)
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        headerLabel.font = UIFont.boldSystemFontOfSize(16.0)
        headerLabel.textAlignment = .Center
        view.addSubview(headerLabel)
        
        customerId.frame = CGRect(x: XPosition, y: 130, width: textfieldsWidth, height: textfieldsHeight)
        customerId.placeholder = "Customer ID"
        customerId.borderStyle = UITextBorderStyle.Line
        customerId.text = "1407002510"   // This should be a value that identifies your customer uniquely e.g email or phone number etc
        view.addSubview(customerId)
        
        amount.frame = CGRect(x: XPosition, y: 170 + yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        amount.placeholder = "Amount"
        amount.borderStyle = UITextBorderStyle.Line
        amount.keyboardType = .DecimalPad
        amount.text = "100"
        view.addSubview(amount)
        
        pan.frame = CGRect(x: XPosition, y: 210 + 2 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        pan.placeholder = "Card Number"
        pan.borderStyle = UITextBorderStyle.Line
        pan.keyboardType = .NumberPad
        pan.text = "5060990580000217499"
        view.addSubview(pan)
        
        
        cvv2Field.frame = CGRect(x: XPosition, y: 250 + 3 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        cvv2Field.placeholder = "CVV"
        cvv2Field.borderStyle = UITextBorderStyle.Line
        cvv2Field.keyboardType = .NumberPad
        cvv2Field.text = "111"
        view.addSubview(cvv2Field)
        
        pin.frame = CGRect(x: XPosition, y: 290 + 4 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        pin.placeholder = "Card PIN"
        pin.borderStyle = UITextBorderStyle.Line
        pin.keyboardType = .NumberPad
        pin.text = "1111"
        view.addSubview(pin)
        
        expiry.frame = CGRect(x: XPosition, y: 330 + 5 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        expiry.placeholder = "Expiry (format: YYMM)"
        expiry.borderStyle = UITextBorderStyle.Line
        expiry.keyboardType = .NumberPad
        expiry.text = "2004"
        view.addSubview(expiry)
        
        
        let payNow = UIButton(type: UIButtonType.RoundedRect)
        payNow.frame = CGRect(x: XPosition, y: 380 + 6 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        //payNow.frame = CGRect(x: 20, y: 300, width: 40, height: 40)
        payNow.setTitle("Pay", forState: UIControlState.Normal)
        payNow.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        styleButton(payNow)
        
        payNow.addTarget(self, action: #selector(ViewController.pay), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(payNow)
        
        activityIndicator.frame = CGRect(x: (screenWidth - 40)/2, y: 500, width: 40, height: textfieldsHeight)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(view)
    }
    
    func styleButton(theButton : UIButton) {
        theButton.layer.cornerRadius = 5.0
        theButton.backgroundColor  = UIColor.blackColor()
        theButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func pay(){
        if isOkToMakePaymentRequest() {
            let request = PurchaseRequest(customerId: customerId.text, amount: amount.text!, pan: pan.text!,
                                          pin: pin.text!, expiryDate: expiry.text!, cvv2: cvv2Field.text!,
                                          transactionRef: Payment.randomStringWithLength(12), requestorId: yourRequestorId)
            
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
                
                guard let responseCode = response.responseCode else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showSuccess("Ref: " + response.transactionIdentifier)
                    return
                }
                
                if responseCode == PaymentSDK.SAFE_TOKEN_RESPONSE_CODE {
                    self.handleOTP(response.message, authData: request.authData, purchaseResponse: response)
                } else if (responseCode == PaymentSDK.CARDINAL_RESPONSE_CODE) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.handleCardinal(request.authData, purchaseResponse: response)
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
    func isOkToMakePaymentRequest() -> Bool {
        var isOk = false
        
        if !customerId.hasText() {
            showError("Customer ID is required")
        } else if !amount.hasText() {
            showError("Amount is required")
        } else if !pan.hasText() {
            showError("PAN is required")
        } else if !cvv2Field.hasText() {
            showError("CVV is required")
        } else if !pin.hasText() {
            showError("PIN is required")
        } else {
            isOk = true
        }
        return isOk
    }
    
    func handleOTP(message: String, authData: String, purchaseResponse: PurchaseResponse){
        let alert = UIAlertController(title: "OTP", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Enter OTP"
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            if ((alert.textFields?.first?.hasText()) != nil){
                let otp = alert.textFields?.first?.text
                let otpReq = AuthorizePurchaseRequest()
                otpReq.paymentId = purchaseResponse.paymentId!
                otpReq.otp = otp!
                otpReq.authData = authData
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.activityIndicator.startAnimating()
                
                self.sdk.authorizePurchase(otpReq, completionHandler: {(authorizePurchaseResponse: AuthorizePurchaseResponse?, error: NSError?) in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    
                    guard error == nil else {
                        self.showError((error?.localizedDescription)!)
                        return
                    }
                    
                    guard let authPurchaseResponse = authorizePurchaseResponse else {
                        self.showError("Otp validation was NOT successful")
                        return
                    }
                    self.showSuccess("Payment successful!\n Transation Id: \(authPurchaseResponse.transactionIdentifier)")
                })
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
            }
        })
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func handleCardinal(authData: String, purchaseResponse: PurchaseResponse) {
        let authorizeHandler = {() -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            
            let authorizeCardinalRequest = AuthorizePurchaseRequest()
            authorizeCardinalRequest.authData = authData
            authorizeCardinalRequest.paymentId = purchaseResponse.paymentId!
            authorizeCardinalRequest.transactionId = purchaseResponse.transactionId
            authorizeCardinalRequest.eciFlag = purchaseResponse.eciFlag!
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.activityIndicator.startAnimating()
            
            self.sdk.authorizePurchase(authorizeCardinalRequest, completionHandler:{(authorizePurchaseResponse: AuthorizePurchaseResponse?, error: NSError?) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                
                guard error == nil else {
                    self.showError((error?.localizedDescription)!)
                    return
                }
                guard authorizePurchaseResponse != nil else {
                    self.showError("Authorization was NOT successful")
                    return
                }
                self.showSuccess("Payment successful!\n Transation Id: \(authorizePurchaseResponse!.transactionIdentifier)")
            })
        }
        let authorizePurchaseVc = AuthorizeViewController(response: purchaseResponse, authorizeHandler: authorizeHandler)
        self.navigationController?.pushViewController(authorizePurchaseVc, animated: true)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
