//
//  main.swift
//  Discovery-cli-generate
//
//  Created by Adir Burke on 15/1/20.
//

import Foundation
import CodeGen

let path = "gmail.json"
let path2 = "storage.json"
let path3 = "drive.json"

let data = try Data(contentsOf: URL(fileURLWithPath: path3))
  let decoder = JSONDecoder()
  do {
    let service = try decoder.decode(DiscoveryService.self, from: data)
    print(service.GenerateCode())
    
//    service.name
  } catch {
    print(error)
    print(error.localizedDescription)
//    print("error \(error)\n")
  }





