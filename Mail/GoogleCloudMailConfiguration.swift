//
//  GoogleCloudMailConfiguration.swift
//  Core
//
//  Created by Adir Burke on 14/1/20.
//

import Foundation

public struct GoogleCloudMailConfiguration : GoogleCloudAPIConfiguration {
    public var scope: [GoogleCloudAPIScope]
    
    public var serviceAccount: String
    
    public var project: String?
    
    public init(scope: [GoogleCloudMailScope], serviceAccount : String, project: String?) {
        self.scope = scope
        self.serviceAccount = serviceAccount
        self.project = project
    }
    
    public static func `default`() -> GoogleCloudMailConfiguration {
        return GoogleCloudMailConfiguration(scope: [.fullAccess],
                                               serviceAccount: "default",
                                               project: nil)
    }
    
    
}

public enum GoogleCloudMailScope : GoogleCloudAPIScope {
    public var value: String {
        switch self {
        case .fullAccessLabels: return "https://www.googleapis.com/auth/gmail.labels"
        case .sendOnly: return "https://www.googleapis.com/auth/gmail.send"
        case .readOnly:return "https://www.googleapis.com/auth/gmail.readonly"
        case .composeOnly:return "https://www.googleapis.com/auth/gmail.compose"
        case .modify:return "https://www.googleapis.com/auth/gmail.modify"
        case .readMetadata:return "https://www.googleapis.com/auth/gmail.metadata"
        case .basicSettings:return "https://www.googleapis.com/auth/gmail.settings.basic"
        case .advancedSettings:return "https://www.googleapis.com/auth/gmail.settings.sharing"
        case .fullAccess:return "https://mail.google.com/"
        case .insert: return "https://www.googleapis.com/auth/gmail.insert"
        }

    }
    
    case fullAccessLabels
    case sendOnly
    case readOnly
    case composeOnly
    case modify
    case readMetadata
    case basicSettings
    case advancedSettings
    case fullAccess
    case insert
}
