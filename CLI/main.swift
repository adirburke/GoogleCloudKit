//
//  main.swift
//  Discovery-cli-generate
//
//  Created by Adir Burke on 15/1/20.
//

import Foundation
import CodeGen

var testing = [(String, String)]()

testing.append(( "gmail.json", "Core/Sources/TestCodeGen.swift"))
testing.append(( "storage.json", "Core/Sources/StorageCodeGen.swift"))
testing.append((  "drive.json", "Core/Sources/DriveTestGen.swift"))
testing.append((  "calendar.json", "Core/Sources/CalTestGen.swift"))
testing.append((  "youtube.json", "Core/Sources/YTTestGen.swift"))
testing.append((  "discovery.json", "Core/Sources/DiscoveryTestGen.swift"))

for (i, o) in testing {

let data = try Data(contentsOf: URL(fileURLWithPath: i))
  let decoder = JSONDecoder()
  do {
    let service = try decoder.decode(DiscoveryService.self, from: data)
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: o) {
        do {
            try "".write(toFile: o, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
    } else {
        fileManager.createFile(atPath: o, contents: nil, attributes: nil)
    }
    if let fileHandle = FileHandle(forWritingAtPath: o) {
        print("Starting \(service.name)")
        fileHandle.write(service.GenerateCode().data(using: .utf8) ?? Data())
        fileHandle.closeFile()
    }
//    print(service.GenerateCode())
    
//    service.name
  } catch {
    print(error)
    print(error.localizedDescription)
//    print("error \(error)\n")
  }
}





