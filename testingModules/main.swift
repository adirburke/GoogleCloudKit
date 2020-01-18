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
    let config = GoogleCloudGmailConfiguration(scope: [.FullAccess], serviceAccount: "AdirServer", project: projectId)
    let gcClient = try GoogleCloudGmailClient(credentials: cred, gmailConfig: config, httpClient: httpClient, eventLoop: ev.next(), withSubscription: "adir@hanave.com")
    let s = try gcClient.labels.list(userId: "me").wait()
    
    print(s.labels)
} catch {
    print(error)
}


//}


