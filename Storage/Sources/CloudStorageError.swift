//
//  CloudStorageError.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/21/18.
//

import Core
import Foundation

public enum GoogleCloudStorageError: GoogleCloudError {
    case projectIdMissing
    case unknownError(String)
    
    var localizedDescription: String {
        switch self {
        case .projectIdMissing:
            return "Missing project id for GoogleCloudStorage API. Did you forget to set your project id?"
        case .unknownError(let reason):
            return "An unknown error occured: \(reason)"
        }
    }
}
