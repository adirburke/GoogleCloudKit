//
//  main.swift
//  testingModules
//
//  Created by Adir Burke on 16/1/20.
//

import Foundation
import AsyncHTTPClient
import Core
import Storage
import NIO

let projectId = "zaraserver-213607"
let ev = MultiThreadedEventLoopGroup(numberOfThreads: 3)


do {
    let httpClient = HTTPClient(eventLoopGroupProvider: .shared(ev), configuration: .init(ignoreUncleanSSLShutdown: true))
    defer {
        try? httpClient.syncShutdown()
    }
    let cred = try GoogleCloudCredentialsConfiguration(projectId: projectId, credentialsFile: "cred.json")
//    let config = GoogleCloudGmailConfiguration(scope: [.FullAccess], serviceAccount: "AdirServer", project: projectId, subscription: "adir@hanave.com")
    
    let driveConfig = GoogleCloudDriveConfiguration(scope: [.Drive], serviceAccount: "AdirServer", project: projectId, subscription: "adir@hanave.com")
//    let gcClient = try GoogleCloudGmailClient(credentials: cred, gmailConfig: config, httpClient: httpClient, eventLoop: ev.next())
//    let w = try gcClient.labels.list(userId: "me").wait()
    
//    print(w.labels)
    let gdClient = try GoogleCloudDriveClient(credentials: cred, driveConfig: driveConfig, httpClient: httpClient, eventLoop: ev.next())
//    let s = try gdClient.files.list(queryParameters: nil).wait()
    let s = try gdClient.about.get(queryParameters: ["fields" : "*"]).wait()
    
    
//    print(s)
    print(s.maxImportSizes.first?.value)
} catch {
    print(error)
}


//}


