//
//  MailClient.swift
//  Core
//
//  Created by Adir Burke on 15/1/20.
//

import Foundation
import AsyncHTTPClient
import NIO

public final class MailClient {
    
    
    public init(credentials: GoogleCloudCredentialsConfiguration,
                config: GoogleCloudMailConfiguration,
                httpClient: HTTPClient,
                eventLoop: EventLoop) throws {
        let refreshtoken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: config, andClient: httpClient, eventLoop: eventLoop)
        
        
        guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
            (refreshtoken as? OAuthServiceAccount)?.credentials.projectId ??
            config.project ?? credentials.project else {
                throw MailError.projectIdMissing
        }
        
        
        let request = MailRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshtoken, project: projectId)
        
        
    }
}


public final class MailRequest : GoogleCloudAPIRequest {
    public var refreshableToken: OAuthRefreshable
    public var project: String
    public var httpClient: HTTPClient
    public var responseDecoder: JSONDecoder = JSONDecoder()
    public var currentToken: OAuthAccessToken?
    public var tokenCreatedTime: Date?
    private let eventLoop : EventLoop
    
    init(httpClient: HTTPClient, eventLoop: EventLoop, oauth: OAuthRefreshable, project: String) {
        self.refreshableToken = oauth
        self.project = project
        self.httpClient = httpClient
        self.eventLoop = eventLoop
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.responseDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
}


public enum MailError: GoogleCloudError {
    case projectIdMissing
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .projectIdMissing:
            return "Missing project id for Mail API. Did you forget to set your project id?"
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}
