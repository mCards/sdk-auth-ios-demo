//
//  ViewController.swift
//  AuthSDKDemo
//
//  Created by Mukhtar Yusuf on 1/20/25.
//

import UIKit
import CoreSDK
import AuthSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAuthSDK()
    }

    private func setupAuthSDK() {
        let auth0ClientID = "DL8XpUmzegVl9dR8QpO9djDifTY7nGyd"
        let auth0Domain = "mcards-test.au.auth0.com"
        let auth0Audience = "https://staging.mcards.com/api"
        let args = Auth0Args(
            auth0ClientID: auth0ClientID,
            auth0Domain: auth0Domain,
            auth0Audience: auth0Audience)
        
        AuthSdkProvider.shared.configure(args: args)
        
        // TODO: Set logging settings
    }
    
    private func login() {
        let savedPhoneNumber = ""
        let regionCode: RegionCode? = nil
        let deepLink: DeepLink? = nil
        
        /* 
         Provide the dynamic link url from a firebase dynamic link e.g.
         
         let dynamicLink: DynamicLink
         deepLink = DeepLink(dynamicLinkURL: dynamicLink.url)
         */
        
        let loginArgs = LoginArgs(
            savedPhoneNumber: savedPhoneNumber,
            regionCode: regionCode,
            deepLink: deepLink)
        
        AuthSdkProvider.shared.login(args: loginArgs) { [weak self] result in
            switch result {
            case .success(let authSuccess):
                // Get any required data
                let accessToken = authSuccess.jwts.accessToken
                let userPhoneNumber = authSuccess.user.phoneNumber
                
                // Start using the SDK
                self?.getUserProfileMetadata()
            case .failure(let error):
                // Handle error
                print(error.localizedDescription)
            }
        }
    }
    
    private func getUserProfileMetadata() {
        AuthSdkProvider.shared.getUserProfileMetadata { result in
            switch result {
            case .success(let profileMetaData):
                // Use profile metadata
                let requiresAddress = profileMetaData.cardHolderAddressRequired
                print("Requires address: \(requiresAddress)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func logout() {
        let logoutResult = AuthSdkProvider.shared.logout()
        let logoutMessage = logoutResult ? "Success" : "Failure"
        print("Logout result: \(logoutMessage)")
    }
    
    @IBAction func tappedLogin(_ sender: Any) {
        login()
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        logout()
    }
}

