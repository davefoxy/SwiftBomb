//
//  AuthenticationSession.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

enum AuthenticationStage {
    case idle
    case readyForUserRegCodeInput(regCode: String)
    case pollingForAPIKey
    case authenticated(apiKey: String)
    case failed(error: AuthenticationError)
}

enum AuthenticationError: Error {
    case failedToRetrieveRegCode
    case failedToAuthenticateRegCode
    case authenticationPollingTimedOut
    case responseSerializationError
}

class AuthenticationSession {
    
    fileprivate var requestFactory: RequestFactory
    fileprivate var networkingManager: NetworkingManager
    fileprivate var authenticationStore: AuthenticationStore
    fileprivate var apiKeyPollingTimer: Timer?
    fileprivate var apiPollingDirective: APIPollingDirective?
    fileprivate var authStageProgress: (AuthenticationStage) -> Void?
    
    init(requestFactory: RequestFactory, networkingManager: NetworkingManager, authenticationStore: AuthenticationStore) {
        
        self.requestFactory = requestFactory
        self.networkingManager = networkingManager
        self.authenticationStore = authenticationStore
        self.authStageProgress = {_ in
            return Void()
        }
    }
    
    func beginAuthenticationFlow(_ authStageProgress: @escaping (AuthenticationStage) -> Void) {
        
        self.authStageProgress = authStageProgress
        
        // make call to find the authentication "regCode". the user will be told to enter this into giantbomb.com/apple-tv
        let regCodeRequest = requestFactory.authenticationRegCodeRequest()
        networkingManager.performRequest(regCodeRequest) { result in
            
            switch result {
            case .success(let responseData):
                
                // This is xml! :(
                self.apiPollingDirective = APIPollingDirective(xml: responseData as! Data)
                
                if let regCode = self.apiPollingDirective?.regCode {
                    self.authStageProgress(.readyForUserRegCodeInput(regCode: regCode))
                    
                    self.apiKeyPollingTimer = Timer.scheduledTimer(timeInterval: (self.apiPollingDirective?.retryInterval)!, target: self, selector: #selector(AuthenticationSession.pollAPIKeyEndpoint), userInfo: nil, repeats: true)
                    self.apiKeyPollingTimer?.tolerance = 5
                    RunLoop.main.add(self.apiKeyPollingTimer!, forMode: RunLoopMode.defaultRunLoopMode)
                }
                
            case .error:
                authStageProgress(.failed(error: .responseSerializationError))
            }
            
        }
    }
    
    @objc func pollAPIKeyEndpoint(_ timer: Timer) {
        
        guard let regCode = self.apiPollingDirective?.regCode else {
            authStageProgress(.failed(error: .failedToRetrieveRegCode))
            return
        }
        
        if self.apiPollingDirective?.shouldGiveUp == true {
            authStageProgress(.failed(error: .authenticationPollingTimedOut))
            self.apiKeyPollingTimer?.invalidate()
            self.apiKeyPollingTimer = nil
        }
        
        authStageProgress(.pollingForAPIKey)
        
        let apiKeyRequest = requestFactory.authenticationAPIKeyRequest(regCode)
        networkingManager.performRequest(apiKeyRequest) { result in
                        
            switch result {
            case .success(let json):
                
                if json["status"] as? String == "success" {
                    
                    if let regToken = json["regToken"] as? String {
                        self.authenticationStore.apiKey = regToken
                        self.authStageProgress(.authenticated(apiKey: regToken))
                        
                        self.apiKeyPollingTimer?.invalidate()
                        self.apiKeyPollingTimer = nil
                    }
                }
                
            case .error:
                self.authStageProgress(.failed(error: .failedToAuthenticateRegCode))
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
    var retryInterval: TimeInterval
    var retryDuration: TimeInterval
    var regCode: String?
    let creationDate: Date?
    var shouldGiveUp: Bool {
        get {
            return Date().timeIntervalSince(creationDate!) > retryDuration
        }
    }
    
    init(xml: Data) {
        
        let xmlString = NSString(data: xml, encoding: String.Encoding.utf8.rawValue)
        
        creationDate = Date()
        
        let statusString = APIPollingDirective.stringFromTag(xmlString!, tag: "status")
        status = Status(rawValue: statusString)!
        
        let retryIntervalString = APIPollingDirective.stringFromTag(xmlString!, tag: "retryInterval")
        retryInterval = TimeInterval(retryIntervalString)!
        
        let retryDurationString = APIPollingDirective.stringFromTag(xmlString!, tag: "retryDuration")
        retryDuration = TimeInterval(retryDurationString)!
        
        regCode = APIPollingDirective.stringFromTag(xmlString!, tag: "regCode")
    }
    
    static func stringFromTag(_ xml: NSString, tag: NSString) -> String {
        
        let location = (xml.range(of: "<\(tag)>").location) + tag.length + 2
        let end = xml.range(of: "</\(tag)>").location
        return xml.substring(with: NSMakeRange(location, end-location))
        
    }
}
