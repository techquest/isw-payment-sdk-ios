//
//  ViewController.swift
//  PaymentDemo
//
//  Created by Efe Ariaroo on 4/20/16.
//  Copyright © 2016 Interswitch Limited. All rights reserved.
//

import UIKit
import PaymentSDK


class ViewController: UIViewController {
    
    let yourClientId = "IKIA7B379B0114CA57FAF8E19F5CC5063ED2220057EF"
    let yourClientSecret = "MiunSQ5S/N219UCVP1Lt2raPfwK9lMoiV/PdBX5v/R4="
    
    let theCustomerId = "07037122181"           // This should be a value that identifies your customer uniquely e.g email or phone number etc
    let paymentDescription = "Payment for goods"
    let theAmount = "20"
    
    let theCardType = "verve"                  //This should be a valid card type e.g mastercard, verve, visa etc
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Passport.overrideApiBase("https://qa.interswitchng.com/passport")
        Payment.overrideApiBase("https://qa.interswitchng.com")
        
        view.backgroundColor = UIColor.white
        
        let screenWidth = self.view.bounds.width
        let yTopMargin:CGFloat = 10.0        //Set header
        let buttonsWidth:CGFloat = 250
        let buttonsHeight:CGFloat = 40
        
        let XPosition: CGFloat = (screenWidth - buttonsWidth)/2
        
        //--
        let headerLabel = UILabel()
        headerLabel.text = "Payment demo"
        
        headerLabel.frame = CGRect(x: XPosition, y: 60, width: 250, height: 40)
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        
        
        //Pay with card button
        let payWithCardOrWalletButton = UIButton(type: .system)
        payWithCardOrWalletButton.frame = CGRect(x: XPosition, y: 100 + yTopMargin, width: buttonsWidth, height: buttonsHeight)
        payWithCardOrWalletButton.setTitle("Pay With Card or Wallet", for: UIControlState())
        styleButton(payWithCardOrWalletButton)
        
        payWithCardOrWalletButton.addTarget(self, action: #selector(ViewController.payWithCardOrWallet), for: .touchUpInside)
        view.addSubview(payWithCardOrWalletButton)
        
        //Pay with card button
        let payWithCardButton = UIButton(type: .system)
        payWithCardButton.frame = CGRect(x: XPosition, y: 150 + yTopMargin, width: buttonsWidth, height: buttonsHeight)
        payWithCardButton.setTitle("Pay With Card", for: UIControlState())
        styleButton(payWithCardButton)
        
        payWithCardButton.addTarget(self, action: #selector(ViewController.payWithCard), for: .touchUpInside)
        view.addSubview(payWithCardButton)
        
        
        //Pay with wallet button
        let payWithWalletButton = UIButton(type: .system)
        payWithWalletButton.frame = CGRect(x: XPosition, y: 190 + 2 * yTopMargin, width: buttonsWidth, height: buttonsHeight)
        payWithWalletButton.setTitle("Pay With Wallet", for: UIControlState())
        styleButton(payWithWalletButton)
        
        payWithWalletButton.addTarget(self, action: #selector(ViewController.payWithWallet), for: .touchUpInside)
        view.addSubview(payWithWalletButton)
        
        
        //Validate card button
        let validateCardButton = UIButton(type: .system)
        validateCardButton.frame = CGRect(x: XPosition, y: 230 + 3 * yTopMargin, width: buttonsWidth, height: buttonsHeight)
        validateCardButton.setTitle("Validate Card", for: UIControlState())
        styleButton(validateCardButton)
        
        validateCardButton.addTarget(self, action: #selector(ViewController.validateCard), for: .touchUpInside)
        view.addSubview(validateCardButton)
        
        
        //Pay with token button
        let payWithTokenButton = UIButton(type: .system)
        payWithTokenButton.frame = CGRect(x: XPosition, y: 270 + 4 * yTopMargin, width: buttonsWidth, height: buttonsHeight)
        payWithTokenButton.setTitle("Pay With Token", for: UIControlState())
        styleButton(payWithTokenButton)
        
        payWithTokenButton.addTarget(self, action: #selector(ViewController.payWithToken), for: .touchUpInside)
        view.addSubview(payWithTokenButton)
    }
    
    func styleButton(_ theButton : UIButton) {
        theButton.layer.cornerRadius = 5.0
        theButton.backgroundColor  = UIColor.black
        theButton.setTitleColor(UIColor.white, for: UIControlState())
    }

    func payWithCardOrWallet(){
        let pwc = Pay(clientId: yourClientId, clientSecret: yourClientSecret,
                      customerId: theCustomerId, description: paymentDescription,
                      amount: theAmount, currency: "NGN")
        let vc = pwc.start({(purchaseResponse: PurchaseResponse?, error: Error?) in
            guard error == nil else {
                self.showError((error?.localizedDescription)!)
                return
            }
            
            guard let response = purchaseResponse else {
                self.showError((error?.localizedDescription)!)
                return
            }
            self.showSuccess("Ref: " + response.transactionIdentifier)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func payWithCard(){
        let payWithCard = PayWithCard(clientId: yourClientId, clientSecret: yourClientSecret,
                                      customerId: theCustomerId, description: paymentDescription,
                                      amount: theAmount, currency: "NGN")
        let vc = payWithCard.start({(purchaseResponse: PurchaseResponse?, error: Error?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedDescription)!
                self.showError(failureMsg)
                return
            }
            
            //Handling success
            self.showSuccess("Ref: " + response.transactionIdentifier)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func payWithWallet(){
        let payWithWallet = PayWithWallet(clientId: yourClientId, clientSecret: yourClientSecret,
                                          customerId: theCustomerId, description: paymentDescription,
                                          amount: theAmount, currency: "NGN")
        let vc = payWithWallet.start({(purchaseResponse: PurchaseResponse?, error: Error?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedDescription)!
                self.showError(failureMsg)
                return
            }
            
            //Handling success
            self.showSuccess("Ref: " + response.transactionIdentifier)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validateCard() {
        let validateCard = ValidateCard(clientId: yourClientId, clientSecret: yourClientSecret,
                                        customerId: theCustomerId)
        let vc = validateCard.start({(validateCardResponse: ValidateCardResponse?, error: Error?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            
            guard let response = validateCardResponse else {
                let failureMsg = (error?.localizedDescription)!
                self.showError(failureMsg)
                return
            }
            
            //Handling success
            let msg = response.message
            self.showSuccess(msg)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    let theToken = "5060990580000217499"       //This should be a valid token value that was stored after a previously successful payment
    
    func payWithToken(){
        let payWithToken = PayWithToken(clientId: yourClientId, clientSecret: yourClientSecret,
                                        customerId: theCustomerId, description: paymentDescription,
                                        amount: theAmount, token: theToken, currency: "NGN",
                                        expiryDate: "2004", cardType: theCardType, last4Digits: "7499")
        let vc = payWithToken.start({(purchaseResponse: PurchaseResponse?, error: Error?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedDescription)!
                self.showError(failureMsg)
                return
            }
            
            self.showSuccess("Ref: " + response.transactionIdentifier)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(_ message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccess(_ message: String){
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

