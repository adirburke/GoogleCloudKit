// This is Generated Code


import Foundation
import AsyncHTTPClient
import NIO
import Core
import NIOFoundationCompat
import NIOHTTP1
import CodableWrappers


public enum GoogleCloudDiscoveryScope : GoogleCloudAPIScope {
   public var value : String {
      switch self {
      }
   }

}


public struct GoogleCloudDiscoveryConfiguration : GoogleCloudAPIConfiguration {
   public var scope : [GoogleCloudAPIScope]
   public var serviceAccount: String
   public var project: String?
   public var subscription: String?

   public init(scope: [GoogleCloudDiscoveryScope], serviceAccount : String, project: String?, subscription: String?) {
      self.scope = scope
      self.serviceAccount = serviceAccount
      self.project = project
      self.subscription = subscription
   }
}


public final class GoogleCloudDiscoveryRequest : GoogleCloudAPIRequest {
   public var refreshableToken: OAuthRefreshable
   public var project: String
   public var httpClient: HTTPClient
   public var responseDecoder: JSONDecoder = JSONDecoder()
   public var currentToken: OAuthAccessToken?
   public var tokenCreatedTime: Date?
   private let eventLoop : EventLoop

   init(httpClient: HTTPClient, eventLoop: EventLoop, oauth: OAuthRefreshable, project: String) {
      self.refreshableToken = oauth
      self.project = project
      self.httpClient = httpClient
      self.eventLoop = eventLoop
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      self.responseDecoder.dateDecodingStrategy = .formatted(dateFormatter)
   }
   public func send<GCM: GoogleCloudModel>(method: HTTPMethod, headers: HTTPHeaders = [:], path: String, query: String = "", body: HTTPClient.Body = .data(Data())) -> EventLoopFuture<GCM> {
      return withToken { token in
         return self._send(method: method, headers: headers, path: path, query: query, body: body, accessToken: token.accessToken).flatMap { response in
            do {
               if GCM.self is GoogleCloudDataResponse.Type {
                  let model = GoogleCloudDataResponse(data: response) as! GCM
                  return self.eventLoop.makeSucceededFuture(model)
               } else {
                  let model = try self.responseDecoder.decode(GCM.self, from: response)
                  return self.eventLoop.makeSucceededFuture(model)
               }
            } catch {
               return self.eventLoop.makeFailedFuture(error)
            }
         }
      }
   }

   private func _send(method: HTTPMethod, headers: HTTPHeaders, path: String, query: String, body: HTTPClient.Body, accessToken: String) -> EventLoopFuture<Data> {
      var _headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)",
                        "Content-Type": "application/json"]
      headers.forEach { _headers.replaceOrAdd(name: $0.name, value: $0.value) }
      do {
         let request = try HTTPClient.Request(url: "\(path)?\(query)", method: method, headers: _headers, body: body)

         return httpClient.execute(request: request, eventLoop: .delegate(on: self.eventLoop)).flatMap { response in
            // If we get a 204 for example in the delete api call just return an empty body to decode.
            // https://cloud.google.com/s/results/?q=If+successful%2C+this+method+returns+an+empty+response+body.&p=%2Fstorage%2Fdocs%2F
            if response.status == .noContent {
               return self.eventLoop.makeSucceededFuture("{}".data(using: .utf8)!)
            }
            guard var byteBuffer = response.body else {
               fatalError("Response body from Google is missing! This should never happen.")
            }
            let responseData = byteBuffer.readData(length: byteBuffer.readableBytes)!
               guard (200...299).contains(response.status.code) else {
               let error: Error
               if let jsonError = try? self.responseDecoder.decode(GoogleCloudAPIErrorMain.self, from: responseData) {
                  error = jsonError
               } else {
                  let body = response.body?.getString(at: response.body?.readerIndex ?? 0, length: response.body?.readableBytes ?? 0) ?? ""
                  error = GoogleCloudAPIErrorMain(error: GoogleCloudAPIErrorBody(errors: [], code: Int(response.status.code), message: body))
               }
               return self.eventLoop.makeFailedFuture(error)
            }
            return self.eventLoop.makeSucceededFuture(responseData)
         }
      } catch {
         return self.eventLoop.makeFailedFuture(error)
      }
   }
}
public final class GoogleCloudDiscoveryApisAPI : DiscoveryApisAPIProtocol {
   let endpoint = "https://www.googleapis.com/discovery/v1/"
   let request : GoogleCloudDiscoveryRequest

   init(request: GoogleCloudDiscoveryRequest) {
      self.request = request
   }

   /// Retrieve the description of a particular version of an api.
   /// - Parameter api: The name of the API.
/// - Parameter version: The version of the API.

   public func getRest(api : String, version : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDiscoveryRestDescription> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)apis/\(api)/\(version)/rest", query: queryParams)
   }
   /// Retrieve the list of APIs supported at this endpoint.
   
   public func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDiscoveryDirectoryList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)apis", query: queryParams)
   }
}

public protocol DiscoveryApisAPIProtocol  {
   /// Retrieve the description of a particular version of an api.
   func getRest(api : String, version : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDiscoveryRestDescription>
   /// Retrieve the list of APIs supported at this endpoint.
   func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDiscoveryDirectoryList>
}
extension DiscoveryApisAPIProtocol   {
      public func getRest(api : String, version : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDiscoveryRestDescription> {
      getRest(api: api,version: version,  queryParameters: queryParameters)
   }

      public func list( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDiscoveryDirectoryList> {
      list(  queryParameters: queryParameters)
   }

}
public struct GoogleCloudDiscoveryEmptyResponse : GoogleCloudModel {}
public struct GoogleCloudDiscoveryDirectoryList : GoogleCloudModel {
   /*Indicate the version of the Discovery API used to generate this doc. */
   public var discoveryVersion: String?
   /*The individual directory entries. One entry per api/version pair. */
   public var items: [GoogleCloudDiscoveryDirectoryListItems]?
   /*The kind for this response. */
   public var kind: String?
   public init(discoveryVersion:String?, items:[GoogleCloudDiscoveryDirectoryListItems]?, kind:String?) {
      self.discoveryVersion = discoveryVersion
      self.items = items
      self.kind = kind
   }
}
public struct GoogleCloudDiscoveryJsonSchema : GoogleCloudModel {
   /*A reference to another schema. The value of this property is the "id" of another schema. */
   public var $ref: String?
   /*If this is a schema for an object, this property is the schema for any additional properties with dynamic keys on this object. */
   public var additionalProperties: GoogleCloudDiscoveryJsonSchema?
   /*Additional information about this property. */
   public var annotations: GoogleCloudDiscoveryJsonSchemaAnnotations?
   /*The default value of this property (if one exists). */
   public var `default`: String?
   /*A description of this object. */
   public var description: String?
   /*Values this parameter may take (if it is an enum). */
   public var `enum`: [String]?
   /*The descriptions for the enums. Each position maps to the corresponding value in the "enum" array. */
   public var enumDescriptions: [String]?
   /*An additional regular expression or key that helps constrain the value. For more details see: http://tools.ietf.org/html/draft-zyp-json-schema-03#section-5.23 */
   public var format: String?
   /*Unique identifier for this schema. */
   public var id: String?
   /*If this is a schema for an array, this property is the schema for each element in the array. */
   public var items: GoogleCloudDiscoveryJsonSchema?
   /*Whether this parameter goes in the query or the path for REST requests. */
   public var location: String?
   /*The maximum value of this parameter. */
   public var maximum: String?
   /*The minimum value of this parameter. */
   public var minimum: String?
   /*The regular expression this parameter must conform to. Uses Java 6 regex format: http://docs.oracle.com/javase/6/docs/api/java/util/regex/Pattern.html */
   public var pattern: String?
   /*If this is a schema for an object, list the schema for each property of this object. */
   public var properties: [String : GoogleCloudDiscoveryJsonSchema]?
   /*The value is read-only, generated by the service. The value cannot be modified by the client. If the value is included in a POST, PUT, or PATCH request, it is ignored by the service. */
   public var readOnly: Bool?
   /*Whether this parameter may appear multiple times. */
   public var repeated: Bool?
   /*Whether the parameter is required. */
   public var required: Bool?
   /*The value type for this schema. A list of values can be found here: http://tools.ietf.org/html/draft-zyp-json-schema-03#section-5.1 */
   public var type: String?
   /*In a variant data type, the value of one property is used to determine how to interpret the entire entity. Its value must exist in a map of descriminant values to schema names. */
   public var variant: GoogleCloudDiscoveryJsonSchemaVariant?
   public init($ref:String?, additionalProperties:GoogleCloudDiscoveryJsonSchema?, annotations:GoogleCloudDiscoveryJsonSchemaAnnotations?, `default`:String?, description:String?, `enum`:[String]?, enumDescriptions:[String]?, format:String?, id:String?, items:GoogleCloudDiscoveryJsonSchema?, location:String?, maximum:String?, minimum:String?, pattern:String?, properties:[String : GoogleCloudDiscoveryJsonSchema]?, readOnly:Bool?, repeated:Bool?, required:Bool?, type:String?, variant:GoogleCloudDiscoveryJsonSchemaVariant?) {
      self.$ref = $ref
      self.additionalProperties = additionalProperties
      self.annotations = annotations
      self.`default` = `default`
      self.description = description
      self.`enum` = `enum`
      self.enumDescriptions = enumDescriptions
      self.format = format
      self.id = id
      self.items = items
      self.location = location
      self.maximum = maximum
      self.minimum = minimum
      self.pattern = pattern
      self.properties = properties
      self.readOnly = readOnly
      self.repeated = repeated
      self.required = required
      self.type = type
      self.variant = variant
   }
}
public struct GoogleCloudDiscoveryRestDescription : GoogleCloudModel {
   /*Authentication information. */
   public var auth: GoogleCloudDiscoveryRestDescriptionAuth?
   /*[DEPRECATED] The base path for REST requests. */
   public var basePath: String?
   /*[DEPRECATED] The base URL for REST requests. */
   public var baseUrl: String?
   /*The path for REST batch requests. */
   public var batchPath: String?
   /*Indicates how the API name should be capitalized and split into various parts. Useful for generating pretty class names. */
   public var canonicalName: String?
   /*The description of this API. */
   public var description: String?
   /*Indicate the version of the Discovery API used to generate this doc. */
   public var discoveryVersion: String?
   /*A link to human readable documentation for the API. */
   public var documentationLink: String?
   /*The ETag for this response. */
   public var etag: String?
   /*Enable exponential backoff for suitable methods in the generated clients. */
   public var exponentialBackoffDefault: Bool?
   /*A list of supported features for this API. */
   public var features: [String]?
   /*Links to 16x16 and 32x32 icons representing the API. */
   public var icons: GoogleCloudDiscoveryRestDescriptionIcons?
   /*The ID of this API. */
   public var id: String?
   /*The kind for this response. */
   public var kind: String?
   /*Labels for the status of this API, such as labs or deprecated. */
   public var labels: [String]?
   /*API-level methods for this API. */
   public var methods: [String : GoogleCloudDiscoveryRestMethod]?
   /*The name of this API. */
   public var name: String?
   /*The domain of the owner of this API. Together with the ownerName and a packagePath values, this can be used to generate a library for this API which would have a unique fully qualified name. */
   public var ownerDomain: String?
   /*The name of the owner of this API. See ownerDomain. */
   public var ownerName: String?
   /*The package of the owner of this API. See ownerDomain. */
   public var packagePath: String?
   /*Common parameters that apply across all apis. */
   public var parameters: [String : GoogleCloudDiscoveryJsonSchema]?
   /*The protocol described by this document. */
   public var `protocol`: String?
   /*The resources in this API. */
   public var resources: [String : GoogleCloudDiscoveryRestResource]?
   /*The version of this API. */
   public var revision: String?
   /*The root URL under which all API services live. */
   public var rootUrl: String?
   /*The schemas for this API. */
   public var schemas: [String : GoogleCloudDiscoveryJsonSchema]?
   /*The base path for all REST requests. */
   public var servicePath: String?
   /*The title of this API. */
   public var title: String?
   /*The version of this API. */
   public var version: String?
   public var version_module: Bool?
   public init(auth:GoogleCloudDiscoveryRestDescriptionAuth?, basePath:String?, baseUrl:String?, batchPath:String?, canonicalName:String?, description:String?, discoveryVersion:String?, documentationLink:String?, etag:String?, exponentialBackoffDefault:Bool?, features:[String]?, icons:GoogleCloudDiscoveryRestDescriptionIcons?, id:String?, kind:String?, labels:[String]?, methods:[String : GoogleCloudDiscoveryRestMethod]?, name:String?, ownerDomain:String?, ownerName:String?, packagePath:String?, parameters:[String : GoogleCloudDiscoveryJsonSchema]?, `protocol`:String?, resources:[String : GoogleCloudDiscoveryRestResource]?, revision:String?, rootUrl:String?, schemas:[String : GoogleCloudDiscoveryJsonSchema]?, servicePath:String?, title:String?, version:String?, version_module:Bool?) {
      self.auth = auth
      self.basePath = basePath
      self.baseUrl = baseUrl
      self.batchPath = batchPath
      self.canonicalName = canonicalName
      self.description = description
      self.discoveryVersion = discoveryVersion
      self.documentationLink = documentationLink
      self.etag = etag
      self.exponentialBackoffDefault = exponentialBackoffDefault
      self.features = features
      self.icons = icons
      self.id = id
      self.kind = kind
      self.labels = labels
      self.methods = methods
      self.name = name
      self.ownerDomain = ownerDomain
      self.ownerName = ownerName
      self.packagePath = packagePath
      self.parameters = parameters
      self.`protocol` = `protocol`
      self.resources = resources
      self.revision = revision
      self.rootUrl = rootUrl
      self.schemas = schemas
      self.servicePath = servicePath
      self.title = title
      self.version = version
      self.version_module = version_module
   }
}
public struct GoogleCloudDiscoveryRestMethod : GoogleCloudModel {
   /*Description of this method. */
   public var description: String?
   /*Whether this method requires an ETag to be specified. The ETag is sent as an HTTP If-Match or If-None-Match header. */
   public var etagRequired: Bool?
   /*HTTP method used by this method. */
   public var httpMethod: String?
   /*A unique ID for this method. This property can be used to match methods between different versions of Discovery. */
   public var id: String?
   /*Media upload parameters. */
   public var mediaUpload: GoogleCloudDiscoveryRestMethodMediaUpload?
   /*Ordered list of required parameters, serves as a hint to clients on how to structure their method signatures. The array is ordered such that the "most-significant" parameter appears first. */
   public var parameterOrder: [String]?
   /*Details for all parameters in this method. */
   public var parameters: [String : GoogleCloudDiscoveryJsonSchema]?
   /*The URI path of this REST method. Should be used in conjunction with the basePath property at the api-level. */
   public var path: String?
   /*The schema for the request. */
   public var request: GoogleCloudDiscoveryRestMethodRequest?
   /*The schema for the response. */
   public var response: GoogleCloudDiscoveryRestMethodResponse?
   /*OAuth 2.0 scopes applicable to this method. */
   public var scopes: [String]?
   /*Whether this method supports media downloads. */
   public var supportsMediaDownload: Bool?
   /*Whether this method supports media uploads. */
   public var supportsMediaUpload: Bool?
   /*Whether this method supports subscriptions. */
   public var supportsSubscription: Bool?
   /*Indicates that downloads from this method should use the download service URL (i.e. "/download"). Only applies if the method supports media download. */
   public var useMediaDownloadService: Bool?
   public init(description:String?, etagRequired:Bool?, httpMethod:String?, id:String?, mediaUpload:GoogleCloudDiscoveryRestMethodMediaUpload?, parameterOrder:[String]?, parameters:[String : GoogleCloudDiscoveryJsonSchema]?, path:String?, request:GoogleCloudDiscoveryRestMethodRequest?, response:GoogleCloudDiscoveryRestMethodResponse?, scopes:[String]?, supportsMediaDownload:Bool?, supportsMediaUpload:Bool?, supportsSubscription:Bool?, useMediaDownloadService:Bool?) {
      self.description = description
      self.etagRequired = etagRequired
      self.httpMethod = httpMethod
      self.id = id
      self.mediaUpload = mediaUpload
      self.parameterOrder = parameterOrder
      self.parameters = parameters
      self.path = path
      self.request = request
      self.response = response
      self.scopes = scopes
      self.supportsMediaDownload = supportsMediaDownload
      self.supportsMediaUpload = supportsMediaUpload
      self.supportsSubscription = supportsSubscription
      self.useMediaDownloadService = useMediaDownloadService
   }
}
public struct GoogleCloudDiscoveryRestResource : GoogleCloudModel {
   /*Methods on this resource. */
   public var methods: [String : GoogleCloudDiscoveryRestMethod]?
   /*Sub-resources on this resource. */
   public var resources: [String : GoogleCloudDiscoveryRestResource]?
   public init(methods:[String : GoogleCloudDiscoveryRestMethod]?, resources:[String : GoogleCloudDiscoveryRestResource]?) {
      self.methods = methods
      self.resources = resources
   }
}
public struct GoogleCloudDiscoveryDirectoryListItems : GoogleCloudModel {
   /*The description of this API. */
   public var description: String?
   /*A link to the discovery document. */
   public var discoveryLink: String?
   /*The URL for the discovery REST document. */
   public var discoveryRestUrl: String?
   /*A link to human readable documentation for the API. */
   public var documentationLink: String?
   /*Links to 16x16 and 32x32 icons representing the API. */
   public var icons: PlaceHolderObject?
   /*The id of this API. */
   public var id: String?
   /*The kind for this response. */
   public var kind: String?
   /*Labels for the status of this API, such as labs or deprecated. */
   public var labels: [String]?
   /*The name of the API. */
   public var name: String?
   /*True if this version is the preferred version to use. */
   public var preferred: Bool?
   /*The title of this API. */
   public var title: String?
   /*The version of the API. */
   public var version: String?
}
public struct GoogleCloudDiscoveryJsonSchemaAnnotations : GoogleCloudModel {
   /*A list of methods for which this property is required on requests. */
   public var required: [String]?
}
public struct GoogleCloudDiscoveryJsonSchemaVariant : GoogleCloudModel {
   /*The name of the type discriminant property. */
   public var discriminant: String?
   /*The map of discriminant value to schema to use for parsing.. */
   public var map: [PlaceHolderObject]?
}
public struct GoogleCloudDiscoveryRestDescriptionAuth : GoogleCloudModel {
   /*OAuth 2.0 authentication information. */
   public var oauth2: PlaceHolderObject?
}
public struct GoogleCloudDiscoveryRestDescriptionIcons : GoogleCloudModel {
   /*The URL of the 16x16 icon. */
   public var x16: String?
   /*The URL of the 32x32 icon. */
   public var x32: String?
}
public struct GoogleCloudDiscoveryRestMethodMediaUpload : GoogleCloudModel {
   /*MIME Media Ranges for acceptable media uploads to this method. */
   public var accept: [String]?
   /*Maximum size of a media upload, such as "1MB", "2GB" or "3TB". */
   public var maxSize: String?
   /*Supported upload protocols. */
   public var protocols: PlaceHolderObject?
}
public struct GoogleCloudDiscoveryRestMethodRequest : GoogleCloudModel {
   /*Schema ID for the request schema. */
   public var $ref: String?
   /*parameter name. */
   public var parameterName: String?
}
public struct GoogleCloudDiscoveryRestMethodResponse : GoogleCloudModel {
   /*Schema ID for the response schema. */
   public var $ref: String?
}
public final class GoogleCloudDiscoveryClient {
   public var apis : DiscoveryApisAPIProtocol


   public init(credentials: GoogleCloudCredentialsConfiguration, discoveryConfig: GoogleCloudDiscoveryConfiguration, httpClient: HTTPClient, eventLoop: EventLoop) throws {
      let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: discoveryConfig, andClient: httpClient, eventLoop: eventLoop)
      guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
               (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
               discoveryConfig.project ?? credentials.project else {
         throw GoogleCloudInternalError.projectIdMissing
      }

      let request = GoogleCloudDiscoveryRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)


      apis = GoogleCloudDiscoveryApisAPI(request: request)
   }
}

