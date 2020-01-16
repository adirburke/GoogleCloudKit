//
//  DiscoveryJSON.swift
//  DiscoveryCodeGen
//
//  Created by Adir Burke on 15/1/20.
//

import Foundation

public struct TestingTemp : Codable {}


public protocol GoogleCloudDiscoveryReferenceObject : Codable {}

public typealias Icons = [String : String]
public typealias GoogleCloudDiscoverySchemas = GoogleCloudDiscoveryParameters
public typealias GoogleCloudDiscoveryParametersProperties = GoogleCloudDiscoveryParameters
typealias GoogleCloudDiscoveryAuthProtocolScope = [String : String]



// Reference :
//      https://tools.ietf.org/html/draft-zyp-json-schema-03#section-5.1
public enum GoogleCloudDiscoveryJSONTypeEnum : String, Codable {
    case string
    case number
    case integer
    case boolean
    case object
    case array
    case null
    case any
    
    func toSwiftParameterName(_ itemType : String? = nil) -> String {
        switch self {
            
        case .string: return "String"
        case .number: return "Double"
        case .integer: return "Int"
        case .boolean: return "Bool"
        case .object: return "PlaceHolderObject"
        case .array: return "[\(itemType?.makeSwiftSafe() ?? "")]"
        case .null: return "String?"
        case .any: return "Any"
        @unknown default: return "Any"
        }
    }
    func itemType() -> String {
        ""
    }
    
    //MARK:- Need to do some type converstions and stuff
}




public class GoogleCloudDiscoveryParameters : Codable {
    public  var id : String?
    public  var type : GoogleCloudDiscoveryJSONTypeEnum?
    public  var ref : String?
    public  var description : String?
    public  var `default` : String?
    public  var required : Bool?
    public  var format : String?
    public  var pattern : String?
    public  var minimum : String?
    public  var maximum : String?
    public  var `enum` : [String]?
    public  var enumDescriptions : [String]?
    public  var repeated : Bool?
    public  var location : String?
    public  var properties : [String : GoogleCloudDiscoveryParametersProperties]?
    public  var additionalProperties : [String: String]?
    public  var items : GoogleCloudDiscoveryParameters?
    public  var annotations : GoogleCloudDiscoveryParametersAnnotations?
    
    enum CodingKeys : String, CodingKey {
        case id
        case type
        case ref = "$ref"
        case description
        case `default`
        case required
        case format
        case pattern
        case minimum
        case maximum
        case `enum`
        case enumDescriptions
        case repeated
        case location
        case properties
        case additionalProperties
        case items
        case annotations
    }
    
    public func printPretty() {
        let mirror = Mirror(reflecting: self)
        for (f,v) in mirror.children {
            print(f,v)
        }
    }
    
    public func toType() -> String {
        if let ref = items?.ref {
            return self.type?.toSwiftParameterName(ref) ?? ""
        } else {
            return self.type?.toSwiftParameterName(items?.type?.toSwiftParameterName()) ?? ""
        }
        
    }
    
}



struct GoogleCloudDiscoveryAuthProtocol : Codable {
    var scopes : [String : GoogleCloudDiscoveryAuthProtocolScope]
}


public class GoogleCloudDiscoveryAuth : Codable {
    var oauth2 : GoogleCloudDiscoveryAuthProtocol
}

public protocol APIable {
    var resources: [String : GoogleCloudDiscoveryResources]? { get }
}

public class DiscoveryService : Codable, APIable {
    public var baseUrl: String?
    public var basePath: String?
    public var servicePath: String
    public var batchPath: String
    public var kind: String
    public var discoveryVersion: String
    public var id: String
    public var name: String
    public var version: String
    public var revision: String
    public var title: String
    public var description: String
    public var icons: Icons
    public var documentationLink: String
    public var labels: [String]?
    public var `protocol`: String
    public var rootUrl: String
    public var parameters: [String : GoogleCloudDiscoveryParameters]
    public var auth: GoogleCloudDiscoveryAuth
    public var features: [String]?
    public var schemas: [String : GoogleCloudDiscoverySchemas]
    public var methods: [String : GoogleCloudDiscoveryMethods]?
    public var resources: [String : GoogleCloudDiscoveryResources]?
    
    
    var apiList : [String]? = []
}

public typealias GoogleCloudDiscoveryMethodScope = [String]


// MARK: - TODO
public struct GoogleCloudDiscoveryMethods : Codable {
 public var id : String?
 public var type : GoogleCloudDiscoveryJSONTypeEnum?
    public var path : String?
 public var httpMethod : String?
 public var description : String?
 public var parameters: [String : GoogleCloudDiscoveryParameters]?
 public var parameterOrder : [String]?
 public var request : GoogleCloudDiscoveryMethodRequest?
 public var response : GoogleCloudDiscoveryMethodResponse?
 public var scopes : GoogleCloudDiscoveryMethodScope?
 public var supportsMediaDownload : Bool?
 public var supportsMediaUpload : Bool?
 public var mediaUpload : GoogleCloudDiscoveryMethodMedia?
 public var supportsSubscription : Bool?
 public var flatPath : String?
    
    public func printPretty() {
        let mirror = Mirror(reflecting: self)
        for (f,v) in mirror.children {
            print(f,v)
        }
    }
    
}
public struct GoogleCloudDiscoveryResources : Codable, APIable {
//    public var resources: [String : GoogleCloudDiscoveryResources]
    
    public var methods: [String : GoogleCloudDiscoveryMethods]?
    public var resources : [String : GoogleCloudDiscoveryResources]?
}
public struct GoogleCloudDiscoveryParametersAnnotations : Codable {}
public struct GoogleCloudDiscoveryMethodRequest : Codable {
    public var reference : String
    enum CodingKeys : String, CodingKey {
        case reference = "$ref"
    }
}
public typealias GoogleCloudDiscoveryMethodResponse = GoogleCloudDiscoveryMethodRequest
public struct GoogleCloudDiscoveryMethodMedia : Codable {
    public var accept : [String]?
    public var maxSize : String?
    public var protocols: [String : GoogleCloudDiscoveryMediaUploadProtocol]?
}
public class GoogleCloudDiscoveryMediaUploadProtocol : Codable {
  public var multipart : Bool?
  public var path : String?
}
