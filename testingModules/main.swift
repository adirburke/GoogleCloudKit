//
//  main.swift
//  testingModules
//
//  Created by Adir Burke on 16/1/20.
//

import Foundation
import AsyncHTTPClient
import Core

print("Hello, World!")

let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
let gcClient = try GoogleCloudGmailClient()
