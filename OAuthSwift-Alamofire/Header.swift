//
//  Header.swift
//  OAuthSwift-Alamofire
//
//  Created by phimage on 07/01/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift

public extension NSMutableURLRequest {

    public func addOAuthHeaderWithCredential(credential: OAuthSwiftCredential, parameters: [String: AnyObject] = [:]) {
        let headers = credential.makeHeaders(self.URL ?? NSURL(), method: OAuthSwiftHTTPRequest.Method(rawValue: self.HTTPMethod) ?? .GET, parameters: parameters)
        for (field, value) in headers {
            self.setValue(value, forHTTPHeaderField: field)
        }
    }

    public func addOAuthHeader(oauth: OAuthSwift, parameters: [String: AnyObject] = [:]) {
        self.addOAuthHeaderWithCredential(oauth.client.credential, parameters: parameters)
    }

}

extension OAuth2Swift {
    
    // Create an Alamofire manager with preconfigured oauth authentification headers
    // Authentification must be done before calling this method.
    public func manager(sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration(), manager: Alamofire.Manager = Alamofire.Manager.sharedInstance) -> Manager  {
        var defaultHeaders = manager.session.configuration.HTTPAdditionalHeaders ?? [:]
        
        let credential = self.client.credential
        assert(!credential.oauth_token.isEmpty)
        defaultHeaders += credential.makeHeaders(NSURL(), method: .GET, parameters: [:])
        
        let configuration = sessionConfiguration
        configuration.HTTPAdditionalHeaders = defaultHeaders
        return Alamofire.Manager(configuration: configuration)
    }
    
}