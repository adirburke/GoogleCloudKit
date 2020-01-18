//
//  File.swift
//  
//
//  Created by Andrew Edwards on 8/4/19.
//

import Foundation
import NIO
import AsyncHTTPClient

/// Loads credentials from `~/.config/gcloud/application_default_credentials.json`
public struct GoogleApplicationDefaultCredentials: Codable {
    public let clientId: String
    public let clientSecret: String
    public let refreshToken: String
    public let type: String
    
    public init(fromFilePath path: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let contents = try String(contentsOfFile: path).data(using: .utf8) {
//            print(String(data: contents, encoding: .utf8))
            self = try decoder.decode(GoogleApplicationDefaultCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError(path)
        }
    }

    public init(fromJsonString json: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = json.data(using: .utf8) {
            self = try decoder.decode(GoogleApplicationDefaultCredentials.self, from: data)
        } else {
            throw CredentialLoadError.jsonLoadError
        }
    }
}

/// Loads credentials from a file specified in the `GOOGLE_APPLICATION_CREDENTIALS` environment variable
public struct GoogleServiceAccountCredentials: Codable {
    public let type: String
    public let projectId: String
    public let privateKeyId: String
    public let privateKey: String
    public let clientEmail: String
    public let clientId: String
    public let authUri: URL
    public let tokenUri: URL
    public let authProviderX509CertUrl: URL
    public let clientX509CertUrl: URL
    
//    public let subscription : String ?
    
    
    public init(fromFilePath path: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let contents = try String(contentsOfFile: path).data(using: .utf8) {
            self = try decoder.decode(GoogleServiceAccountCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError(path)
        }
    }
    
    public init(fromJsonString json: String) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let data = json.data(using: .utf8) {
            
            self = try decoder.decode(GoogleServiceAccountCredentials.self, from: data)
        } else {
            throw CredentialLoadError.jsonLoadError
        }
    }
}

public class OAuthCredentialLoader {
    public static func getRefreshableToken(credentials: GoogleCloudCredentialsConfiguration,
                                           withConfig config: GoogleCloudAPIConfiguration,
                                           andClient client: HTTPClient,
                                           eventLoop: EventLoop,
                                           withSubscription sub: String?) -> OAuthRefreshable {
        
        // Check Service account first.
        if let serviceAccount = credentials.serviceAccountCredentials {
            return OAuthServiceAccount(credentials: serviceAccount,
                                       scopes: config.scope,
                                       httpClient: client,
                                       eventLoop: eventLoop, subscription: sub)
        }
        
        // Check Default application credentials next.
        if let appDefaultCredentials = credentials.applicationDefaultCredentials {
            return OAuthApplicationDefault(credentials: appDefaultCredentials,
                                           httpClient: client,
                                           eventLoop: eventLoop)
        }

        // If neither work assume we're on GCP infrastructure.
        return OAuthComputeEngineAppEngineFlex(serviceAccount: config.serviceAccount,
                                               httpClient: client,
                                               eventLoop: eventLoop)
    }
}
