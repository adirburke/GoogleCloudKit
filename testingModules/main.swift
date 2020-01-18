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
//    let driveConfig = GoogleCloudDriveConfiguration(scope: [.Drive], serviceAccount: "AdirServer", project: projectId, subscription: nil)
//    let gcClient = try GoogleCloudGmailClient(credentials: cred, gmailConfig: config, httpClient: httpClient, eventLoop: ev.next())
//    let gdClient = try GoogleCloudDriveClient(credentials: cred, driveConfig: driveConfig, httpClient: httpClient, eventLoop: ev.next())

    let config = GoogleCloudCalendarConfiguration(scope: [.Calendar], serviceAccount: "AdirServer", project: projectId, subscription: "adir@hanave.com")
    let calClient = try GoogleCloudCalendarClient(credentials: cred, calendarConfig: config, httpClient: httpClient, eventLoop: ev.next())
    let s = try calClient.calendarList.list().wait()
    print(s)
    
} catch {
    print(error)
}


//}


