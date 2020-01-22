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
    
    let evv = try calClient.events.get(calendarId: "hanave.com_87j3qa2c4h2005a1qbmqinakss@group.calendar.google.com", eventId: "1uhvorh1h7i2169rp7kmh91t8o_20190803", queryParameters: nil).wait()
    
    print(evv.extendedProperties)
    
} catch {
    print(error)
}


//}


