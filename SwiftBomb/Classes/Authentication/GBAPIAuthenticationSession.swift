//
//  GBAPIAuthenticationSession.swift
//  GBAPI
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

enum AuthenticationStage {
    case Idle
    case ReadyForUserRegCodeInput(regCode: String)
    case PollingForAPIKey
    case Authenticated(apiKey: String)
    case Failed(error: AuthenticationError)
}

enum AuthenticationError: ErrorType {
    case FailedToRetrieveRegCode
    case FailedToAuthenticateRegCode
    case AuthenticationPollingTimedOut
    case ResponseSerializationError
}

class GBAPIAuthenticationSession {
    
    private var requestFactory: GBAPIRequestFactory
    private var networkingManager: GBAPINetworkingManager
    private var authenticationStore: GBAPIAuthenticationStore
    private var apiKeyPollingTimer: NSTimer?
    private var apiPollingDirective: APIPollingDirective?
    private var authStageProgress: AuthenticationStage -> Void?
    
    init(requestFactory: GBAPIRequestFactory, networkingManager: GBAPINetworkingManager, authenticationStore: GBAPIAuthenticationStore) {
        self.requestFactory = requestFactory
        self.networkingManager = networkingManager
        self.authenticationStore = authenticationStore
        self.authStageProgress = {_ in
            return Void()
        }
    }
    
    func beginAuthenticationFlow(authStageProgress: AuthenticationStage -> Void) {
        
        self.authStageProgress = authStageProgress
        
        // make call to find the authentication "regCode". the user will be told to enter this into giantbomb.com/apple-tv
        let regCodeRequest = requestFactory.authenticationRegCodeRequest()
        networkingManager.performRequest(regCodeRequest) { result in
            
            switch result {
            case .Success(let responseData):
                
                // TODO: this is xml! :(
                self.apiPollingDirective = APIPollingDirective(xml: responseData as! NSData)
                
                if let regCode = self.apiPollingDirective?.regCode {
                    self.authStageProgress(.ReadyForUserRegCodeInput(regCode: regCode))
                    
                    self.apiKeyPollingTimer = NSTimer.scheduledTimerWithTimeInterval((self.apiPollingDirective?.retryInterval)!, target: self, selector: #selector(GBAPIAuthenticationSession.pollAPIKeyEndpoint), userInfo: nil, repeats: true)
                    self.apiKeyPollingTimer?.tolerance = 5
                    NSRunLoop.mainRunLoop().addTimer(self.apiKeyPollingTimer!, forMode: NSDefaultRunLoopMode)
                }
                
            case .Error:
                authStageProgress(.Failed(error: .ResponseSerializationError))
            }
            
        }
    }
    
    @objc func pollAPIKeyEndpoint(timer: NSTimer) {
        
        guard let regCode = self.apiPollingDirective?.regCode else {
            authStageProgress(.Failed(error: .FailedToRetrieveRegCode))
            return
        }
        
        if self.apiPollingDirective?.shouldGiveUp == true {
            authStageProgress(.Failed(error: .AuthenticationPollingTimedOut))
            self.apiKeyPollingTimer?.invalidate()
            self.apiKeyPollingTimer = nil
        }
        
        authStageProgress(.PollingForAPIKey)
        
        let apiKeyRequest = requestFactory.authenticationAPIKeyRequest(regCode)
        networkingManager.performRequest(apiKeyRequest) { result in
                        
            switch result {
            case .Success(let json):
                
                if json["status"] as? String == "success" {
                    
                    if let regToken = json["regToken"] as? String {
                        self.authenticationStore.apiKey = regToken
                        self.authStageProgress(.Authenticated(apiKey: regToken))
                        
                        self.apiKeyPollingTimer?.invalidate()
                        self.apiKeyPollingTimer = nil
                    }
                }
                
            case .Error:
                self.authStageProgress(.Failed(error: .FailedToAuthenticateRegCode))
            }
        }
    }
}

struct APIPollingDirective {
    
    enum Status: String {
        case Success = "success"
        case Failed
    }
    
    let status: Status
    var retryInterval: NSTimeInterval
    var retryDuration: NSTimeInterval
    var regCode: String?
    let creationDate: NSDate?
    var shouldGiveUp: Bool {
        get {
            return NSDate().timeIntervalSinceDate(creationDate!) > retryDuration
        }
    }
    
    init(xml: NSData) {
        
        let xmlString = NSString(data: xml, encoding: NSUTF8StringEncoding)
        
        creationDate = NSDate()
        
        let statusString = APIPollingDirective.stringFromTag(xmlString!, tag: "status")
        status = Status(rawValue: statusString)!
        
        let retryIntervalString = APIPollingDirective.stringFromTag(xmlString!, tag: "retryInterval")
        retryInterval = NSTimeInterval(retryIntervalString)!
        
        let retryDurationString = APIPollingDirective.stringFromTag(xmlString!, tag: "retryDuration")
        retryDuration = NSTimeInterval(retryDurationString)!
        
        regCode = APIPollingDirective.stringFromTag(xmlString!, tag: "regCode")
    }
    
    static func stringFromTag(xml: NSString, tag: NSString) -> String {
        
        let location = (xml.rangeOfString("<\(tag)>").location) + tag.length + 2
        let end = xml.rangeOfString("</\(tag)>").location
        return xml.substringWithRange(NSMakeRange(location, end-location))
        
    }
}