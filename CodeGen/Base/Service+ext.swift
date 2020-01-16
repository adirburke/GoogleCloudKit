//
//  Service+ext.swift
//  DiscoveryCodeGen
//
//  Created by Adir Burke on 15/1/20.
//

import Foundation

extension DiscoveryService {
    var capName : String {
        return name.capitalized()
    }
    
    func addLicense() -> String {
        return "// This is Generated Code\n\n\n"
    }
    func addImports() -> String {
        var returnString = ""
        let listofImports = [ "Foundation" , "AsyncHTTPClient", "NIO", "Core", "NIOFoundationCompat", "NIOHTTP1"]
        for i in listofImports {
            returnString += "import \(i)\n"
        }
        returnString += "\n\n"
        return returnString
    }
    
    
    fileprivate func cleanUpScopeName(_ scope: String) -> String {
        let something = scope.range(of: "/", options: .backwards)?.upperBound
        //        var substring = substring
        var substring = String(scope[something!...])
        //            print(scope, substring)
        var s = ""
        if substring.count > 4 {
            s = String(substring.dropLast(substring.count - 4))
        } else {
            s = substring
        }
//        print(s, substring, scope)
        if s == "com/" || s == "" { substring = "fullAccess" }
        
        substring = substring.replacingOccurrences(of: ".", with: "_")
        substring = substring.replacingOccurrences(of: "-", with: "_")
        substring = substring.components(separatedBy: "_").map {$0.capitalized()}.joined(separator: "")
        return substring
    }
    
    func createCloudScope() -> String {
        var returnString = ""
        returnString.addLine("public enum GoogleCloud\(capName)Scope : GoogleCloudAPIScope {")
        returnString.addLine("public var value : String {", with: 1)
        returnString.addLine("switch self {", with: 2)
        
        var laterString = ""
        for (scope, description) in self.auth.oauth2.scopes {
            let substring = cleanUpScopeName(scope)
            returnString.addLine("case .\(substring): return \"\(scope)\"", with: 2)
            laterString.addLine("case \(substring) // \(description["description"]!)", with: 1)
        }
        returnString.addLine("}", with: 2)
        returnString.addLine("}", with: 1)
        returnString.addLine()
        
        laterString.addLine("}", with: 0)
        laterString.addLine()
        laterString.addLine()
        
        return  returnString + laterString
        
    }
    
    func createCloudConfig() -> String {
        var returnString = ""
        
        returnString.addLine("public struct GoogleCloud\(capName)Configuration : GoogleCloudAPIConfiguration {")
        returnString.addLine("public var scope : [GoogleCloudAPIScope]", with: 1)
        returnString.addLine("public var serviceAccount: String", with: 1)
        returnString.addLine("public var project: String?", with: 1)
        returnString.addLine()
        returnString.addLine("public init(scope: [GoogleCloud\(capName)Scope], serviceAccount : String, project: String?) {", with: 1)
        returnString.addLine("self.scope = scope", with: 2)
        returnString.addLine("self.serviceAccount = serviceAccount", with: 2)
        returnString.addLine("self.project = project", with: 2)
        returnString.addLine("}", with: 1)
        returnString.addLine("}", with: 0)
        returnString.addLine()
        returnString.addLine()
        
        return returnString
    }
    
    func createError() -> String {
        var gc = ""
        gc.addLine("public enum GoogleCloud\(capName)Error: GoogleCloudError {", with: 0)
        gc.addLine("case projectIdMissing", with: 1)
        gc.addLine("case unknownError(String)", with: 1)
        gc.addLine()
        gc.addLine("var localizedDescription: String {", with: 1)
        gc.addLine("switch self {", with: 2)
        gc.addLine("case .projectIdMissing:", with: 2)
        gc.addLine("return \"Missing project id for \(capName) API. Did you forget to set your project id?\"", with: 3)
        gc.addLine("case .unknownError(let reason):", with: 2)
        gc.addLine("return \"An unknown error occured: \\(reason)\"", with: 3)
        gc.addLine("}", with: 2)
        gc.addLine("}", with: 1)
        gc.addLine("}", with: 0)
        
        return gc
    }
    
    func createRequest() -> String {
        var gc = ""
        
        gc.addLine("public final class GoogleCloud\(capName)Request : GoogleCloudAPIRequest {", with: 0)
        gc.addLine("public var refreshableToken: OAuthRefreshable", with: 1)
        gc.addLine("public var project: String", with: 1)
        gc.addLine("public var httpClient: HTTPClient", with: 1)
        gc.addLine("public var responseDecoder: JSONDecoder = JSONDecoder()", with: 1)
        gc.addLine("public var currentToken: OAuthAccessToken?", with: 1)
        gc.addLine("public var tokenCreatedTime: Date?", with: 1)
        gc.addLine("private let eventLoop : EventLoop", with: 1)
        gc.addLine()
        gc.addLine("init(httpClient: HTTPClient, eventLoop: EventLoop, oauth: OAuthRefreshable, project: String) {", with: 1)
        gc.addLine("self.refreshableToken = oauth", with: 2)
        gc.addLine("self.project = project", with: 2)
        gc.addLine("self.httpClient = httpClient", with: 2)
        gc.addLine("self.eventLoop = eventLoop", with: 2)
        gc.addLine("let dateFormatter = DateFormatter()", with: 2)
        gc.addLine("dateFormatter.dateFormat = \"yyyy-MM-dd'T'HH:mm:ss.SSSZ\"", with: 2)
        gc.addLine("self.responseDecoder.dateDecodingStrategy = .formatted(dateFormatter)", with: 2)
        gc.addLine("}", with: 1)
        
        gc.addLine("public func send<GCM: GoogleCloudModel>(method: HTTPMethod, headers: HTTPHeaders = [:], path: String, query: String = \"\", body: HTTPClient.Body = .data(Data())) -> EventLoopFuture<GCM> {", with: 1)
        gc.addLine("return withToken { token in", with: 2)
        gc.addLine("return self._send(method: method, headers: headers, path: path, query: query, body: body, accessToken: token.accessToken).flatMap { response in", with: 3)
        gc.addLine("do {", with: 4)
        gc.addLine("if GCM.self is GoogleCloudDataResponse.Type {", with: 5)
        gc.addLine("let model = GoogleCloudDataResponse(data: response) as! GCM", with: 6)
        gc.addLine("return self.eventLoop.makeSucceededFuture(model)", with: 6)
        gc.addLine("} else {", with: 5)
        gc.addLine("let model = try self.responseDecoder.decode(GCM.self, from: response)", with: 6)
        gc.addLine("return self.eventLoop.makeSucceededFuture(model)", with: 6)
        gc.addLine("}", with: 5)
        gc.addLine("} catch {", with: 4)
        gc.addLine("return self.eventLoop.makeFailedFuture(error)", with: 5)
        gc.addLine("}", with: 4)
        gc.addLine("}", with: 3)
        gc.addLine("}", with: 2)
        gc.addLine("}", with: 1)
        gc.addLine()
        gc.addLine("private func _send(method: HTTPMethod, headers: HTTPHeaders, path: String, query: String, body: HTTPClient.Body, accessToken: String) -> EventLoopFuture<Data> {", with: 1)
        gc.addLine("var _headers: HTTPHeaders = [\"Authorization\": \"Bearer \\(accessToken)\",", with: 2)
        gc.addLine("\"Content-Type\": \"application/json\"]", with: 8)
        gc.addLine("headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }", with: 2)
        gc.addLine("do {", with: 2)
        gc.addLine("let request = try HTTPClient.Request(url: \"\\(path)?\\(query)\", method: method, headers: _headers, body: body)", with: 3)
        gc.addLine()
        gc.addLine("return httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).flatMap { response in", with: 3)
        gc.addLine("// If we get a 204 for example in the delete api call just return an empty body to decode.", with: 4)
        gc.addLine("// https://cloud.google.com/s/results/?q=If+successful%2C+this+method+returns+an+empty+response+body.&p=%2Fstorage%2Fdocs%2F", with: 4)
        gc.addLine("if response.status == .noContent {", with: 4)
        gc.addLine("return self.eventLoop.makeSucceededFuture(\"{}\".data(using: .utf8)!)", with: 5)
        gc.addLine("}", with: 4)
        gc.addLine("guard var byteBuffer = response.body else {", with: 4)
        gc.addLine("fatalError(\"Response body from Google is missing! This should never happen.\")", with: 5)
        gc.addLine("}", with: 4)
        gc.addLine("let responseData = byteBuffer.readData(length: byteBuffer.readableBytes)!", with: 4)
        gc.addLine("guard (200...299).contains(response.status.code) else {", with: 5)
        gc.addLine("let error: Error", with: 5)
        gc.addLine("if let jsonError = try? self.responseDecoder.decode(GoogleCloudAPIErrorMain.self, from: responseData) {", with: 5)
        gc.addLine("error = jsonError", with: 6)
        gc.addLine("} else {", with: 5)
        gc.addLine("let body = response.body?.getString(at: response.body?.readerIndex ?? 0, length: response.body?.readableBytes ?? 0) ?? \"\"", with: 6)
        gc.addLine("error = GoogleCloudAPIErrorMain(error: GoogleCloudAPIErrorBody(errors: [], code: Int(response.status.code), message: body))", with: 6)
        gc.addLine("}", with: 5)
        gc.addLine("return self.eventLoop.makeFailedFuture(error)", with: 5)
        gc.addLine("}", with: 4)
        gc.addLine("return self.eventLoop.makeSucceededFuture(responseData)", with: 4)
        gc.addLine("}", with: 3)
        gc.addLine("} catch {", with: 2)
        gc.addLine("return self.eventLoop.makeFailedFuture(error)", with: 3)
        gc.addLine("}", with: 2)
        gc.addLine("}", with: 1)
        
        gc.addLine("}", with: 0)
        
        return gc
    }
    
    
    fileprivate func getMethodParams(_ m: (key: String, value: GoogleCloudDiscoveryMethods)) -> String {
        var funcParm = ""
        for order in m.value.parameterOrder ?? [] {
            if let parm = m.value.parameters?[order] {
                funcParm += "\(order.makeSwiftSafe()) : \(parm.type!.toSwiftParameterName()), "
            }
        }
        return funcParm
    }
    
    func insertQueryBlock(baseIndent: Int) -> String {
        
        var gc = ""
        gc.addLine("var queryParams = \"\"", with: baseIndent)
        gc.addLine("if let queryParameters = queryParameters {", with: baseIndent)
        gc.addLine("queryParams = queryParameters.queryParameters", with: baseIndent + 1)
        gc.addLine("}", with: baseIndent)
        return gc
    }
    
    fileprivate func createPathAndSwiftSafe(_ m: (key: String, value: GoogleCloudDiscoveryMethods))  -> String {
        var path = m.value.path ?? ""
        for p in m.value.parameterOrder ?? []  {
            if p != p.makeSwiftSafe() {
                if let index = path.range(of: p) {
                    path.replaceSubrange(index, with: p.makeSwiftSafe())
                }
            }
        }
        path = path.replacingOccurrences(of: "{", with: "\\(")
        path = path.replacingOccurrences(of: "}", with: ")")
        
        return path
    }
    
    func createAPI(s : APIable, ident: Int = 0) -> String {
        let endPoint = self.baseUrl ?? ""
        
        
        var gc = ""
        var later = ""
        for r in s.resources?.sorted(by: { $0.key < $1.key}) ?? [] {
            
            var apiName = r.key
            apiName = apiName.capitalized().makeSwiftSafe()
            gc.addLine("public protocol \(apiName)APIProtocol  {} ")
            apiList?.append("\(apiName)APIProtocol")
            gc.addLine("public final class GoogleCloud\(capName)\(apiName)API : \(apiName)APIProtocol {")
            gc.addLine("let endpoint = \"\(endPoint)\"", with: 1)
            gc.addLine("let request : GoogleCloud\(capName)Request", with: 1)
            gc.addLine()
            gc.addLine("init(request: GoogleCloud\(capName)Request) {", with: 1)
            gc.addLine("self.request = request", with: 2)
            gc.addLine("}", with: 1)
            gc.addLine()
            
            later += createAPI(s: r.value, ident: ident + 1)
            for m in r.value.methods?.sorted(by: { $0.key < $1.key }) ?? [] {
                
                let methodName = m.key.makeSwiftSafe()
                let funcParm = getMethodParams(m)
                var responseValue = m.value.response?.reference.makeSwiftSafe() ?? "EmptyResponse"
                responseValue = "GoogleCloud\(capName)\(responseValue.makeSwiftSafe())"
                var requestValue = ""
                var requestRequired = false
                if let request = m.value.request?.reference.makeSwiftSafe() {
                    requestRequired = true
                    requestValue = "body : GoogleCloud\(capName)\(request.makeSwiftSafe()),"
                }
                
                gc.addLine("public func \(methodName)(\(funcParm)\(requestValue) queryParameters: [String: String]?) -> EventLoopFuture<\(responseValue)> {", with: 1)
                gc += insertQueryBlock(baseIndent: 2)
                //                gc.addLine("do {", with: 2)
                var path = createPathAndSwiftSafe(m)
                //                b/\(bucket)/o/{object}
                if requestRequired {
                    gc.addLine("do {", with: 2)
                    gc.addLine("let data = try JSONEncoder().encode(body)", with: 3)
                    gc.addLine("return request.send(method: .\(m.value.httpMethod ?? ""), path: \"\\(endpoint)/\(path)\", query: queryParams, body: .data(data))", with: 3)
                    gc.addLine("} catch {", with: 2)
                    gc.addLine("return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)", with: 3)
                    gc.addLine("}",with: 1)
                } else {
                    gc.addLine("return request.send(method: .\(m.value.httpMethod ?? ""), path: \"\\(endpoint)/\(path)\", query: queryParams)", with: 2)
                }
                gc.addLine("}", with: 1)
                
                //                print(m.value)
                //                m.value.printPretty()
            }
            gc.addLine("}", with: 0)
            gc.addLine()
            
        }
        
        return gc + later
    }
    
    func createSmallModel(modelName : String, name : String,  props : [(key: String, value: GoogleCloudDiscoveryParametersProperties)]) -> String {
        var gc = ""
        gc.addLine("public struct GoogleCloud\(capName)\(modelName)\(name) : GoogleCloudModel {")
        for p in props {
            let propertyNameSafe = p.key.makeSwiftSafe()
            //            let propertyNameSafeCap = p.key.capitalized().makeSwiftSafe()
            if p.value.type == nil {
                if let reference = p.value.ref {
                    gc.addLine("public var \(propertyNameSafe):  GoogleCloud\(capName)\(reference)", with: 1)
                }
            } else {
                gc.addLine("public var \(propertyNameSafe): \(p.value.toType())", with: 1)
            }
        }
        gc.addLine("}", with: 0)
        return gc
    }
    
    
    
    func createModels() -> String {
        var gc = "public struct PlaceHolderObject : GoogleCloudModel {}\npublic struct GoogleCloud\(capName)EmptyResponse : GoogleCloudModel {}\n"
        var later = ""
        for schema in schemas.sorted(by: { $0.key < $1.key }) {
            
            let modelName = schema.key.makeSwiftSafe()
            //            print(modelName)
            gc.addLine("public struct GoogleCloud\(capName)\(modelName) : GoogleCloudModel {")
            for p in schema.value.properties?.sorted(by: {$0.key < $1.key}) ?? [] {
                //                print(p.key, p.value)
                let propertyNameSafe = p.key.makeSwiftSafe()
                let propertyNameSafeCap = p.key.capitalized().makeSwiftSafe()
                switch p.value.type {
                case .object:
                    
                    let something = p.value.properties?.sorted(by: {$0.key < $1.key}) ?? []
                    later += createSmallModel(modelName: modelName, name: propertyNameSafeCap, props: something)
                    gc.addLine("public var \(propertyNameSafe): GoogleCloud\(capName)\(modelName)\(propertyNameSafeCap)", with: 1)
                case .array:
                    if let items = p.value.items {
                        switch items.type {
                        case .object:
                            
                            later += createSmallModel(modelName: modelName, name: propertyNameSafeCap, props: items.properties?.sorted(by: {$0.key < $1.key}) ?? [])
                            gc.addLine("public var \(propertyNameSafe): [GoogleCloud\(capName)\(modelName)\(propertyNameSafeCap)]", with: 1)
                        case .array:
                            gc.addLine("public var \(propertyNameSafe): [GoogleCloud\(capName)\(p.value.toType().dropFirst())", with: 1)
                        default:
                            let type = p.value.toType()
                            
                            if let _ = GoogleCloudDiscoveryJSONTypeEnum(rawValue: type.lowercased().replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")) {
                                gc.addLine("public var \(propertyNameSafe): \(p.value.toType())", with: 1)
                            } else {
                                gc.addLine("public var \(propertyNameSafe): [GoogleCloud\(capName)\(p.value.toType().dropFirst())", with: 1)
                            }
                        }
                    }
                default:
                    if p.value.type == nil {
                        if let reference = p.value.ref {
                            gc.addLine("public var \(propertyNameSafe):  GoogleCloud\(capName)\(reference.makeSwiftSafe())", with: 1)
                        }
                    } else {
                        gc.addLine("public var \(propertyNameSafe): \(p.value.toType())", with: 1)
                    }
                }
                
            }
            gc.addLine("}", with: 0)
            
            
        }
        
        
        return gc + later
    }
    
    func addClientParams(withIndent indent: Int = 1) -> (String, String) {
        var gc = ""
        var assignment = ""
        for api in apiList ?? [] {
            let varString = String(api.dropLast(11)).lowercaseFirst()
            let funcString = String(api.dropLast(8))
            gc.addLine("public var \(varString) : \(api)", with: indent)
            assignment.addLine("\(varString) = GoogleCloud\(capName)\(funcString)(request: request)", with: 2)
        }
        gc.addLine()
        return (gc, assignment)
    }
    
    func createClient() -> String {
        var gc = ""
        gc.addLine("public final class GoogleCloud\(capName)Client {", with: 0)
        let (returnValue, later) = addClientParams()
        gc += returnValue
        gc.addLine()
        gc.addLine("public init(credentials: GoogleCloudCredentialsConfiguration, \(name)Config: GoogleCloud\(capName)Configuration, httpClient: HTTPClient, eventLoop: EventLoop) throws {", with: 1)
        gc.addLine("let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: \(name)Config, andClient: httpClient, eventLoop: eventLoop)", with: 2)
        gc.addLine("guard let projectId = ProcessInfo.processInfo.environment[\"PROJECT_ID\"] ??", with: 2)
        gc.addLine("(refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??", with: 5)
        gc.addLine("\(name)Config.project ?? credentials.project else {", with: 5)
        gc.addLine("throw GoogleCloud\(capName)Error.projectIdMissing", with: 3)
        gc.addLine("}", with: 2)
        gc.addLine()
        gc.addLine("let request = GoogleCloud\(capName)Request(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)", with: 2)
        gc.addLine()
        gc.addLine()
        gc += later
         gc.addLine("}", with: 1)
        gc.addLine("}", with: 0)
        gc.addLine()
        
        
        return gc
    }
    
    public func GenerateCode() -> String {
        var generatedCode = ""
        self.apiList = []
        generatedCode += addLicense()
        generatedCode += addImports()
        generatedCode += createCloudScope()
        generatedCode += createCloudConfig()
        generatedCode += createError()
        generatedCode += createRequest()
        generatedCode += createAPI(s: self)
        generatedCode += createModels()
        generatedCode += createClient()
        
        return generatedCode
    }
}



/*
 
 
 public struct GoogleCloudStorgeDataResponse: GoogleCloudModel {
 public var data: Data?
 }
 
 /// [Reference](https://cloud.google.com/storage/docs/json_api/v1/status-codes)
 public struct CloudStorageAPIError: GoogleCloudError, GoogleCloudModel {
 /// A container for the error information.
 public var error: CloudStorageAPIErrorBody
 }
 
 public struct CloudStorageAPIErrorBody: Codable {
 /// A container for the error details.
 public var errors: [CloudStorageError]
 /// An HTTP status code value, without the textual description.
 public var code: Int
 /// Description of the error. Same as `errors.message`.
 public var message: String
 }
 
 
 public struct CloudStorageError: Codable {
 /// The scope of the error. Example values include: global, push and usageLimits.
 public var domain: String?
 /// Example values include invalid, invalidParameter, and required.
 public var reason: String?
 /// Description of the error.
 /// Example values include Invalid argument, Login required, and Required parameter: project.
 public var message: String?
 /// The location or part of the request that caused the error. Use with location to pinpoint the error. For example, if you specify an invalid value for a parameter, the locationType will be parameter and the location will be the name of the parameter.
 public var locationType: String?
 /// The specific item within the locationType that caused the error. For example, if you specify an invalid value for a parameter, the location will be the name of the parameter.
 public var location: String?
 }
 */
