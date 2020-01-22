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
    let gdClient = try GoogleCloudDriveClient(credentials: cred, driveConfig: driveConfig, httpClient: httpClient, eventLoop: ev.next())
    
    let tubeConfig = GoogleCloudYoutubeConfiguration(scope: [.Youtube], serviceAccount: "AdirServer", project: projectId, subscription: "adir@hanave.com")
    let ytClient = try GoogleCloudYoutubeClient(credentials: cred, youtubeConfig: tubeConfig, httpClient: httpClient, eventLoop: ev.next())
    let s = try ytClient.comments.list(part: "*", queryParameters: nil).wait()

//    let config = GoogleCloudCalendarConfiguration(scope: [.Calendar], serviceAccount: "AdirServer", project: projectId, subscription: "adir@hanave.com")
//    let calClient = try GoogleCloudCalendarClient(credentials: cred, calendarConfig: config, httpClient: httpClient, eventLoop: ev.next())
//    let s = try calClient.calendarList.list().wait()
//    for cal in s.items ?? [] {
//        print(cal.id)
//    }
//    let t = try calClient.calendars.get(calendarId: "hanave.com_87j3qa2c4h2005a1qbmqinakss@group.calendar.google.com", queryParameters: nil).wait()
//    print(t.id)
//    let e = try calClient.events.list(calendarId: "hanave.com_87j3qa2c4h2005a1qbmqinakss@group.calendar.google.com", queryParameters: nil).wait()
//    for ev in e.items ?? []{
//        print(ev.id)
//    }
//    let s = try gdClient.files.list(queryParameters: nil).wait()
//    for f in s.files ?? [] {
//    }
//
    
    

} catch {
    print(error)
}


//}


