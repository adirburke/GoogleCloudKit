// This is Generated Code


import Foundation
import AsyncHTTPClient
import NIO
import Core
import NIOFoundationCompat
import NIOHTTP1
import CodableWrappers


public enum GoogleCloudStorageScope : GoogleCloudAPIScope {
   public var value : String {
      switch self {
      case .CloudPlatformReadOnly: return "https://www.googleapis.com/auth/cloud-platform.read-only"
      case .DevstorageFullControl: return "https://www.googleapis.com/auth/devstorage.full_control"
      case .CloudPlatform: return "https://www.googleapis.com/auth/cloud-platform"
      case .DevstorageReadOnly: return "https://www.googleapis.com/auth/devstorage.read_only"
      case .DevstorageReadWrite: return "https://www.googleapis.com/auth/devstorage.read_write"
      }
   }

   case CloudPlatformReadOnly // View your data across Google Cloud Platform services
   case DevstorageFullControl // Manage your data and permissions in Google Cloud Storage
   case CloudPlatform // View and manage your data across Google Cloud Platform services
   case DevstorageReadOnly // View your data in Google Cloud Storage
   case DevstorageReadWrite // Manage your data in Google Cloud Storage
}


public struct GoogleCloudStorageConfiguration : GoogleCloudAPIConfiguration {
   public var scope : [GoogleCloudAPIScope]
   public var serviceAccount: String
   public var project: String?
   public var subscription: String?

   public init(scope: [GoogleCloudStorageScope], serviceAccount : String, project: String?, subscription: String?) {
      self.scope = scope
      self.serviceAccount = serviceAccount
      self.project = project
      self.subscription = subscription
   }
}


public final class GoogleCloudStorageRequest : GoogleCloudAPIRequest {
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
public final class GoogleCloudStorageBucketAccessControlsAPI : StorageBucketAccessControlsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Permanently deletes the ACL entry for the specified entity on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func delete(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)b/\(bucket)/acl/\(entity)", query: queryParams)
   }
   /// Returns the ACL entry for the specified entity on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func get(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/acl/\(entity)", query: queryParams)
   }
   /// Creates a new ACL entry on the specified bucket.
   /// - Parameter bucket: Name of a bucket.

   public func insert(bucket : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(bucket)/acl", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Retrieves ACL entries on the specified bucket.
   /// - Parameter bucket: Name of a bucket.

   public func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControls> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/acl", query: queryParams)
   }
   /// Patches an ACL entry on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func patch(bucket : String, entity : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)b/\(bucket)/acl/\(entity)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates an ACL entry on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func update(bucket : String, entity : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)b/\(bucket)/acl/\(entity)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol StorageBucketAccessControlsAPIProtocol  {
   /// Permanently deletes the ACL entry for the specified entity on the specified bucket.
   func delete(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
   /// Returns the ACL entry for the specified entity on the specified bucket.
   func get(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl>
   /// Creates a new ACL entry on the specified bucket.
   func insert(bucket : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl>
   /// Retrieves ACL entries on the specified bucket.
   func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControls>
   /// Patches an ACL entry on the specified bucket.
   func patch(bucket : String, entity : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl>
   /// Updates an ACL entry on the specified bucket.
   func update(bucket : String, entity : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl>
}
extension StorageBucketAccessControlsAPIProtocol   {
      public func delete(bucket : String, entity : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      delete(bucket: bucket,entity: entity,  queryParameters: queryParameters)
   }

      public func get(bucket : String, entity : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      get(bucket: bucket,entity: entity,  queryParameters: queryParameters)
   }

      public func insert(bucket : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      insert(bucket: bucket, body: body, queryParameters: queryParameters)
   }

      public func list(bucket : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucketAccessControls> {
      list(bucket: bucket,  queryParameters: queryParameters)
   }

      public func patch(bucket : String, entity : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      patch(bucket: bucket,entity: entity, body: body, queryParameters: queryParameters)
   }

      public func update(bucket : String, entity : String, body : GoogleCloudStorageBucketAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucketAccessControl> {
      update(bucket: bucket,entity: entity, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageBucketsAPI : StorageBucketsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Permanently deletes an empty bucket.
   /// - Parameter bucket: Name of a bucket.

   public func delete(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)b/\(bucket)", query: queryParams)
   }
   /// Returns metadata for the specified bucket.
   /// - Parameter bucket: Name of a bucket.

   public func get(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)", query: queryParams)
   }
   /// Returns an IAM policy for the specified bucket.
   /// - Parameter bucket: Name of a bucket.

   public func getIamPolicy(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/iam", query: queryParams)
   }
   /// Creates a new bucket.
   /// - Parameter project: A valid API project identifier.

   public func insert(project : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Retrieves a list of buckets for a given project.
   /// - Parameter project: A valid API project identifier.

   public func list(project : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBuckets> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b", query: queryParams)
   }
   /// Locks retention policy on a bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter ifMetagenerationMatch: Makes the operation conditional on whether bucket's current metageneration matches the given value.

   public func lockRetentionPolicy(bucket : String, ifMetagenerationMatch : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)b/\(bucket)/lockRetentionPolicy", query: queryParams)
   }
   /// Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
   /// - Parameter bucket: Name of a bucket.

   public func patch(bucket : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)b/\(bucket)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates an IAM policy for the specified bucket.
   /// - Parameter bucket: Name of a bucket.

   public func setIamPolicy(bucket : String, body : GoogleCloudStoragePolicy, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)b/\(bucket)/iam", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter permissions: Permissions to test.

   public func testIamPermissions(bucket : String, permissions : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageTestIamPermissionsResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/iam/testPermissions", query: queryParams)
   }
   /// Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
   /// - Parameter bucket: Name of a bucket.

   public func update(bucket : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)b/\(bucket)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol StorageBucketsAPIProtocol  {
   /// Permanently deletes an empty bucket.
   func delete(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
   /// Returns metadata for the specified bucket.
   func get(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket>
   /// Returns an IAM policy for the specified bucket.
   func getIamPolicy(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy>
   /// Creates a new bucket.
   func insert(project : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket>
   /// Retrieves a list of buckets for a given project.
   func list(project : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBuckets>
   /// Locks retention policy on a bucket.
   func lockRetentionPolicy(bucket : String, ifMetagenerationMatch : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket>
   /// Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
   func patch(bucket : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket>
   /// Updates an IAM policy for the specified bucket.
   func setIamPolicy(bucket : String, body : GoogleCloudStoragePolicy, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy>
   /// Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
   func testIamPermissions(bucket : String, permissions : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageTestIamPermissionsResponse>
   /// Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
   func update(bucket : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageBucket>
}
extension StorageBucketsAPIProtocol   {
      public func delete(bucket : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      delete(bucket: bucket,  queryParameters: queryParameters)
   }

      public func get(bucket : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucket> {
      get(bucket: bucket,  queryParameters: queryParameters)
   }

      public func getIamPolicy(bucket : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      getIamPolicy(bucket: bucket,  queryParameters: queryParameters)
   }

      public func insert(project : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucket> {
      insert(project: project, body: body, queryParameters: queryParameters)
   }

      public func list(project : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBuckets> {
      list(project: project,  queryParameters: queryParameters)
   }

      public func lockRetentionPolicy(bucket : String, ifMetagenerationMatch : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucket> {
      lockRetentionPolicy(bucket: bucket,ifMetagenerationMatch: ifMetagenerationMatch,  queryParameters: queryParameters)
   }

      public func patch(bucket : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucket> {
      patch(bucket: bucket, body: body, queryParameters: queryParameters)
   }

      public func setIamPolicy(bucket : String, body : GoogleCloudStoragePolicy, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      setIamPolicy(bucket: bucket, body: body, queryParameters: queryParameters)
   }

      public func testIamPermissions(bucket : String, permissions : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageTestIamPermissionsResponse> {
      testIamPermissions(bucket: bucket,permissions: permissions,  queryParameters: queryParameters)
   }

      public func update(bucket : String, body : GoogleCloudStorageBucket, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageBucket> {
      update(bucket: bucket, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageChannelsAPI : StorageChannelsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Stop watching resources through this channel
   
   public func stop(body : GoogleCloudStorageChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)channels/stop", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol StorageChannelsAPIProtocol  {
   /// Stop watching resources through this channel
   func stop(body : GoogleCloudStorageChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
}
extension StorageChannelsAPIProtocol   {
      public func stop(body : GoogleCloudStorageChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      stop( body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageDefaultObjectAccessControlsAPI : StorageDefaultObjectAccessControlsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func delete(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)b/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
   }
   /// Returns the default object ACL entry for the specified entity on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func get(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams)
   }
   /// Creates a new default object ACL entry on the specified bucket.
   /// - Parameter bucket: Name of a bucket.

   public func insert(bucket : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(bucket)/defaultObjectAcl", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Retrieves default object ACL entries on the specified bucket.
   /// - Parameter bucket: Name of a bucket.

   public func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControls> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/defaultObjectAcl", query: queryParams)
   }
   /// Patches a default object ACL entry on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func patch(bucket : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)b/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates a default object ACL entry on the specified bucket.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func update(bucket : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)b/\(bucket)/defaultObjectAcl/\(entity)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol StorageDefaultObjectAccessControlsAPIProtocol  {
   /// Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
   func delete(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
   /// Returns the default object ACL entry for the specified entity on the specified bucket.
   func get(bucket : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
   /// Creates a new default object ACL entry on the specified bucket.
   func insert(bucket : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
   /// Retrieves default object ACL entries on the specified bucket.
   func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControls>
   /// Patches a default object ACL entry on the specified bucket.
   func patch(bucket : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
   /// Updates a default object ACL entry on the specified bucket.
   func update(bucket : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
}
extension StorageDefaultObjectAccessControlsAPIProtocol   {
      public func delete(bucket : String, entity : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      delete(bucket: bucket,entity: entity,  queryParameters: queryParameters)
   }

      public func get(bucket : String, entity : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      get(bucket: bucket,entity: entity,  queryParameters: queryParameters)
   }

      public func insert(bucket : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      insert(bucket: bucket, body: body, queryParameters: queryParameters)
   }

      public func list(bucket : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControls> {
      list(bucket: bucket,  queryParameters: queryParameters)
   }

      public func patch(bucket : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      patch(bucket: bucket,entity: entity, body: body, queryParameters: queryParameters)
   }

      public func update(bucket : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      update(bucket: bucket,entity: entity, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageNotificationsAPI : StorageNotificationsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Permanently deletes a notification subscription.
   /// - Parameter bucket: The parent bucket of the notification.
/// - Parameter notification: ID of the notification to delete.

   public func delete(bucket : String, notification : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)b/\(bucket)/notificationConfigs/\(notification)", query: queryParams)
   }
   /// View a notification configuration.
   /// - Parameter bucket: The parent bucket of the notification.
/// - Parameter notification: Notification ID

   public func get(bucket : String, notification : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageNotification> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/notificationConfigs/\(notification)", query: queryParams)
   }
   /// Creates a notification subscription for a given bucket.
   /// - Parameter bucket: The parent bucket of the notification.

   public func insert(bucket : String, body : GoogleCloudStorageNotification, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageNotification> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(bucket)/notificationConfigs", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Retrieves a list of notification subscriptions for a given bucket.
   /// - Parameter bucket: Name of a Google Cloud Storage bucket.

   public func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageNotifications> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/notificationConfigs", query: queryParams)
   }
}

public protocol StorageNotificationsAPIProtocol  {
   /// Permanently deletes a notification subscription.
   func delete(bucket : String, notification : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
   /// View a notification configuration.
   func get(bucket : String, notification : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageNotification>
   /// Creates a notification subscription for a given bucket.
   func insert(bucket : String, body : GoogleCloudStorageNotification, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageNotification>
   /// Retrieves a list of notification subscriptions for a given bucket.
   func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageNotifications>
}
extension StorageNotificationsAPIProtocol   {
      public func delete(bucket : String, notification : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      delete(bucket: bucket,notification: notification,  queryParameters: queryParameters)
   }

      public func get(bucket : String, notification : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageNotification> {
      get(bucket: bucket,notification: notification,  queryParameters: queryParameters)
   }

      public func insert(bucket : String, body : GoogleCloudStorageNotification, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageNotification> {
      insert(bucket: bucket, body: body, queryParameters: queryParameters)
   }

      public func list(bucket : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageNotifications> {
      list(bucket: bucket,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageObjectAccessControlsAPI : StorageObjectAccessControlsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Permanently deletes the ACL entry for the specified entity on the specified object.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func delete(bucket : String, `object` : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)b/\(bucket)/o/\(`object`)/acl/\(entity)", query: queryParams)
   }
   /// Returns the ACL entry for the specified entity on the specified object.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func get(bucket : String, `object` : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/o/\(`object`)/acl/\(entity)", query: queryParams)
   }
   /// Creates a new ACL entry on the specified object.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func insert(bucket : String, `object` : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(bucket)/o/\(`object`)/acl", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Retrieves ACL entries on the specified object.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func list(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControls> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/o/\(`object`)/acl", query: queryParams)
   }
   /// Patches an ACL entry on the specified object.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func patch(bucket : String, `object` : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)b/\(bucket)/o/\(`object`)/acl/\(entity)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates an ACL entry on the specified object.
   /// - Parameter bucket: Name of a bucket.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter entity: The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.

   public func update(bucket : String, `object` : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)b/\(bucket)/o/\(`object`)/acl/\(entity)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol StorageObjectAccessControlsAPIProtocol  {
   /// Permanently deletes the ACL entry for the specified entity on the specified object.
   func delete(bucket : String, `object` : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
   /// Returns the ACL entry for the specified entity on the specified object.
   func get(bucket : String, `object` : String, entity : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
   /// Creates a new ACL entry on the specified object.
   func insert(bucket : String, `object` : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
   /// Retrieves ACL entries on the specified object.
   func list(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControls>
   /// Patches an ACL entry on the specified object.
   func patch(bucket : String, `object` : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
   /// Updates an ACL entry on the specified object.
   func update(bucket : String, `object` : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl>
}
extension StorageObjectAccessControlsAPIProtocol   {
      public func delete(bucket : String, `object` : String, entity : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      delete(bucket: bucket,`object`: object,entity: entity,  queryParameters: queryParameters)
   }

      public func get(bucket : String, `object` : String, entity : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      get(bucket: bucket,`object`: object,entity: entity,  queryParameters: queryParameters)
   }

      public func insert(bucket : String, `object` : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      insert(bucket: bucket,`object`: object, body: body, queryParameters: queryParameters)
   }

      public func list(bucket : String, `object` : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControls> {
      list(bucket: bucket,`object`: object,  queryParameters: queryParameters)
   }

      public func patch(bucket : String, `object` : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      patch(bucket: bucket,`object`: object,entity: entity, body: body, queryParameters: queryParameters)
   }

      public func update(bucket : String, `object` : String, entity : String, body : GoogleCloudStorageObjectAccessControl, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjectAccessControl> {
      update(bucket: bucket,`object`: object,entity: entity, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageObjectsAPI : StorageObjectsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Concatenates a list of existing objects into a new object in the same bucket.
   /// - Parameter destinationBucket: Name of the bucket containing the source objects. The destination object is stored in this bucket.
/// - Parameter destinationObject: Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func compose(destinationBucket : String, destinationObject : String, body : GoogleCloudStorageComposeRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(destinationBucket)/o/\(destinationObject)/compose", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Copies a source object to a destination object. Optionally overrides metadata.
   /// - Parameter sourceBucket: Name of the bucket in which to find the source object.
/// - Parameter sourceObject: Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter destinationBucket: Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter destinationObject: Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.

   public func copy(sourceBucket : String, sourceObject : String, destinationBucket : String, destinationObject : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(sourceBucket)/o/\(sourceObject)/copyTo/b/\(destinationBucket)/o/\(destinationObject)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
   /// - Parameter bucket: Name of the bucket in which the object resides.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func delete(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)b/\(bucket)/o/\(`object`)", query: queryParams)
   }
   /// Retrieves an object or its metadata.
   /// - Parameter bucket: Name of the bucket in which the object resides.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func get(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/o/\(`object`)", query: queryParams)
   }
   /// Returns an IAM policy for the specified object.
   /// - Parameter bucket: Name of the bucket in which the object resides.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func getIamPolicy(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/o/\(`object`)/iam", query: queryParams)
   }
   /// Stores a new object and metadata.
   /// - Parameter bucket: Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.

   public func insert(bucket : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(bucket)/o", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Retrieves a list of objects matching the criteria.
   /// - Parameter bucket: Name of the bucket in which to look for objects.

   public func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjects> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/o", query: queryParams)
   }
   /// Patches an object's metadata.
   /// - Parameter bucket: Name of the bucket in which the object resides.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func patch(bucket : String, `object` : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)b/\(bucket)/o/\(`object`)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Rewrites a source object to a destination object. Optionally overrides metadata.
   /// - Parameter sourceBucket: Name of the bucket in which to find the source object.
/// - Parameter sourceObject: Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter destinationBucket: Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
/// - Parameter destinationObject: Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func rewrite(sourceBucket : String, sourceObject : String, destinationBucket : String, destinationObject : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageRewriteResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(sourceBucket)/o/\(sourceObject)/rewriteTo/b/\(destinationBucket)/o/\(destinationObject)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates an IAM policy for the specified object.
   /// - Parameter bucket: Name of the bucket in which the object resides.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func setIamPolicy(bucket : String, `object` : String, body : GoogleCloudStoragePolicy, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)b/\(bucket)/o/\(`object`)/iam", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Tests a set of permissions on the given object to see which, if any, are held by the caller.
   /// - Parameter bucket: Name of the bucket in which the object resides.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
/// - Parameter permissions: Permissions to test.

   public func testIamPermissions(bucket : String, `object` : String, permissions : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageTestIamPermissionsResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)b/\(bucket)/o/\(`object`)/iam/testPermissions", query: queryParams)
   }
   /// Updates an object's metadata.
   /// - Parameter bucket: Name of the bucket in which the object resides.
/// - Parameter object: Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.

   public func update(bucket : String, `object` : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)b/\(bucket)/o/\(`object`)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Watch for changes on all objects in a bucket.
   /// - Parameter bucket: Name of the bucket in which to look for objects.

   public func watchAll(bucket : String, body : GoogleCloudStorageChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)b/\(bucket)/o/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol StorageObjectsAPIProtocol  {
   /// Concatenates a list of existing objects into a new object in the same bucket.
   func compose(destinationBucket : String, destinationObject : String, body : GoogleCloudStorageComposeRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
   /// Copies a source object to a destination object. Optionally overrides metadata.
   func copy(sourceBucket : String, sourceObject : String, destinationBucket : String, destinationObject : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
   /// Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
   func delete(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
   /// Retrieves an object or its metadata.
   func get(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
   /// Returns an IAM policy for the specified object.
   func getIamPolicy(bucket : String, `object` : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy>
   /// Stores a new object and metadata.
   func insert(bucket : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
   /// Retrieves a list of objects matching the criteria.
   func list(bucket : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObjects>
   /// Patches an object's metadata.
   func patch(bucket : String, `object` : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
   /// Rewrites a source object to a destination object. Optionally overrides metadata.
   func rewrite(sourceBucket : String, sourceObject : String, destinationBucket : String, destinationObject : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageRewriteResponse>
   /// Updates an IAM policy for the specified object.
   func setIamPolicy(bucket : String, `object` : String, body : GoogleCloudStoragePolicy, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStoragePolicy>
   /// Tests a set of permissions on the given object to see which, if any, are held by the caller.
   func testIamPermissions(bucket : String, `object` : String, permissions : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageTestIamPermissionsResponse>
   /// Updates an object's metadata.
   func update(bucket : String, `object` : String, body : GoogleCloudStorageObject, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageObject>
   /// Watch for changes on all objects in a bucket.
   func watchAll(bucket : String, body : GoogleCloudStorageChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageChannel>
}
extension StorageObjectsAPIProtocol   {
      public func compose(destinationBucket : String, destinationObject : String, body : GoogleCloudStorageComposeRequest, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
      compose(destinationBucket: destinationBucket,destinationObject: destinationObject, body: body, queryParameters: queryParameters)
   }

      public func copy(sourceBucket : String, sourceObject : String, destinationBucket : String, destinationObject : String, body : GoogleCloudStorageObject, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
      copy(sourceBucket: sourceBucket,sourceObject: sourceObject,destinationBucket: destinationBucket,destinationObject: destinationObject, body: body, queryParameters: queryParameters)
   }

      public func delete(bucket : String, `object` : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      delete(bucket: bucket,`object`: object,  queryParameters: queryParameters)
   }

      public func get(bucket : String, `object` : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
      get(bucket: bucket,`object`: object,  queryParameters: queryParameters)
   }

      public func getIamPolicy(bucket : String, `object` : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      getIamPolicy(bucket: bucket,`object`: object,  queryParameters: queryParameters)
   }

      public func insert(bucket : String, body : GoogleCloudStorageObject, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
      insert(bucket: bucket, body: body, queryParameters: queryParameters)
   }

      public func list(bucket : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObjects> {
      list(bucket: bucket,  queryParameters: queryParameters)
   }

      public func patch(bucket : String, `object` : String, body : GoogleCloudStorageObject, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
      patch(bucket: bucket,`object`: object, body: body, queryParameters: queryParameters)
   }

      public func rewrite(sourceBucket : String, sourceObject : String, destinationBucket : String, destinationObject : String, body : GoogleCloudStorageObject, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageRewriteResponse> {
      rewrite(sourceBucket: sourceBucket,sourceObject: sourceObject,destinationBucket: destinationBucket,destinationObject: destinationObject, body: body, queryParameters: queryParameters)
   }

      public func setIamPolicy(bucket : String, `object` : String, body : GoogleCloudStoragePolicy, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStoragePolicy> {
      setIamPolicy(bucket: bucket,`object`: object, body: body, queryParameters: queryParameters)
   }

      public func testIamPermissions(bucket : String, `object` : String, permissions : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageTestIamPermissionsResponse> {
      testIamPermissions(bucket: bucket,`object`: object,permissions: permissions,  queryParameters: queryParameters)
   }

      public func update(bucket : String, `object` : String, body : GoogleCloudStorageObject, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageObject> {
      update(bucket: bucket,`object`: object, body: body, queryParameters: queryParameters)
   }

      public func watchAll(bucket : String, body : GoogleCloudStorageChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageChannel> {
      watchAll(bucket: bucket, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageProjectsAPI : StorageProjectsAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

}

public protocol StorageProjectsAPIProtocol  {
}
extension StorageProjectsAPIProtocol   {
}
public final class GoogleCloudStorageHmacKeysAPI : StorageHmacKeysAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Creates a new HMAC key for the specified service account.
   /// - Parameter projectId: Project ID owning the service account.
/// - Parameter serviceAccountEmail: Email address of the service account.

   public func create(projectId : String, serviceAccountEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKey> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)projects/\(projectId)/hmacKeys", query: queryParams)
   }
   /// Deletes an HMAC key.
   /// - Parameter projectId: Project ID owning the requested key
/// - Parameter accessId: Name of the HMAC key to be deleted.

   public func delete(projectId : String, accessId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)projects/\(projectId)/hmacKeys/\(accessId)", query: queryParams)
   }
   /// Retrieves an HMAC key's metadata
   /// - Parameter projectId: Project ID owning the service account of the requested key.
/// - Parameter accessId: Name of the HMAC key.

   public func get(projectId : String, accessId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKeyMetadata> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)projects/\(projectId)/hmacKeys/\(accessId)", query: queryParams)
   }
   /// Retrieves a list of HMAC keys matching the criteria.
   /// - Parameter projectId: Name of the project in which to look for HMAC keys.

   public func list(projectId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKeysMetadata> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)projects/\(projectId)/hmacKeys", query: queryParams)
   }
   /// Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
   /// - Parameter projectId: Project ID owning the service account of the updated key.
/// - Parameter accessId: Name of the HMAC key being updated.

   public func update(projectId : String, accessId : String, body : GoogleCloudStorageHmacKeyMetadata, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKeyMetadata> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)projects/\(projectId)/hmacKeys/\(accessId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol StorageHmacKeysAPIProtocol  {
   /// Creates a new HMAC key for the specified service account.
   func create(projectId : String, serviceAccountEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKey>
   /// Deletes an HMAC key.
   func delete(projectId : String, accessId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageEmptyResponse>
   /// Retrieves an HMAC key's metadata
   func get(projectId : String, accessId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKeyMetadata>
   /// Retrieves a list of HMAC keys matching the criteria.
   func list(projectId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKeysMetadata>
   /// Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
   func update(projectId : String, accessId : String, body : GoogleCloudStorageHmacKeyMetadata, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageHmacKeyMetadata>
}
extension StorageHmacKeysAPIProtocol   {
      public func create(projectId : String, serviceAccountEmail : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageHmacKey> {
      create(projectId: projectId,serviceAccountEmail: serviceAccountEmail,  queryParameters: queryParameters)
   }

      public func delete(projectId : String, accessId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageEmptyResponse> {
      delete(projectId: projectId,accessId: accessId,  queryParameters: queryParameters)
   }

      public func get(projectId : String, accessId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageHmacKeyMetadata> {
      get(projectId: projectId,accessId: accessId,  queryParameters: queryParameters)
   }

      public func list(projectId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageHmacKeysMetadata> {
      list(projectId: projectId,  queryParameters: queryParameters)
   }

      public func update(projectId : String, accessId : String, body : GoogleCloudStorageHmacKeyMetadata, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageHmacKeyMetadata> {
      update(projectId: projectId,accessId: accessId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudStorageServiceAccountAPI : StorageServiceAccountAPIProtocol {
   let endpoint = "https://storage.googleapis.com/storage/v1/"
   let request : GoogleCloudStorageRequest

   init(request: GoogleCloudStorageRequest) {
      self.request = request
   }

   /// Get the email address of this project's Google Cloud Storage service account.
   /// - Parameter projectId: Project ID

   public func get(projectId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageServiceAccount> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)projects/\(projectId)/serviceAccount", query: queryParams)
   }
}

public protocol StorageServiceAccountAPIProtocol  {
   /// Get the email address of this project's Google Cloud Storage service account.
   func get(projectId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudStorageServiceAccount>
}
extension StorageServiceAccountAPIProtocol   {
      public func get(projectId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudStorageServiceAccount> {
      get(projectId: projectId,  queryParameters: queryParameters)
   }

}
public struct GoogleCloudStorageEmptyResponse : GoogleCloudModel {}
public struct GoogleCloudStorageBucket : GoogleCloudModel {
   /*Access controls on the bucket. */
   public var acl: [GoogleCloudStorageBucketAccessControl]?
   /*The bucket's billing configuration. */
   public var billing: GoogleCloudStorageBucketBilling?
   /*The bucket's Cross-Origin Resource Sharing (CORS) configuration. */
   public var cors: [GoogleCloudStorageBucketCors]?
   /*The default value for event-based hold on newly created objects in this bucket. Event-based hold is a way to retain objects indefinitely until an event occurs, signified by the hold's release. After being released, such objects will be subject to bucket-level retention (if any). One sample use case of this flag is for banks to hold loan documents for at least 3 years after loan is paid in full. Here, bucket-level retention is 3 years and the event is loan being paid in full. In this example, these objects will be held intact for any number of years until the event has occurred (event-based hold on the object is released) and then 3 more years after that. That means retention duration of the objects begins from the moment event-based hold transitioned from true to false. Objects under event-based hold cannot be deleted, overwritten or archived until the hold is removed. */
   public var defaultEventBasedHold: Bool?
   /*Default access controls to apply to new objects when no ACL is provided. */
   public var defaultObjectAcl: [GoogleCloudStorageObjectAccessControl]?
   /*Encryption configuration for a bucket. */
   public var encryption: GoogleCloudStorageBucketEncryption?
   /*HTTP 1.1 Entity tag for the bucket. */
   public var etag: String?
   /*The bucket's IAM configuration. */
   public var iamConfiguration: GoogleCloudStorageBucketIamConfiguration?
   /*The ID of the bucket. For buckets, the id and name properties are the same. */
   public var id: String?
   /*The kind of item this is. For buckets, this is always storage#bucket. */
   public var kind: String?
   /*User-provided labels, in key/value pairs. */
   public var labels: [String : String]?
   /*The bucket's lifecycle configuration. See lifecycle management for more information. */
   public var lifecycle: GoogleCloudStorageBucketLifecycle?
   /*The location of the bucket. Object data for objects in the bucket resides in physical storage within this region. Defaults to US. See the developer's guide for the authoritative list. */
   public var location: String?
   /*The type of the bucket location. */
   public var locationType: String?
   /*The bucket's logging configuration, which defines the destination bucket and optional name prefix for the current bucket's logs. */
   public var logging: GoogleCloudStorageBucketLogging?
   /*The metadata generation of this bucket. */
   @CodingUses<Coder> public var metageneration: Int?
   /*The name of the bucket. */
   public var name: String?
   /*The owner of the bucket. This is always the project team's owner group. */
   public var owner: GoogleCloudStorageBucketOwner?
   /*The project number of the project the bucket belongs to. */
   @CodingUses<Coder> public var projectNumber: UInt?
   /*The bucket's retention policy. The retention policy enforces a minimum retention time for all objects contained in the bucket, based on their creation time. Any attempt to overwrite or delete objects younger than the retention period will result in a PERMISSION_DENIED error. An unlocked retention policy can be modified or removed from the bucket via a storage.buckets.update operation. A locked retention policy cannot be removed or shortened in duration for the lifetime of the bucket. Attempting to remove or decrease period of a locked retention policy will result in a PERMISSION_DENIED error. */
   public var retentionPolicy: GoogleCloudStorageBucketRetentionPolicy?
   /*The URI of this bucket. */
   public var selfLink: String?
   /*The bucket's default storage class, used whenever no storageClass is specified for a newly-created object. This defines how objects in the bucket are stored and determines the SLA and the cost of storage. Values include MULTI_REGIONAL, REGIONAL, STANDARD, NEARLINE, COLDLINE, ARCHIVE, and DURABLE_REDUCED_AVAILABILITY. If this value is not specified when the bucket is created, it will default to STANDARD. For more information, see storage classes. */
   public var storageClass: String?
   /*The creation time of the bucket in RFC 3339 format. */
   @CodingUses<Coder> public var timeCreated: String?
   /*The modification time of the bucket in RFC 3339 format. */
   @CodingUses<Coder> public var updated: String?
   /*The bucket's versioning configuration. */
   public var versioning: GoogleCloudStorageBucketVersioning?
   /*The bucket's website configuration, controlling how the service behaves when accessing bucket contents as a web site. See the Static Website Examples for more information. */
   public var website: GoogleCloudStorageBucketWebsite?
}
public struct GoogleCloudStorageBucketAccessControl : GoogleCloudModel {
   /*The name of the bucket. */
   public var bucket: String?
   /*The domain associated with the entity, if any. */
   public var domain: String?
   /*The email address associated with the entity, if any. */
   public var email: String?
   /*The entity holding the permission, in one of the following forms: 
- user-userId 
- user-email 
- group-groupId 
- group-email 
- domain-domain 
- project-team-projectId 
- allUsers 
- allAuthenticatedUsers Examples: 
- The user liz@example.com would be user-liz@example.com. 
- The group example@googlegroups.com would be group-example@googlegroups.com. 
- To refer to all members of the Google Apps for Business domain example.com, the entity would be domain-example.com. */
   public var entity: String?
   /*The ID for the entity, if any. */
   public var entityId: String?
   /*HTTP 1.1 Entity tag for the access-control entry. */
   public var etag: String?
   /*The ID of the access-control entry. */
   public var id: String?
   /*The kind of item this is. For bucket access control entries, this is always storage#bucketAccessControl. */
   public var kind: String?
   /*The project team associated with the entity, if any. */
   public var projectTeam: GoogleCloudStorageBucketAccessControlProjectTeam?
   /*The access permission for the entity. */
   public var role: String?
   /*The link to this access-control entry. */
   public var selfLink: String?
}
public struct GoogleCloudStorageBucketAccessControls : GoogleCloudModel {
   /*The list of items. */
   public var items: [GoogleCloudStorageBucketAccessControl]?
   /*The kind of item this is. For lists of bucket access control entries, this is always storage#bucketAccessControls. */
   public var kind: String?
}
public struct GoogleCloudStorageBuckets : GoogleCloudModel {
   /*The list of items. */
   public var items: [GoogleCloudStorageBucket]?
   /*The kind of item this is. For lists of buckets, this is always storage#buckets. */
   public var kind: String?
   /*The continuation token, used to page through large result sets. Provide this value in a subsequent request to return the next page of results. */
   public var nextPageToken: String?
}
public struct GoogleCloudStorageChannel : GoogleCloudModel {
   /*The address where notifications are delivered for this channel. */
   public var address: String?
   /*Date and time of notification channel expiration, expressed as a Unix timestamp, in milliseconds. Optional. */
   @CodingUses<Coder> public var expiration: Int?
   /*A UUID or similar unique string that identifies this channel. */
   public var id: String?
   /*Identifies this as a notification channel used to watch for changes to a resource, which is "api#channel". */
   public var kind: String?
   /*Additional parameters controlling delivery channel behavior. Optional. */
   public var params: [String : String]?
   /*A Boolean value to indicate whether payload is wanted. Optional. */
   public var payload: Bool?
   /*An opaque ID that identifies the resource being watched on this channel. Stable across different API versions. */
   public var resourceId: String?
   /*A version-specific identifier for the watched resource. */
   public var resourceUri: String?
   /*An arbitrary string delivered to the target address with each notification delivered over this channel. Optional. */
   public var token: String?
   /*The type of delivery mechanism used for this channel. */
   public var type: String?
}
public struct GoogleCloudStorageComposeRequest : GoogleCloudModel {
   /*Properties of the resulting object. */
   public var destination:  GoogleCloudStorageObject?
   /*The kind of item this is. */
   public var kind: String?
   /*The list of source objects that will be concatenated into a single object. */
   public var sourceObjects: [GoogleCloudStorageComposeRequestSourceObjects]?
}
public struct GoogleCloudStorageExpr : GoogleCloudModel {
   /*An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI. */
   public var description: String?
   /*Textual representation of an expression in Common Expression Language syntax. The application context of the containing message determines which well-known feature set of CEL is supported. */
   public var expression: String?
   /*An optional string indicating the location of the expression for error reporting, e.g. a file name and a position in the file. */
   public var location: String?
   /*An optional title for the expression, i.e. a short string describing its purpose. This can be used e.g. in UIs which allow to enter the expression. */
   public var title: String?
}
public struct GoogleCloudStorageHmacKey : GoogleCloudModel {
   /*The kind of item this is. For HMAC keys, this is always storage#hmacKey. */
   public var kind: String?
   /*Key metadata. */
   public var metadata:  GoogleCloudStorageHmacKeyMetadata?
   /*HMAC secret key material. */
   public var secret: String?
}
public struct GoogleCloudStorageHmacKeyMetadata : GoogleCloudModel {
   /*The ID of the HMAC Key. */
   public var accessId: String?
   /*HTTP 1.1 Entity tag for the HMAC key. */
   public var etag: String?
   /*The ID of the HMAC key, including the Project ID and the Access ID. */
   public var id: String?
   /*The kind of item this is. For HMAC Key metadata, this is always storage#hmacKeyMetadata. */
   public var kind: String?
   /*Project ID owning the service account to which the key authenticates. */
   public var projectId: String?
   /*The link to this resource. */
   public var selfLink: String?
   /*The email address of the key's associated service account. */
   public var serviceAccountEmail: String?
   /*The state of the key. Can be one of ACTIVE, INACTIVE, or DELETED. */
   public var state: String?
   /*The creation time of the HMAC key in RFC 3339 format. */
   @CodingUses<Coder> public var timeCreated: String?
   /*The last modification time of the HMAC key metadata in RFC 3339 format. */
   @CodingUses<Coder> public var updated: String?
}
public struct GoogleCloudStorageHmacKeysMetadata : GoogleCloudModel {
   /*The list of items. */
   public var items: [GoogleCloudStorageHmacKeyMetadata]?
   /*The kind of item this is. For lists of hmacKeys, this is always storage#hmacKeysMetadata. */
   public var kind: String?
   /*The continuation token, used to page through large result sets. Provide this value in a subsequent request to return the next page of results. */
   public var nextPageToken: String?
}
public struct GoogleCloudStorageNotification : GoogleCloudModel {
   /*An optional list of additional attributes to attach to each Cloud PubSub message published for this notification subscription. */
   public var custom_attributes: [String : String]?
   /*HTTP 1.1 Entity tag for this subscription notification. */
   public var etag: String?
   /*If present, only send notifications about listed event types. If empty, sent notifications for all event types. */
   public var event_types: [String]?
   /*The ID of the notification. */
   public var id: String?
   /*The kind of item this is. For notifications, this is always storage#notification. */
   public var kind: String?
   /*If present, only apply this notification configuration to object names that begin with this prefix. */
   public var object_name_prefix: String?
   /*The desired content of the Payload. */
   public var payload_format: String?
   /*The canonical URL of this notification. */
   public var selfLink: String?
   /*The Cloud PubSub topic to which this subscription publishes. Formatted as: '//pubsub.googleapis.com/projects/{project-identifier}/topics/{my-topic}' */
   public var topic: String?
}
public struct GoogleCloudStorageNotifications : GoogleCloudModel {
   /*The list of items. */
   public var items: [GoogleCloudStorageNotification]?
   /*The kind of item this is. For lists of notifications, this is always storage#notifications. */
   public var kind: String?
}
public struct GoogleCloudStorageObject : GoogleCloudModel {
   /*Access controls on the object. */
   public var acl: [GoogleCloudStorageObjectAccessControl]?
   /*The name of the bucket containing this object. */
   public var bucket: String?
   /*Cache-Control directive for the object data. If omitted, and the object is accessible to all anonymous users, the default will be public, max-age=3600. */
   public var cacheControl: String?
   /*Number of underlying components that make up this object. Components are accumulated by compose operations. */
   @CodingUses<Coder> public var componentCount: Int?
   /*Content-Disposition of the object data. */
   public var contentDisposition: String?
   /*Content-Encoding of the object data. */
   public var contentEncoding: String?
   /*Content-Language of the object data. */
   public var contentLanguage: String?
   /*Content-Type of the object data. If an object is stored without a Content-Type, it is served as application/octet-stream. */
   public var contentType: String?
   /*CRC32c checksum, as described in RFC 4960, Appendix B; encoded using base64 in big-endian byte order. For more information about using the CRC32c checksum, see Hashes and ETags: Best Practices. */
   public var crc32c: String?
   /*Metadata of customer-supplied encryption key, if the object is encrypted by such a key. */
   public var customerEncryption: GoogleCloudStorageObjectCustomerEncryption?
   /*HTTP 1.1 Entity tag for the object. */
   public var etag: String?
   /*Whether an object is under event-based hold. Event-based hold is a way to retain objects until an event occurs, which is signified by the hold's release (i.e. this value is set to false). After being released (set to false), such objects will be subject to bucket-level retention (if any). One sample use case of this flag is for banks to hold loan documents for at least 3 years after loan is paid in full. Here, bucket-level retention is 3 years and the event is the loan being paid in full. In this example, these objects will be held intact for any number of years until the event has occurred (event-based hold on the object is released) and then 3 more years after that. That means retention duration of the objects begins from the moment event-based hold transitioned from true to false. */
   public var eventBasedHold: Bool?
   /*The content generation of this object. Used for object versioning. */
   @CodingUses<Coder> public var generation: Int?
   /*The ID of the object, including the bucket name, object name, and generation number. */
   public var id: String?
   /*The kind of item this is. For objects, this is always storage#object. */
   public var kind: String?
   /*Cloud KMS Key used to encrypt this object, if the object is encrypted by such a key. */
   public var kmsKeyName: String?
   /*MD5 hash of the data; encoded using base64. For more information about using the MD5 hash, see Hashes and ETags: Best Practices. */
   public var md5Hash: String?
   /*Media download link. */
   public var mediaLink: String?
   /*User-provided metadata, in key/value pairs. */
   public var metadata: [String : String]?
   /*The version of the metadata for this object at this generation. Used for preconditions and for detecting changes in metadata. A metageneration number is only meaningful in the context of a particular generation of a particular object. */
   @CodingUses<Coder> public var metageneration: Int?
   /*The name of the object. Required if not specified by URL parameter. */
   public var name: String?
   /*The owner of the object. This will always be the uploader of the object. */
   public var owner: GoogleCloudStorageObjectOwner?
   /*A server-determined value that specifies the earliest time that the object's retention period expires. This value is in RFC 3339 format. Note 1: This field is not provided for objects with an active event-based hold, since retention expiration is unknown until the hold is removed. Note 2: This value can be provided even when temporary hold is set (so that the user can reason about policy without having to first unset the temporary hold). */
   @CodingUses<Coder> public var retentionExpirationTime: String?
   /*The link to this object. */
   public var selfLink: String?
   /*Content-Length of the data in bytes. */
   @CodingUses<Coder> public var size: UInt?
   /*Storage class of the object. */
   public var storageClass: String?
   /*Whether an object is under temporary hold. While this flag is set to true, the object is protected against deletion and overwrites. A common use case of this flag is regulatory investigations where objects need to be retained while the investigation is ongoing. Note that unlike event-based hold, temporary hold does not impact retention expiration time of an object. */
   public var temporaryHold: Bool?
   /*The creation time of the object in RFC 3339 format. */
   @CodingUses<Coder> public var timeCreated: String?
   /*The deletion time of the object in RFC 3339 format. Will be returned if and only if this version of the object has been deleted. */
   @CodingUses<Coder> public var timeDeleted: String?
   /*The time at which the object's storage class was last changed. When the object is initially created, it will be set to timeCreated. */
   @CodingUses<Coder> public var timeStorageClassUpdated: String?
   /*The modification time of the object metadata in RFC 3339 format. */
   @CodingUses<Coder> public var updated: String?
}
public struct GoogleCloudStorageObjectAccessControl : GoogleCloudModel {
   /*The name of the bucket. */
   public var bucket: String?
   /*The domain associated with the entity, if any. */
   public var domain: String?
   /*The email address associated with the entity, if any. */
   public var email: String?
   /*The entity holding the permission, in one of the following forms: 
- user-userId 
- user-email 
- group-groupId 
- group-email 
- domain-domain 
- project-team-projectId 
- allUsers 
- allAuthenticatedUsers Examples: 
- The user liz@example.com would be user-liz@example.com. 
- The group example@googlegroups.com would be group-example@googlegroups.com. 
- To refer to all members of the Google Apps for Business domain example.com, the entity would be domain-example.com. */
   public var entity: String?
   /*The ID for the entity, if any. */
   public var entityId: String?
   /*HTTP 1.1 Entity tag for the access-control entry. */
   public var etag: String?
   /*The content generation of the object, if applied to an object. */
   @CodingUses<Coder> public var generation: Int?
   /*The ID of the access-control entry. */
   public var id: String?
   /*The kind of item this is. For object access control entries, this is always storage#objectAccessControl. */
   public var kind: String?
   /*The name of the object, if applied to an object. */
   public var `object`: String?
   /*The project team associated with the entity, if any. */
   public var projectTeam: GoogleCloudStorageObjectAccessControlProjectTeam?
   /*The access permission for the entity. */
   public var role: String?
   /*The link to this access-control entry. */
   public var selfLink: String?
}
public struct GoogleCloudStorageObjectAccessControls : GoogleCloudModel {
   /*The list of items. */
   public var items: [GoogleCloudStorageObjectAccessControl]?
   /*The kind of item this is. For lists of object access control entries, this is always storage#objectAccessControls. */
   public var kind: String?
}
public struct GoogleCloudStorageObjects : GoogleCloudModel {
   /*The list of items. */
   public var items: [GoogleCloudStorageObject]?
   /*The kind of item this is. For lists of objects, this is always storage#objects. */
   public var kind: String?
   /*The continuation token, used to page through large result sets. Provide this value in a subsequent request to return the next page of results. */
   public var nextPageToken: String?
   /*The list of prefixes of objects matching-but-not-listed up to and including the requested delimiter. */
   public var prefixes: [String]?
}
public struct GoogleCloudStoragePolicy : GoogleCloudModel {
   /*An association between a role, which comes with a set of permissions, and members who may assume that role. */
   public var bindings: [GoogleCloudStoragePolicyBindings]?
   /*HTTP 1.1  Entity tag for the policy. */
   @CodingUses<Coder> public var etag: Data?
   /*The kind of item this is. For policies, this is always storage#policy. This field is ignored on input. */
   public var kind: String?
   /*The ID of the resource to which this policy belongs. Will be of the form projects/_/buckets/bucket for buckets, and projects/_/buckets/bucket/objects/object for objects. A specific generation may be specified by appending #generationNumber to the end of the object name, e.g. projects/_/buckets/my-bucket/objects/data.txt#17. The current generation can be denoted with #0. This field is ignored on input. */
   public var resourceId: String?
   /*The IAM policy format version. */
   @CodingUses<Coder> public var version: Int?
}
public struct GoogleCloudStorageRewriteResponse : GoogleCloudModel {
   /*true if the copy is finished; otherwise, false if the copy is in progress. This property is always present in the response. */
   public var done: Bool?
   /*The kind of item this is. */
   public var kind: String?
   /*The total size of the object being copied in bytes. This property is always present in the response. */
   @CodingUses<Coder> public var objectSize: Int?
   /*A resource containing the metadata for the copied-to object. This property is present in the response only when copying completes. */
   public var resource:  GoogleCloudStorageObject?
   /*A token to use in subsequent requests to continue copying data. This token is present in the response only when there is more data to copy. */
   public var rewriteToken: String?
   /*The total bytes written so far, which can be used to provide a waiting user with a progress indicator. This property is always present in the response. */
   @CodingUses<Coder> public var totalBytesRewritten: Int?
}
public struct GoogleCloudStorageServiceAccount : GoogleCloudModel {
   /*The ID of the notification. */
   public var email_address: String?
   /*The kind of item this is. For notifications, this is always storage#notification. */
   public var kind: String?
}
public struct GoogleCloudStorageTestIamPermissionsResponse : GoogleCloudModel {
   /*The kind of item this is. */
   public var kind: String?
   /*The permissions held by the caller. Permissions are always of the format storage.resource.capability, where resource is one of buckets or objects. The supported permissions are as follows:  
- storage.buckets.delete — Delete bucket.  
- storage.buckets.get — Read bucket metadata.  
- storage.buckets.getIamPolicy — Read bucket IAM policy.  
- storage.buckets.create — Create bucket.  
- storage.buckets.list — List buckets.  
- storage.buckets.setIamPolicy — Update bucket IAM policy.  
- storage.buckets.update — Update bucket metadata.  
- storage.objects.delete — Delete object.  
- storage.objects.get — Read object data and metadata.  
- storage.objects.getIamPolicy — Read object IAM policy.  
- storage.objects.create — Create object.  
- storage.objects.list — List objects.  
- storage.objects.setIamPolicy — Update object IAM policy.  
- storage.objects.update — Update object metadata. */
   public var permissions: [String]?
}
public struct GoogleCloudStorageBucketBilling : GoogleCloudModel {
   /*When set to true, Requester Pays is enabled for this bucket. */
   public var requesterPays: Bool?
}
public struct GoogleCloudStorageBucketCors : GoogleCloudModel {
   /*The value, in seconds, to return in the  Access-Control-Max-Age header used in preflight responses. */
   @CodingUses<Coder> public var maxAgeSeconds: Int?
   /*The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: "*" is permitted in the list of methods, and means "any method". */
   public var method: [String]?
   /*The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin". */
   public var origin: [String]?
   /*The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains. */
   public var responseHeader: [String]?
}
public struct GoogleCloudStorageBucketEncryption : GoogleCloudModel {
   /*A Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified. */
   public var defaultKmsKeyName: String?
}
public struct GoogleCloudStorageBucketIamConfiguration : GoogleCloudModel {
   /*The bucket's uniform bucket-level access configuration. The feature was formerly known as Bucket Policy Only. For backward compatibility, this field will be populated with identical information as the uniformBucketLevelAccess field. We recommend using the uniformBucketLevelAccess field to enable and disable the feature. */
   public var bucketPolicyOnly: PlaceHolderObject?
   /*The bucket's uniform bucket-level access configuration. */
   public var uniformBucketLevelAccess: PlaceHolderObject?
}
public struct GoogleCloudStorageBucketLifecycle : GoogleCloudModel {
   /*A lifecycle management rule, which is made of an action to take and the condition(s) under which the action will be taken. */
   public var rule: [PlaceHolderObject]?
}
public struct GoogleCloudStorageBucketLogging : GoogleCloudModel {
   /*The destination bucket where the current bucket's logs should be placed. */
   public var logBucket: String?
   /*A prefix for log object names. */
   public var logObjectPrefix: String?
}
public struct GoogleCloudStorageBucketOwner : GoogleCloudModel {
   /*The entity, in the form project-owner-projectId. */
   public var entity: String?
   /*The ID for the entity. */
   public var entityId: String?
}
public struct GoogleCloudStorageBucketRetentionPolicy : GoogleCloudModel {
   /*Server-determined value that indicates the time from which policy was enforced and effective. This value is in RFC 3339 format. */
   @CodingUses<Coder> public var effectiveTime: String?
   /*Once locked, an object retention policy cannot be modified. */
   public var isLocked: Bool?
   /*The duration in seconds that objects need to be retained. Retention duration must be greater than zero and less than 100 years. Note that enforcement of retention periods less than a day is not guaranteed. Such periods should only be used for testing purposes. */
   @CodingUses<Coder> public var retentionPeriod: Int?
}
public struct GoogleCloudStorageBucketVersioning : GoogleCloudModel {
   /*While set to true, versioning is fully enabled for this bucket. */
   public var enabled: Bool?
}
public struct GoogleCloudStorageBucketWebsite : GoogleCloudModel {
   /*If the requested object path is missing, the service will ensure the path has a trailing '/', append this suffix, and attempt to retrieve the resulting object. This allows the creation of index.html objects to represent directory pages. */
   public var mainPageSuffix: String?
   /*If the requested object path is missing, and any mainPageSuffix object is missing, if applicable, the service will return the named object from this bucket as the content for a 404 Not Found result. */
   public var notFoundPage: String?
}
public struct GoogleCloudStorageBucketAccessControlProjectTeam : GoogleCloudModel {
   /*The project number. */
   public var projectNumber: String?
   /*The team. */
   public var team: String?
}
public struct GoogleCloudStorageComposeRequestSourceObjects : GoogleCloudModel {
   /*The generation of this object to use as the source. */
   @CodingUses<Coder> public var generation: Int?
   /*The source object's name. All source objects must reside in the same bucket. */
   public var name: String?
   /*Conditions that must be met for this operation to execute. */
   public var objectPreconditions: PlaceHolderObject?
}
public struct GoogleCloudStorageObjectCustomerEncryption : GoogleCloudModel {
   /*The encryption algorithm. */
   public var encryptionAlgorithm: String?
   /*SHA256 hash value of the encryption key. */
   public var keySha256: String?
}
public struct GoogleCloudStorageObjectOwner : GoogleCloudModel {
   /*The entity, in the form user-userId. */
   public var entity: String?
   /*The ID for the entity. */
   public var entityId: String?
}
public struct GoogleCloudStorageObjectAccessControlProjectTeam : GoogleCloudModel {
   /*The project number. */
   public var projectNumber: String?
   /*The team. */
   public var team: String?
}
public struct GoogleCloudStoragePolicyBindings : GoogleCloudModel {
   /*The condition that is associated with this binding. NOTE: an unsatisfied condition will not allow user access via current binding. Different bindings, including their conditions, are examined independently. */
   public var condition:  GoogleCloudStorageExpr?
   /*A collection of identifiers for members who may assume the provided role. Recognized identifiers are as follows:  
- allUsers — A special identifier that represents anyone on the internet; with or without a Google account.  
- allAuthenticatedUsers — A special identifier that represents anyone who is authenticated with a Google account or a service account.  
- user:emailid — An email address that represents a specific account. For example, user:alice@gmail.com or user:joe@example.com.  
- serviceAccount:emailid — An email address that represents a service account. For example,  serviceAccount:my-other-app@appspot.gserviceaccount.com .  
- group:emailid — An email address that represents a Google group. For example, group:admins@example.com.  
- domain:domain — A Google Apps domain name that represents all the users of that domain. For example, domain:google.com or domain:example.com.  
- projectOwner:projectid — Owners of the given project. For example, projectOwner:my-example-project  
- projectEditor:projectid — Editors of the given project. For example, projectEditor:my-example-project  
- projectViewer:projectid — Viewers of the given project. For example, projectViewer:my-example-project */
   public var members: [String]?
   /*The role to which members belong. Two types of roles are supported: new IAM roles, which grant permissions that do not map directly to those provided by ACLs, and legacy IAM roles, which do map directly to ACL permissions. All roles are of the format roles/storage.specificRole.
The new IAM roles are:  
- roles/storage.admin — Full control of Google Cloud Storage resources.  
- roles/storage.objectViewer — Read-Only access to Google Cloud Storage objects.  
- roles/storage.objectCreator — Access to create objects in Google Cloud Storage.  
- roles/storage.objectAdmin — Full control of Google Cloud Storage objects.   The legacy IAM roles are:  
- roles/storage.legacyObjectReader — Read-only access to objects without listing. Equivalent to an ACL entry on an object with the READER role.  
- roles/storage.legacyObjectOwner — Read/write access to existing objects without listing. Equivalent to an ACL entry on an object with the OWNER role.  
- roles/storage.legacyBucketReader — Read access to buckets with object listing. Equivalent to an ACL entry on a bucket with the READER role.  
- roles/storage.legacyBucketWriter — Read access to buckets with object listing/creation/deletion. Equivalent to an ACL entry on a bucket with the WRITER role.  
- roles/storage.legacyBucketOwner — Read and write access to existing buckets with object listing/creation/deletion. Equivalent to an ACL entry on a bucket with the OWNER role. */
   public var role: String?
}
public final class GoogleCloudStorageClient {
   public var bucketAccessControls : StorageBucketAccessControlsAPIProtocol
   public var buckets : StorageBucketsAPIProtocol
   public var channels : StorageChannelsAPIProtocol
   public var defaultObjectAccessControls : StorageDefaultObjectAccessControlsAPIProtocol
   public var notifications : StorageNotificationsAPIProtocol
   public var objectAccessControls : StorageObjectAccessControlsAPIProtocol
   public var objects : StorageObjectsAPIProtocol
   public var projects : StorageProjectsAPIProtocol
   public var hmacKeys : StorageHmacKeysAPIProtocol
   public var serviceAccount : StorageServiceAccountAPIProtocol


   public init(credentials: GoogleCloudCredentialsConfiguration, storageConfig: GoogleCloudStorageConfiguration, httpClient: HTTPClient, eventLoop: EventLoop) throws {
      let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: storageConfig, andClient: httpClient, eventLoop: eventLoop)
      guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
               (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
               storageConfig.project ?? credentials.project else {
         throw GoogleCloudInternalError.projectIdMissing
      }

      let request = GoogleCloudStorageRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)


      bucketAccessControls = GoogleCloudStorageBucketAccessControlsAPI(request: request)
      buckets = GoogleCloudStorageBucketsAPI(request: request)
      channels = GoogleCloudStorageChannelsAPI(request: request)
      defaultObjectAccessControls = GoogleCloudStorageDefaultObjectAccessControlsAPI(request: request)
      notifications = GoogleCloudStorageNotificationsAPI(request: request)
      objectAccessControls = GoogleCloudStorageObjectAccessControlsAPI(request: request)
      objects = GoogleCloudStorageObjectsAPI(request: request)
      projects = GoogleCloudStorageProjectsAPI(request: request)
      hmacKeys = GoogleCloudStorageHmacKeysAPI(request: request)
      serviceAccount = GoogleCloudStorageServiceAccountAPI(request: request)
   }
}

