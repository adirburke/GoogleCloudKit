// This is Generated Code


import Foundation
import AsyncHTTPClient
import NIO
import Core
import NIOFoundationCompat
import NIOHTTP1


public enum GoogleCloudDriveScope : GoogleCloudAPIScope {
   public var value : String {
      switch self {
      case .DriveScripts: return "https://www.googleapis.com/auth/drive.scripts"
      case .Drive: return "https://www.googleapis.com/auth/drive"
      case .DriveMetadata: return "https://www.googleapis.com/auth/drive.metadata"
      case .DriveReadonly: return "https://www.googleapis.com/auth/drive.readonly"
      case .DriveMetadataReadonly: return "https://www.googleapis.com/auth/drive.metadata.readonly"
      case .DrivePhotosReadonly: return "https://www.googleapis.com/auth/drive.photos.readonly"
      case .DriveFile: return "https://www.googleapis.com/auth/drive.file"
      case .DriveAppdata: return "https://www.googleapis.com/auth/drive.appdata"
      }
   }

   case DriveScripts // Modify your Google Apps Script scripts' behavior
   case Drive // See, edit, create, and delete all of your Google Drive files
   case DriveMetadata // View and manage metadata of files in your Google Drive
   case DriveReadonly // See and download all your Google Drive files
   case DriveMetadataReadonly // View metadata for files in your Google Drive
   case DrivePhotosReadonly // View the photos, videos and albums in your Google Photos
   case DriveFile // View and manage Google Drive files and folders that you have opened or created with this app
   case DriveAppdata // View and manage its own configuration data in your Google Drive
}


public struct GoogleCloudDriveConfiguration : GoogleCloudAPIConfiguration {
   public var scope : [GoogleCloudAPIScope]
   public var serviceAccount: String
   public var project: String?
   public var subscription: String?

   public init(scope: [GoogleCloudDriveScope], serviceAccount : String, project: String?, subscription: String?) {
      self.scope = scope
      self.serviceAccount = serviceAccount
      self.project = project
      self.subscription = subscription
   }
}


public final class GoogleCloudDriveRequest : GoogleCloudAPIRequest {
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
public final class GoogleCloudDriveAboutAPI : DriveAboutAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Gets information about the user, the user's Drive, and system capabilities.
   
   public func get( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveAbout> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)about", query: queryParams)
   }
}

public protocol DriveAboutAPIProtocol  {
   /// Gets information about the user, the user's Drive, and system capabilities.
   func get( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveAbout>
}
extension DriveAboutAPIProtocol   {
      public func get( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveAbout> {
      get(  queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveChangesAPI : DriveChangesAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Gets the starting pageToken for listing future changes.
   
   public func getStartPageToken( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveStartPageToken> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)changes/startPageToken", query: queryParams)
   }
   /// Lists the changes for a user or shared drive.
   /// - Parameter pageToken: The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.

   public func list(pageToken : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveChangeList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)changes", query: queryParams)
   }
   /// Subscribes to changes for a user.
   /// - Parameter pageToken: The token for continuing a previous list request on the next page. This should be set to the value of 'nextPageToken' from the previous response or to the response from the getStartPageToken method.

   public func watch(pageToken : String, body : GoogleCloudDriveChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)changes/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DriveChangesAPIProtocol  {
   /// Gets the starting pageToken for listing future changes.
   func getStartPageToken( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveStartPageToken>
   /// Lists the changes for a user or shared drive.
   func list(pageToken : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveChangeList>
   /// Subscribes to changes for a user.
   func watch(pageToken : String, body : GoogleCloudDriveChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveChannel>
}
extension DriveChangesAPIProtocol   {
      public func getStartPageToken( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveStartPageToken> {
      getStartPageToken(  queryParameters: queryParameters)
   }

      public func list(pageToken : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveChangeList> {
      list(pageToken: pageToken,  queryParameters: queryParameters)
   }

      public func watch(pageToken : String, body : GoogleCloudDriveChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveChannel> {
      watch(pageToken: pageToken, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveChannelsAPI : DriveChannelsAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Stop watching resources through this channel
   
   public func stop(body : GoogleCloudDriveChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
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

public protocol DriveChannelsAPIProtocol  {
   /// Stop watching resources through this channel
   func stop(body : GoogleCloudDriveChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
}
extension DriveChannelsAPIProtocol   {
      public func stop(body : GoogleCloudDriveChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      stop( body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveCommentsAPI : DriveCommentsAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Creates a new comment on a file.
   /// - Parameter fileId: The ID of the file.

   public func create(fileId : String, body : GoogleCloudDriveComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveComment> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)files/\(fileId)/comments", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Deletes a comment.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.

   public func delete(fileId : String, commentId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)files/\(fileId)/comments/\(commentId)", query: queryParams)
   }
   /// Gets a comment by ID.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.

   public func get(fileId : String, commentId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveComment> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/comments/\(commentId)", query: queryParams)
   }
   /// Lists a file's comments.
   /// - Parameter fileId: The ID of the file.

   public func list(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveCommentList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/comments", query: queryParams)
   }
   /// Updates a comment with patch semantics.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.

   public func update(fileId : String, commentId : String, body : GoogleCloudDriveComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveComment> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)files/\(fileId)/comments/\(commentId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DriveCommentsAPIProtocol  {
   /// Creates a new comment on a file.
   func create(fileId : String, body : GoogleCloudDriveComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveComment>
   /// Deletes a comment.
   func delete(fileId : String, commentId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Gets a comment by ID.
   func get(fileId : String, commentId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveComment>
   /// Lists a file's comments.
   func list(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveCommentList>
   /// Updates a comment with patch semantics.
   func update(fileId : String, commentId : String, body : GoogleCloudDriveComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveComment>
}
extension DriveCommentsAPIProtocol   {
      public func create(fileId : String, body : GoogleCloudDriveComment, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveComment> {
      create(fileId: fileId, body: body, queryParameters: queryParameters)
   }

      public func delete(fileId : String, commentId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      delete(fileId: fileId,commentId: commentId,  queryParameters: queryParameters)
   }

      public func get(fileId : String, commentId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveComment> {
      get(fileId: fileId,commentId: commentId,  queryParameters: queryParameters)
   }

      public func list(fileId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveCommentList> {
      list(fileId: fileId,  queryParameters: queryParameters)
   }

      public func update(fileId : String, commentId : String, body : GoogleCloudDriveComment, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveComment> {
      update(fileId: fileId,commentId: commentId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveDrivesAPI : DriveDrivesAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Creates a new shared drive.
   /// - Parameter requestId: An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a shared drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same shared drive. If the shared drive already exists a 409 error will be returned.

   public func create(requestId : String, body : GoogleCloudDriveDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)drives", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
   /// - Parameter driveId: The ID of the shared drive.

   public func delete(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)drives/\(driveId)", query: queryParams)
   }
   /// Gets a shared drive's metadata by ID.
   /// - Parameter driveId: The ID of the shared drive.

   public func get(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)drives/\(driveId)", query: queryParams)
   }
   /// Hides a shared drive from the default view.
   /// - Parameter driveId: The ID of the shared drive.

   public func hide(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)drives/\(driveId)/hide", query: queryParams)
   }
   /// Lists the user's shared drives.
   
   public func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDriveList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)drives", query: queryParams)
   }
   /// Restores a shared drive to the default view.
   /// - Parameter driveId: The ID of the shared drive.

   public func unhide(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)drives/\(driveId)/unhide", query: queryParams)
   }
   /// Updates the metadate for a shared drive.
   /// - Parameter driveId: The ID of the shared drive.

   public func update(driveId : String, body : GoogleCloudDriveDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)drives/\(driveId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DriveDrivesAPIProtocol  {
   /// Creates a new shared drive.
   func create(requestId : String, body : GoogleCloudDriveDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive>
   /// Permanently deletes a shared drive for which the user is an organizer. The shared drive cannot contain any untrashed items.
   func delete(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Gets a shared drive's metadata by ID.
   func get(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive>
   /// Hides a shared drive from the default view.
   func hide(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive>
   /// Lists the user's shared drives.
   func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDriveList>
   /// Restores a shared drive to the default view.
   func unhide(driveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive>
   /// Updates the metadate for a shared drive.
   func update(driveId : String, body : GoogleCloudDriveDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveDrive>
}
extension DriveDrivesAPIProtocol   {
      public func create(requestId : String, body : GoogleCloudDriveDrive, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveDrive> {
      create(requestId: requestId, body: body, queryParameters: queryParameters)
   }

      public func delete(driveId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      delete(driveId: driveId,  queryParameters: queryParameters)
   }

      public func get(driveId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveDrive> {
      get(driveId: driveId,  queryParameters: queryParameters)
   }

      public func hide(driveId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveDrive> {
      hide(driveId: driveId,  queryParameters: queryParameters)
   }

      public func list( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveDriveList> {
      list(  queryParameters: queryParameters)
   }

      public func unhide(driveId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveDrive> {
      unhide(driveId: driveId,  queryParameters: queryParameters)
   }

      public func update(driveId : String, body : GoogleCloudDriveDrive, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveDrive> {
      update(driveId: driveId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveFilesAPI : DriveFilesAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Creates a copy of a file and applies any requested updates with patch semantics.
   /// - Parameter fileId: The ID of the file.

   public func copy(fileId : String, body : GoogleCloudDriveFile, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)files/\(fileId)/copy", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Creates a new file.
   
   public func create(body : GoogleCloudDriveFile, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)files", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
   /// - Parameter fileId: The ID of the file.

   public func delete(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)files/\(fileId)", query: queryParams)
   }
   /// Permanently deletes all of the user's trashed files.
   
   public func emptyTrash( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)files/trash", query: queryParams)
   }
   /// Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
   /// - Parameter fileId: The ID of the file.
/// - Parameter mimeType: The MIME type of the format requested for this export.

   public func export(fileId : String, mimeType : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/export", query: queryParams)
   }
   /// Generates a set of file IDs which can be provided in create or copy requests.
   
   public func generateIds( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveGeneratedIds> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/generateIds", query: queryParams)
   }
   /// Gets a file's metadata or content by ID.
   /// - Parameter fileId: The ID of the file.

   public func get(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)", query: queryParams)
   }
   /// Lists or searches files.
   
   public func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFileList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files", query: queryParams)
   }
   /// Updates a file's metadata and/or content with patch semantics.
   /// - Parameter fileId: The ID of the file.

   public func update(fileId : String, body : GoogleCloudDriveFile, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)files/\(fileId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Subscribes to changes to a file
   /// - Parameter fileId: The ID of the file.

   public func watch(fileId : String, body : GoogleCloudDriveChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)files/\(fileId)/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DriveFilesAPIProtocol  {
   /// Creates a copy of a file and applies any requested updates with patch semantics.
   func copy(fileId : String, body : GoogleCloudDriveFile, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile>
   /// Creates a new file.
   func create(body : GoogleCloudDriveFile, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile>
   /// Permanently deletes a file owned by the user without moving it to the trash. If the file belongs to a shared drive the user must be an organizer on the parent. If the target is a folder, all descendants owned by the user are also deleted.
   func delete(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Permanently deletes all of the user's trashed files.
   func emptyTrash( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
   func export(fileId : String, mimeType : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Generates a set of file IDs which can be provided in create or copy requests.
   func generateIds( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveGeneratedIds>
   /// Gets a file's metadata or content by ID.
   func get(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile>
   /// Lists or searches files.
   func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFileList>
   /// Updates a file's metadata and/or content with patch semantics.
   func update(fileId : String, body : GoogleCloudDriveFile, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveFile>
   /// Subscribes to changes to a file
   func watch(fileId : String, body : GoogleCloudDriveChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveChannel>
}
extension DriveFilesAPIProtocol   {
      public func copy(fileId : String, body : GoogleCloudDriveFile, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveFile> {
      copy(fileId: fileId, body: body, queryParameters: queryParameters)
   }

      public func create(body : GoogleCloudDriveFile, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveFile> {
      create( body: body, queryParameters: queryParameters)
   }

      public func delete(fileId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      delete(fileId: fileId,  queryParameters: queryParameters)
   }

      public func emptyTrash( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      emptyTrash(  queryParameters: queryParameters)
   }

      public func export(fileId : String, mimeType : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      export(fileId: fileId,mimeType: mimeType,  queryParameters: queryParameters)
   }

      public func generateIds( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveGeneratedIds> {
      generateIds(  queryParameters: queryParameters)
   }

      public func get(fileId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveFile> {
      get(fileId: fileId,  queryParameters: queryParameters)
   }

      public func list( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveFileList> {
      list(  queryParameters: queryParameters)
   }

      public func update(fileId : String, body : GoogleCloudDriveFile, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveFile> {
      update(fileId: fileId, body: body, queryParameters: queryParameters)
   }

      public func watch(fileId : String, body : GoogleCloudDriveChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveChannel> {
      watch(fileId: fileId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDrivePermissionsAPI : DrivePermissionsAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Creates a permission for a file or shared drive.
   /// - Parameter fileId: The ID of the file or shared drive.

   public func create(fileId : String, body : GoogleCloudDrivePermission, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermission> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)files/\(fileId)/permissions", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Deletes a permission.
   /// - Parameter fileId: The ID of the file or shared drive.
/// - Parameter permissionId: The ID of the permission.

   public func delete(fileId : String, permissionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)files/\(fileId)/permissions/\(permissionId)", query: queryParams)
   }
   /// Gets a permission by ID.
   /// - Parameter fileId: The ID of the file.
/// - Parameter permissionId: The ID of the permission.

   public func get(fileId : String, permissionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermission> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/permissions/\(permissionId)", query: queryParams)
   }
   /// Lists a file's or shared drive's permissions.
   /// - Parameter fileId: The ID of the file or shared drive.

   public func list(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermissionList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/permissions", query: queryParams)
   }
   /// Updates a permission with patch semantics.
   /// - Parameter fileId: The ID of the file or shared drive.
/// - Parameter permissionId: The ID of the permission.

   public func update(fileId : String, permissionId : String, body : GoogleCloudDrivePermission, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermission> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)files/\(fileId)/permissions/\(permissionId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DrivePermissionsAPIProtocol  {
   /// Creates a permission for a file or shared drive.
   func create(fileId : String, body : GoogleCloudDrivePermission, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermission>
   /// Deletes a permission.
   func delete(fileId : String, permissionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Gets a permission by ID.
   func get(fileId : String, permissionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermission>
   /// Lists a file's or shared drive's permissions.
   func list(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermissionList>
   /// Updates a permission with patch semantics.
   func update(fileId : String, permissionId : String, body : GoogleCloudDrivePermission, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDrivePermission>
}
extension DrivePermissionsAPIProtocol   {
      public func create(fileId : String, body : GoogleCloudDrivePermission, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDrivePermission> {
      create(fileId: fileId, body: body, queryParameters: queryParameters)
   }

      public func delete(fileId : String, permissionId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      delete(fileId: fileId,permissionId: permissionId,  queryParameters: queryParameters)
   }

      public func get(fileId : String, permissionId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDrivePermission> {
      get(fileId: fileId,permissionId: permissionId,  queryParameters: queryParameters)
   }

      public func list(fileId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDrivePermissionList> {
      list(fileId: fileId,  queryParameters: queryParameters)
   }

      public func update(fileId : String, permissionId : String, body : GoogleCloudDrivePermission, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDrivePermission> {
      update(fileId: fileId,permissionId: permissionId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveRepliesAPI : DriveRepliesAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Creates a new reply to a comment.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.

   public func create(fileId : String, commentId : String, body : GoogleCloudDriveReply, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReply> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)files/\(fileId)/comments/\(commentId)/replies", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Deletes a reply.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.
/// - Parameter replyId: The ID of the reply.

   public func delete(fileId : String, commentId : String, replyId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)files/\(fileId)/comments/\(commentId)/replies/\(replyId)", query: queryParams)
   }
   /// Gets a reply by ID.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.
/// - Parameter replyId: The ID of the reply.

   public func get(fileId : String, commentId : String, replyId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReply> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/comments/\(commentId)/replies/\(replyId)", query: queryParams)
   }
   /// Lists a comment's replies.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.

   public func list(fileId : String, commentId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReplyList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/comments/\(commentId)/replies", query: queryParams)
   }
   /// Updates a reply with patch semantics.
   /// - Parameter fileId: The ID of the file.
/// - Parameter commentId: The ID of the comment.
/// - Parameter replyId: The ID of the reply.

   public func update(fileId : String, commentId : String, replyId : String, body : GoogleCloudDriveReply, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReply> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)files/\(fileId)/comments/\(commentId)/replies/\(replyId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DriveRepliesAPIProtocol  {
   /// Creates a new reply to a comment.
   func create(fileId : String, commentId : String, body : GoogleCloudDriveReply, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReply>
   /// Deletes a reply.
   func delete(fileId : String, commentId : String, replyId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Gets a reply by ID.
   func get(fileId : String, commentId : String, replyId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReply>
   /// Lists a comment's replies.
   func list(fileId : String, commentId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReplyList>
   /// Updates a reply with patch semantics.
   func update(fileId : String, commentId : String, replyId : String, body : GoogleCloudDriveReply, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveReply>
}
extension DriveRepliesAPIProtocol   {
      public func create(fileId : String, commentId : String, body : GoogleCloudDriveReply, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveReply> {
      create(fileId: fileId,commentId: commentId, body: body, queryParameters: queryParameters)
   }

      public func delete(fileId : String, commentId : String, replyId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      delete(fileId: fileId,commentId: commentId,replyId: replyId,  queryParameters: queryParameters)
   }

      public func get(fileId : String, commentId : String, replyId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveReply> {
      get(fileId: fileId,commentId: commentId,replyId: replyId,  queryParameters: queryParameters)
   }

      public func list(fileId : String, commentId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveReplyList> {
      list(fileId: fileId,commentId: commentId,  queryParameters: queryParameters)
   }

      public func update(fileId : String, commentId : String, replyId : String, body : GoogleCloudDriveReply, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveReply> {
      update(fileId: fileId,commentId: commentId,replyId: replyId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveRevisionsAPI : DriveRevisionsAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
   /// - Parameter fileId: The ID of the file.
/// - Parameter revisionId: The ID of the revision.

   public func delete(fileId : String, revisionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)files/\(fileId)/revisions/\(revisionId)", query: queryParams)
   }
   /// Gets a revision's metadata or content by ID.
   /// - Parameter fileId: The ID of the file.
/// - Parameter revisionId: The ID of the revision.

   public func get(fileId : String, revisionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveRevision> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/revisions/\(revisionId)", query: queryParams)
   }
   /// Lists a file's revisions.
   /// - Parameter fileId: The ID of the file.

   public func list(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveRevisionList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)files/\(fileId)/revisions", query: queryParams)
   }
   /// Updates a revision with patch semantics.
   /// - Parameter fileId: The ID of the file.
/// - Parameter revisionId: The ID of the revision.

   public func update(fileId : String, revisionId : String, body : GoogleCloudDriveRevision, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveRevision> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)files/\(fileId)/revisions/\(revisionId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DriveRevisionsAPIProtocol  {
   /// Permanently deletes a file version. You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.
   func delete(fileId : String, revisionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Gets a revision's metadata or content by ID.
   func get(fileId : String, revisionId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveRevision>
   /// Lists a file's revisions.
   func list(fileId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveRevisionList>
   /// Updates a revision with patch semantics.
   func update(fileId : String, revisionId : String, body : GoogleCloudDriveRevision, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveRevision>
}
extension DriveRevisionsAPIProtocol   {
      public func delete(fileId : String, revisionId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      delete(fileId: fileId,revisionId: revisionId,  queryParameters: queryParameters)
   }

      public func get(fileId : String, revisionId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveRevision> {
      get(fileId: fileId,revisionId: revisionId,  queryParameters: queryParameters)
   }

      public func list(fileId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveRevisionList> {
      list(fileId: fileId,  queryParameters: queryParameters)
   }

      public func update(fileId : String, revisionId : String, body : GoogleCloudDriveRevision, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveRevision> {
      update(fileId: fileId,revisionId: revisionId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudDriveTeamdrivesAPI : DriveTeamdrivesAPIProtocol {
   let endpoint = "https://www.googleapis.com/drive/v3/"
   let request : GoogleCloudDriveRequest

   init(request: GoogleCloudDriveRequest) {
      self.request = request
   }

   /// Deprecated use drives.create instead.
   /// - Parameter requestId: An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.

   public func create(requestId : String, body : GoogleCloudDriveTeamDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)teamdrives", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Deprecated use drives.delete instead.
   /// - Parameter teamDriveId: The ID of the Team Drive

   public func delete(teamDriveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)teamdrives/\(teamDriveId)", query: queryParams)
   }
   /// Deprecated use drives.get instead.
   /// - Parameter teamDriveId: The ID of the Team Drive

   public func get(teamDriveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)teamdrives/\(teamDriveId)", query: queryParams)
   }
   /// Deprecated use drives.list instead.
   
   public func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDriveList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)teamdrives", query: queryParams)
   }
   /// Deprecated use drives.update instead
   /// - Parameter teamDriveId: The ID of the Team Drive

   public func update(teamDriveId : String, body : GoogleCloudDriveTeamDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDrive> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)teamdrives/\(teamDriveId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DriveTeamdrivesAPIProtocol  {
   /// Deprecated use drives.create instead.
   func create(requestId : String, body : GoogleCloudDriveTeamDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDrive>
   /// Deprecated use drives.delete instead.
   func delete(teamDriveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveEmptyResponse>
   /// Deprecated use drives.get instead.
   func get(teamDriveId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDrive>
   /// Deprecated use drives.list instead.
   func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDriveList>
   /// Deprecated use drives.update instead
   func update(teamDriveId : String, body : GoogleCloudDriveTeamDrive, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudDriveTeamDrive>
}
extension DriveTeamdrivesAPIProtocol   {
      public func create(requestId : String, body : GoogleCloudDriveTeamDrive, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveTeamDrive> {
      create(requestId: requestId, body: body, queryParameters: queryParameters)
   }

      public func delete(teamDriveId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveEmptyResponse> {
      delete(teamDriveId: teamDriveId,  queryParameters: queryParameters)
   }

      public func get(teamDriveId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveTeamDrive> {
      get(teamDriveId: teamDriveId,  queryParameters: queryParameters)
   }

      public func list( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveTeamDriveList> {
      list(  queryParameters: queryParameters)
   }

      public func update(teamDriveId : String, body : GoogleCloudDriveTeamDrive, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudDriveTeamDrive> {
      update(teamDriveId: teamDriveId, body: body, queryParameters: queryParameters)
   }

}
public struct GoogleCloudDriveEmptyResponse : GoogleCloudModel {}
public struct GoogleCloudDriveAbout : GoogleCloudModel {
   /*Whether the user has installed the requesting app. */
   public var appInstalled: Bool?
   /*Whether the user can create shared drives. */
   public var canCreateDrives: Bool?
   /*Deprecated - use canCreateDrives instead. */
   public var canCreateTeamDrives: Bool?
   /*A list of themes that are supported for shared drives. */
   public var driveThemes: [GoogleCloudDriveAboutDriveThemes]?
   /*A map of source MIME type to possible targets for all supported exports. */
   public var exportFormats: [String : [String]]?
   /*The currently supported folder colors as RGB hex strings. */
   public var folderColorPalette: [String]?
   /*A map of source MIME type to possible targets for all supported imports. */
   public var importFormats: [String : [String]]?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#about". */
   public var kind: String?
   /*A map of maximum import sizes by MIME type, in bytes. */
   public var maxImportSizes: [String : String]?
   /*The maximum upload size in bytes. */
   public var maxUploadSize: String?
   /*The user's storage quota limits and usage. All fields are measured in bytes. */
   public var storageQuota: GoogleCloudDriveAboutStorageQuota?
   /*Deprecated - use driveThemes instead. */
   public var teamDriveThemes: [GoogleCloudDriveAboutTeamDriveThemes]?
   /*The authenticated user. */
   public var user:  GoogleCloudDriveUser?
}
public struct GoogleCloudDriveChange : GoogleCloudModel {
   /*The type of the change. Possible values are file and drive. */
   public var changeType: String?
   /*The updated state of the shared drive. Present if the changeType is drive, the user is still a member of the shared drive, and the shared drive has not been deleted. */
   public var drive:  GoogleCloudDriveDrive?
   /*The ID of the shared drive associated with this change. */
   public var driveId: String?
   /*The updated state of the file. Present if the type is file and the file has not been removed from this list of changes. */
   public var file:  GoogleCloudDriveFile?
   /*The ID of the file which has changed. */
   public var fileId: String?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#change". */
   public var kind: String?
   /*Whether the file or shared drive has been removed from this list of changes, for example by deletion or loss of access. */
   public var removed: Bool?
   /*Deprecated - use drive instead. */
   public var teamDrive:  GoogleCloudDriveTeamDrive?
   /*Deprecated - use driveId instead. */
   public var teamDriveId: String?
   /*The time of this change (RFC 3339 date-time). */
   public var time: String?
   /*Deprecated - use changeType instead. */
   public var type: String?
}
public struct GoogleCloudDriveChangeList : GoogleCloudModel {
   /*The list of changes. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var changes: [GoogleCloudDriveChange]?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#changeList". */
   public var kind: String?
   /*The starting page token for future changes. This will be present only if the end of the current changes list has been reached. */
   public var newStartPageToken: String?
   /*The page token for the next page of changes. This will be absent if the end of the changes list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
}
public struct GoogleCloudDriveChannel : GoogleCloudModel {
   /*The address where notifications are delivered for this channel. */
   public var address: String?
   /*Date and time of notification channel expiration, expressed as a Unix timestamp, in milliseconds. Optional. */
   public var expiration: String?
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
public struct GoogleCloudDriveComment : GoogleCloudModel {
   /*A region of the document represented as a JSON string. See anchor documentation for details on how to define and interpret anchor properties. */
   public var anchor: String?
   /*The author of the comment. The author's email address and permission ID will not be populated. */
   public var author:  GoogleCloudDriveUser?
   /*The plain text content of the comment. This field is used for setting the content, while htmlContent should be displayed. */
   public var content: String?
   /*The time at which the comment was created (RFC 3339 date-time). */
   public var createdTime: String?
   /*Whether the comment has been deleted. A deleted comment has no content. */
   public var deleted: Bool?
   /*The content of the comment with HTML formatting. */
   public var htmlContent: String?
   /*The ID of the comment. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#comment". */
   public var kind: String?
   /*The last time the comment or any of its replies was modified (RFC 3339 date-time). */
   public var modifiedTime: String?
   /*The file content to which the comment refers, typically within the anchor region. For a text file, for example, this would be the text at the location of the comment. */
   public var quotedFileContent: GoogleCloudDriveCommentQuotedFileContent?
   /*The full list of replies to the comment in chronological order. */
   public var replies: [GoogleCloudDriveReply]?
   /*Whether the comment has been resolved by one of its replies. */
   public var resolved: Bool?
}
public struct GoogleCloudDriveCommentList : GoogleCloudModel {
   /*The list of comments. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var comments: [GoogleCloudDriveComment]?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#commentList". */
   public var kind: String?
   /*The page token for the next page of comments. This will be absent if the end of the comments list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
}
public struct GoogleCloudDriveDrive : GoogleCloudModel {
   /*An image file and cropping parameters from which a background image for this shared drive is set. This is a write only field; it can only be set on drive.drives.update requests that don't set themeId. When specified, all fields of the backgroundImageFile must be set. */
   public var backgroundImageFile: GoogleCloudDriveDriveBackgroundImageFile?
   /*A short-lived link to this shared drive's background image. */
   public var backgroundImageLink: String?
   /*Capabilities the current user has on this shared drive. */
   public var capabilities: GoogleCloudDriveDriveCapabilities?
   /*The color of this shared drive as an RGB hex string. It can only be set on a drive.drives.update request that does not set themeId. */
   public var colorRgb: String?
   /*The time at which the shared drive was created (RFC 3339 date-time). */
   public var createdTime: String?
   /*Whether the shared drive is hidden from default view. */
   public var hidden: Bool?
   /*The ID of this shared drive which is also the ID of the top level folder of this shared drive. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#drive". */
   public var kind: String?
   /*The name of this shared drive. */
   public var name: String?
   /*A set of restrictions that apply to this shared drive or items inside this shared drive. */
   public var restrictions: GoogleCloudDriveDriveRestrictions?
   /*The ID of the theme from which the background image and color will be set. The set of possible driveThemes can be retrieved from a drive.about.get response. When not specified on a drive.drives.create request, a random theme is chosen from which the background image and color are set. This is a write-only field; it can only be set on requests that don't set colorRgb or backgroundImageFile. */
   public var themeId: String?
}
public struct GoogleCloudDriveDriveList : GoogleCloudModel {
   /*The list of shared drives. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var drives: [GoogleCloudDriveDrive]?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#driveList". */
   public var kind: String?
   /*The page token for the next page of shared drives. This will be absent if the end of the list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
}
public struct GoogleCloudDriveFile : GoogleCloudModel {
   /*A collection of arbitrary key-value pairs which are private to the requesting app.
Entries with null values are cleared in update and copy requests. */
   public var appProperties: [String : String]?
   /*Capabilities the current user has on this file. Each capability corresponds to a fine-grained action that a user may take. */
   public var capabilities: GoogleCloudDriveFileCapabilities?
   /*Additional information about the content of the file. These fields are never populated in responses. */
   public var contentHints: GoogleCloudDriveFileContentHints?
   /*Whether the options to copy, print, or download this file, should be disabled for readers and commenters. */
   public var copyRequiresWriterPermission: Bool?
   /*The time at which the file was created (RFC 3339 date-time). */
   public var createdTime: String?
   /*A short description of the file. */
   public var description: String?
   /*ID of the shared drive the file resides in. Only populated for items in shared drives. */
   public var driveId: String?
   /*Whether the file has been explicitly trashed, as opposed to recursively trashed from a parent folder. */
   public var explicitlyTrashed: Bool?
   /*Links for exporting Google Docs to specific formats. */
   public var exportLinks: [String : String]?
   /*The final component of fullFileExtension. This is only available for files with binary content in Google Drive. */
   public var fileExtension: String?
   /*The color for a folder as an RGB hex string. The supported colors are published in the folderColorPalette field of the About resource.
If an unsupported color is specified, the closest color in the palette will be used instead. */
   public var folderColorRgb: String?
   /*The full file extension extracted from the name field. May contain multiple concatenated extensions, such as "tar.gz". This is only available for files with binary content in Google Drive.
This is automatically updated when the name field changes, however it is not cleared if the new name does not contain a valid extension. */
   public var fullFileExtension: String?
   /*Whether there are permissions directly on this file. This field is only populated for items in shared drives. */
   public var hasAugmentedPermissions: Bool?
   /*Whether this file has a thumbnail. This does not indicate whether the requesting app has access to the thumbnail. To check access, look for the presence of the thumbnailLink field. */
   public var hasThumbnail: Bool?
   /*The ID of the file's head revision. This is currently only available for files with binary content in Google Drive. */
   public var headRevisionId: String?
   /*A static, unauthenticated link to the file's icon. */
   public var iconLink: String?
   /*The ID of the file. */
   public var id: String?
   /*Additional metadata about image media, if available. */
   public var imageMediaMetadata: GoogleCloudDriveFileImageMediaMetadata?
   /*Whether the file was created or opened by the requesting app. */
   public var isAppAuthorized: Bool?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#file". */
   public var kind: String?
   /*The last user to modify the file. */
   public var lastModifyingUser:  GoogleCloudDriveUser?
   /*The MD5 checksum for the content of the file. This is only applicable to files with binary content in Google Drive. */
   public var md5Checksum: String?
   /*The MIME type of the file.
Google Drive will attempt to automatically detect an appropriate value from uploaded content if no value is provided. The value cannot be changed unless a new revision is uploaded.
If a file is created with a Google Doc MIME type, the uploaded content will be imported if possible. The supported import formats are published in the About resource. */
   public var mimeType: String?
   /*Whether the file has been modified by this user. */
   public var modifiedByMe: Bool?
   /*The last time the file was modified by the user (RFC 3339 date-time). */
   public var modifiedByMeTime: String?
   /*The last time the file was modified by anyone (RFC 3339 date-time).
Note that setting modifiedTime will also update modifiedByMeTime for the user. */
   public var modifiedTime: String?
   /*The name of the file. This is not necessarily unique within a folder. Note that for immutable items such as the top level folders of shared drives, My Drive root folder, and Application Data folder the name is constant. */
   public var name: String?
   /*The original filename of the uploaded content if available, or else the original value of the name field. This is only available for files with binary content in Google Drive. */
   public var originalFilename: String?
   /*Whether the user owns the file. Not populated for items in shared drives. */
   public var ownedByMe: Bool?
   /*The owners of the file. Currently, only certain legacy files may have more than one owner. Not populated for items in shared drives. */
   public var owners: [GoogleCloudDriveUser]?
   /*The IDs of the parent folders which contain the file.
If not specified as part of a create request, the file will be placed directly in the user's My Drive folder. If not specified as part of a copy request, the file will inherit any discoverable parents of the source file. Update requests must use the addParents and removeParents parameters to modify the parents list. */
   public var parents: [String]?
   /*List of permission IDs for users with access to this file. */
   public var permissionIds: [String]?
   /*The full list of permissions for the file. This is only available if the requesting user can share the file. Not populated for items in shared drives. */
   public var permissions: [GoogleCloudDrivePermission]?
   /*A collection of arbitrary key-value pairs which are visible to all apps.
Entries with null values are cleared in update and copy requests. */
   public var properties: [String : String]?
   /*The number of storage quota bytes used by the file. This includes the head revision as well as previous revisions with keepForever enabled. */
   public var quotaBytesUsed: String?
   /*Whether the file has been shared. Not populated for items in shared drives. */
   public var shared: Bool?
   /*The time at which the file was shared with the user, if applicable (RFC 3339 date-time). */
   public var sharedWithMeTime: String?
   /*The user who shared the file with the requesting user, if applicable. */
   public var sharingUser:  GoogleCloudDriveUser?
   /*The size of the file's content in bytes. This is only applicable to files with binary content in Google Drive. */
   public var size: String?
   /*The list of spaces which contain the file. The currently supported values are 'drive', 'appDataFolder' and 'photos'. */
   public var spaces: [String]?
   /*Whether the user has starred the file. */
   public var starred: Bool?
   /*Deprecated - use driveId instead. */
   public var teamDriveId: String?
   /*A short-lived link to the file's thumbnail, if available. Typically lasts on the order of hours. Only populated when the requesting app can access the file's content. */
   public var thumbnailLink: String?
   /*The thumbnail version for use in thumbnail cache invalidation. */
   public var thumbnailVersion: String?
   /*Whether the file has been trashed, either explicitly or from a trashed parent folder. Only the owner may trash a file, and other users cannot see files in the owner's trash. */
   public var trashed: Bool?
   /*The time that the item was trashed (RFC 3339 date-time). Only populated for items in shared drives. */
   public var trashedTime: String?
   /*If the file has been explicitly trashed, the user who trashed it. Only populated for items in shared drives. */
   public var trashingUser:  GoogleCloudDriveUser?
   /*A monotonically increasing version number for the file. This reflects every change made to the file on the server, even those not visible to the user. */
   public var version: String?
   /*Additional metadata about video media. This may not be available immediately upon upload. */
   public var videoMediaMetadata: GoogleCloudDriveFileVideoMediaMetadata?
   /*Whether the file has been viewed by this user. */
   public var viewedByMe: Bool?
   /*The last time the file was viewed by the user (RFC 3339 date-time). */
   public var viewedByMeTime: String?
   /*Deprecated - use copyRequiresWriterPermission instead. */
   public var viewersCanCopyContent: Bool?
   /*A link for downloading the content of the file in a browser. This is only available for files with binary content in Google Drive. */
   public var webContentLink: String?
   /*A link for opening the file in a relevant Google editor or viewer in a browser. */
   public var webViewLink: String?
   /*Whether users with only writer permission can modify the file's permissions. Not populated for items in shared drives. */
   public var writersCanShare: Bool?
}
public struct GoogleCloudDriveFileList : GoogleCloudModel {
   /*The list of files. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var files: [GoogleCloudDriveFile]?
   /*Whether the search process was incomplete. If true, then some search results may be missing, since all documents were not searched. This may occur when searching multiple drives with the "allDrives" corpora, but all corpora could not be searched. When this happens, it is suggested that clients narrow their query by choosing a different corpus such as "user" or "drive". */
   public var incompleteSearch: Bool?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#fileList". */
   public var kind: String?
   /*The page token for the next page of files. This will be absent if the end of the files list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
}
public struct GoogleCloudDriveGeneratedIds : GoogleCloudModel {
   /*The IDs generated for the requesting user in the specified space. */
   public var ids: [String]?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#generatedIds". */
   public var kind: String?
   /*The type of file that can be created with these IDs. */
   public var space: String?
}
public struct GoogleCloudDrivePermission : GoogleCloudModel {
   /*Whether the permission allows the file to be discovered through search. This is only applicable for permissions of type domain or anyone. */
   public var allowFileDiscovery: Bool?
   /*Whether the account associated with this permission has been deleted. This field only pertains to user and group permissions. */
   public var deleted: Bool?
   /*The "pretty" name of the value of the permission. The following is a list of examples for each type of permission:  
- user - User's full name, as defined for their Google account, such as "Joe Smith." 
- group - Name of the Google Group, such as "The Company Administrators." 
- domain - String domain name, such as "thecompany.com." 
- anyone - No displayName is present. */
   public var displayName: String?
   /*The domain to which this permission refers. */
   public var domain: String?
   /*The email address of the user or group to which this permission refers. */
   public var emailAddress: String?
   /*The time at which this permission will expire (RFC 3339 date-time). Expiration times have the following restrictions:  
- They can only be set on user and group permissions 
- The time must be in the future 
- The time cannot be more than a year in the future */
   public var expirationTime: String?
   /*The ID of this permission. This is a unique identifier for the grantee, and is published in User resources as permissionId. IDs should be treated as opaque values. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#permission". */
   public var kind: String?
   /*Details of whether the permissions on this shared drive item are inherited or directly on this item. This is an output-only field which is present only for shared drive items. */
   public var permissionDetails: [GoogleCloudDrivePermissionPermissionDetails]?
   /*A link to the user's profile photo, if available. */
   public var photoLink: String?
   /*The role granted by this permission. While new values may be supported in the future, the following are currently allowed:  
- owner 
- organizer 
- fileOrganizer 
- writer 
- commenter 
- reader */
   public var role: String?
   /*Deprecated - use permissionDetails instead. */
   public var teamDrivePermissionDetails: [GoogleCloudDrivePermissionTeamDrivePermissionDetails]?
   /*The type of the grantee. Valid values are:  
- user 
- group 
- domain 
- anyone  When creating a permission, if type is user or group, you must provide an emailAddress for the user or group. When type is domain, you must provide a domain. There isn't extra information required for a anyone type. */
   public var type: String?
}
public struct GoogleCloudDrivePermissionList : GoogleCloudModel {
   /*Identifies what kind of resource this is. Value: the fixed string "drive#permissionList". */
   public var kind: String?
   /*The page token for the next page of permissions. This field will be absent if the end of the permissions list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
   /*The list of permissions. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var permissions: [GoogleCloudDrivePermission]?
}
public struct GoogleCloudDriveReply : GoogleCloudModel {
   /*The action the reply performed to the parent comment. Valid values are:  
- resolve 
- reopen */
   public var action: String?
   /*The author of the reply. The author's email address and permission ID will not be populated. */
   public var author:  GoogleCloudDriveUser?
   /*The plain text content of the reply. This field is used for setting the content, while htmlContent should be displayed. This is required on creates if no action is specified. */
   public var content: String?
   /*The time at which the reply was created (RFC 3339 date-time). */
   public var createdTime: String?
   /*Whether the reply has been deleted. A deleted reply has no content. */
   public var deleted: Bool?
   /*The content of the reply with HTML formatting. */
   public var htmlContent: String?
   /*The ID of the reply. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#reply". */
   public var kind: String?
   /*The last time the reply was modified (RFC 3339 date-time). */
   public var modifiedTime: String?
}
public struct GoogleCloudDriveReplyList : GoogleCloudModel {
   /*Identifies what kind of resource this is. Value: the fixed string "drive#replyList". */
   public var kind: String?
   /*The page token for the next page of replies. This will be absent if the end of the replies list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
   /*The list of replies. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var replies: [GoogleCloudDriveReply]?
}
public struct GoogleCloudDriveRevision : GoogleCloudModel {
   /*Links for exporting Google Docs to specific formats. */
   public var exportLinks: [String : String]?
   /*The ID of the revision. */
   public var id: String?
   /*Whether to keep this revision forever, even if it is no longer the head revision. If not set, the revision will be automatically purged 30 days after newer content is uploaded. This can be set on a maximum of 200 revisions for a file.
This field is only applicable to files with binary content in Drive. */
   public var keepForever: Bool?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#revision". */
   public var kind: String?
   /*The last user to modify this revision. */
   public var lastModifyingUser:  GoogleCloudDriveUser?
   /*The MD5 checksum of the revision's content. This is only applicable to files with binary content in Drive. */
   public var md5Checksum: String?
   /*The MIME type of the revision. */
   public var mimeType: String?
   /*The last time the revision was modified (RFC 3339 date-time). */
   public var modifiedTime: String?
   /*The original filename used to create this revision. This is only applicable to files with binary content in Drive. */
   public var originalFilename: String?
   /*Whether subsequent revisions will be automatically republished. This is only applicable to Google Docs. */
   public var publishAuto: Bool?
   /*Whether this revision is published. This is only applicable to Google Docs. */
   public var published: Bool?
   /*Whether this revision is published outside the domain. This is only applicable to Google Docs. */
   public var publishedOutsideDomain: Bool?
   /*The size of the revision's content in bytes. This is only applicable to files with binary content in Drive. */
   public var size: String?
}
public struct GoogleCloudDriveRevisionList : GoogleCloudModel {
   /*Identifies what kind of resource this is. Value: the fixed string "drive#revisionList". */
   public var kind: String?
   /*The page token for the next page of revisions. This will be absent if the end of the revisions list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
   /*The list of revisions. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var revisions: [GoogleCloudDriveRevision]?
}
public struct GoogleCloudDriveStartPageToken : GoogleCloudModel {
   /*Identifies what kind of resource this is. Value: the fixed string "drive#startPageToken". */
   public var kind: String?
   /*The starting page token for listing changes. */
   public var startPageToken: String?
}
public struct GoogleCloudDriveTeamDrive : GoogleCloudModel {
   /*An image file and cropping parameters from which a background image for this Team Drive is set. This is a write only field; it can only be set on drive.teamdrives.update requests that don't set themeId. When specified, all fields of the backgroundImageFile must be set. */
   public var backgroundImageFile: GoogleCloudDriveTeamDriveBackgroundImageFile?
   /*A short-lived link to this Team Drive's background image. */
   public var backgroundImageLink: String?
   /*Capabilities the current user has on this Team Drive. */
   public var capabilities: GoogleCloudDriveTeamDriveCapabilities?
   /*The color of this Team Drive as an RGB hex string. It can only be set on a drive.teamdrives.update request that does not set themeId. */
   public var colorRgb: String?
   /*The time at which the Team Drive was created (RFC 3339 date-time). */
   public var createdTime: String?
   /*The ID of this Team Drive which is also the ID of the top level folder of this Team Drive. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#teamDrive". */
   public var kind: String?
   /*The name of this Team Drive. */
   public var name: String?
   /*A set of restrictions that apply to this Team Drive or items inside this Team Drive. */
   public var restrictions: GoogleCloudDriveTeamDriveRestrictions?
   /*The ID of the theme from which the background image and color will be set. The set of possible teamDriveThemes can be retrieved from a drive.about.get response. When not specified on a drive.teamdrives.create request, a random theme is chosen from which the background image and color are set. This is a write-only field; it can only be set on requests that don't set colorRgb or backgroundImageFile. */
   public var themeId: String?
}
public struct GoogleCloudDriveTeamDriveList : GoogleCloudModel {
   /*Identifies what kind of resource this is. Value: the fixed string "drive#teamDriveList". */
   public var kind: String?
   /*The page token for the next page of Team Drives. This will be absent if the end of the Team Drives list has been reached. If the token is rejected for any reason, it should be discarded, and pagination should be restarted from the first page of results. */
   public var nextPageToken: String?
   /*The list of Team Drives. If nextPageToken is populated, then this list may be incomplete and an additional page of results should be fetched. */
   public var teamDrives: [GoogleCloudDriveTeamDrive]?
}
public struct GoogleCloudDriveUser : GoogleCloudModel {
   /*A plain text displayable name for this user. */
   public var displayName: String?
   /*The email address of the user. This may not be present in certain contexts if the user has not made their email address visible to the requester. */
   public var emailAddress: String?
   /*Identifies what kind of resource this is. Value: the fixed string "drive#user". */
   public var kind: String?
   /*Whether this user is the requesting user. */
   public var me: Bool?
   /*The user's ID as visible in Permission resources. */
   public var permissionId: String?
   /*A link to the user's profile photo, if available. */
   public var photoLink: String?
}
public struct GoogleCloudDriveAboutDriveThemes : GoogleCloudModel {
   /*A link to this theme's background image. */
   public var backgroundImageLink: String?
   /*The color of this theme as an RGB hex string. */
   public var colorRgb: String?
   /*The ID of the theme. */
   public var id: String?
}
public struct GoogleCloudDriveAboutStorageQuota : GoogleCloudModel {
   /*The usage limit, if applicable. This will not be present if the user has unlimited storage. */
   public var limit: String?
   /*The total usage across all services. */
   public var usage: String?
   /*The usage by all files in Google Drive. */
   public var usageInDrive: String?
   /*The usage by trashed files in Google Drive. */
   public var usageInDriveTrash: String?
}
public struct GoogleCloudDriveAboutTeamDriveThemes : GoogleCloudModel {
   /*Deprecated - use driveThemes/backgroundImageLink instead. */
   public var backgroundImageLink: String?
   /*Deprecated - use driveThemes/colorRgb instead. */
   public var colorRgb: String?
   /*Deprecated - use driveThemes/id instead. */
   public var id: String?
}
public struct GoogleCloudDriveCommentQuotedFileContent : GoogleCloudModel {
   /*The MIME type of the quoted content. */
   public var mimeType: String?
   /*The quoted content itself. This is interpreted as plain text if set through the API. */
   public var value: String?
}
public struct GoogleCloudDriveDriveBackgroundImageFile : GoogleCloudModel {
   /*The ID of an image file in Google Drive to use for the background image. */
   public var id: String?
   /*The width of the cropped image in the closed range of 0 to 1. This value represents the width of the cropped image divided by the width of the entire image. The height is computed by applying a width to height aspect ratio of 80 to 9. The resulting image must be at least 1280 pixels wide and 144 pixels high. */
   public var width: Double?
   /*The X coordinate of the upper left corner of the cropping area in the background image. This is a value in the closed range of 0 to 1. This value represents the horizontal distance from the left side of the entire image to the left side of the cropping area divided by the width of the entire image. */
   public var xCoordinate: Double?
   /*The Y coordinate of the upper left corner of the cropping area in the background image. This is a value in the closed range of 0 to 1. This value represents the vertical distance from the top side of the entire image to the top side of the cropping area divided by the height of the entire image. */
   public var yCoordinate: Double?
}
public struct GoogleCloudDriveDriveCapabilities : GoogleCloudModel {
   /*Whether the current user can add children to folders in this shared drive. */
   public var canAddChildren: Bool?
   /*Whether the current user can change the copyRequiresWriterPermission restriction of this shared drive. */
   public var canChangeCopyRequiresWriterPermissionRestriction: Bool?
   /*Whether the current user can change the domainUsersOnly restriction of this shared drive. */
   public var canChangeDomainUsersOnlyRestriction: Bool?
   /*Whether the current user can change the background of this shared drive. */
   public var canChangeDriveBackground: Bool?
   /*Whether the current user can change the driveMembersOnly restriction of this shared drive. */
   public var canChangeDriveMembersOnlyRestriction: Bool?
   /*Whether the current user can comment on files in this shared drive. */
   public var canComment: Bool?
   /*Whether the current user can copy files in this shared drive. */
   public var canCopy: Bool?
   /*Whether the current user can delete children from folders in this shared drive. */
   public var canDeleteChildren: Bool?
   /*Whether the current user can delete this shared drive. Attempting to delete the shared drive may still fail if there are untrashed items inside the shared drive. */
   public var canDeleteDrive: Bool?
   /*Whether the current user can download files in this shared drive. */
   public var canDownload: Bool?
   /*Whether the current user can edit files in this shared drive */
   public var canEdit: Bool?
   /*Whether the current user can list the children of folders in this shared drive. */
   public var canListChildren: Bool?
   /*Whether the current user can add members to this shared drive or remove them or change their role. */
   public var canManageMembers: Bool?
   /*Whether the current user can read the revisions resource of files in this shared drive. */
   public var canReadRevisions: Bool?
   /*Whether the current user can rename files or folders in this shared drive. */
   public var canRename: Bool?
   /*Whether the current user can rename this shared drive. */
   public var canRenameDrive: Bool?
   /*Whether the current user can share files or folders in this shared drive. */
   public var canShare: Bool?
   /*Whether the current user can trash children from folders in this shared drive. */
   public var canTrashChildren: Bool?
}
public struct GoogleCloudDriveDriveRestrictions : GoogleCloudModel {
   /*Whether administrative privileges on this shared drive are required to modify restrictions. */
   public var adminManagedRestrictions: Bool?
   /*Whether the options to copy, print, or download files inside this shared drive, should be disabled for readers and commenters. When this restriction is set to true, it will override the similarly named field to true for any file inside this shared drive. */
   public var copyRequiresWriterPermission: Bool?
   /*Whether access to this shared drive and items inside this shared drive is restricted to users of the domain to which this shared drive belongs. This restriction may be overridden by other sharing policies controlled outside of this shared drive. */
   public var domainUsersOnly: Bool?
   /*Whether access to items inside this shared drive is restricted to its members. */
   public var driveMembersOnly: Bool?
}
public struct GoogleCloudDriveFileCapabilities : GoogleCloudModel {
   /*Whether the current user can add children to this folder. This is always false when the item is not a folder. */
   public var canAddChildren: Bool?
   /*Whether the current user can change the copyRequiresWriterPermission restriction of this file. */
   public var canChangeCopyRequiresWriterPermission: Bool?
   /*Deprecated */
   public var canChangeViewersCanCopyContent: Bool?
   /*Whether the current user can comment on this file. */
   public var canComment: Bool?
   /*Whether the current user can copy this file. For an item in a shared drive, whether the current user can copy non-folder descendants of this item, or this item itself if it is not a folder. */
   public var canCopy: Bool?
   /*Whether the current user can delete this file. */
   public var canDelete: Bool?
   /*Whether the current user can delete children of this folder. This is false when the item is not a folder. Only populated for items in shared drives. */
   public var canDeleteChildren: Bool?
   /*Whether the current user can download this file. */
   public var canDownload: Bool?
   /*Whether the current user can edit this file. Other factors may limit the type of changes a user can make to a file. For example, see canChangeCopyRequiresWriterPermission or canModifyContent. */
   public var canEdit: Bool?
   /*Whether the current user can list the children of this folder. This is always false when the item is not a folder. */
   public var canListChildren: Bool?
   /*Whether the current user can modify the content of this file. */
   public var canModifyContent: Bool?
   /*Whether the current user can move children of this folder outside of the shared drive. This is false when the item is not a folder. Only populated for items in shared drives. */
   public var canMoveChildrenOutOfDrive: Bool?
   /*Deprecated - use canMoveChildrenOutOfDrive instead. */
   public var canMoveChildrenOutOfTeamDrive: Bool?
   /*Whether the current user can move children of this folder within the shared drive. This is false when the item is not a folder. Only populated for items in shared drives. */
   public var canMoveChildrenWithinDrive: Bool?
   /*Deprecated - use canMoveChildrenWithinDrive instead. */
   public var canMoveChildrenWithinTeamDrive: Bool?
   /*Deprecated - use canMoveItemOutOfDrive instead. */
   public var canMoveItemIntoTeamDrive: Bool?
   /*Whether the current user can move this item outside of this drive by changing its parent. Note that a request to change the parent of the item may still fail depending on the new parent that is being added. */
   public var canMoveItemOutOfDrive: Bool?
   /*Deprecated - use canMoveItemOutOfDrive instead. */
   public var canMoveItemOutOfTeamDrive: Bool?
   /*Whether the current user can move this item within this shared drive. Note that a request to change the parent of the item may still fail depending on the new parent that is being added. Only populated for items in shared drives. */
   public var canMoveItemWithinDrive: Bool?
   /*Deprecated - use canMoveItemWithinDrive instead. */
   public var canMoveItemWithinTeamDrive: Bool?
   /*Deprecated - use canMoveItemWithinDrive or canMoveItemOutOfDrive instead. */
   public var canMoveTeamDriveItem: Bool?
   /*Whether the current user can read the shared drive to which this file belongs. Only populated for items in shared drives. */
   public var canReadDrive: Bool?
   /*Whether the current user can read the revisions resource of this file. For a shared drive item, whether revisions of non-folder descendants of this item, or this item itself if it is not a folder, can be read. */
   public var canReadRevisions: Bool?
   /*Deprecated - use canReadDrive instead. */
   public var canReadTeamDrive: Bool?
   /*Whether the current user can remove children from this folder. This is always false when the item is not a folder. For a folder in a shared drive, use canDeleteChildren or canTrashChildren instead. */
   public var canRemoveChildren: Bool?
   /*Whether the current user can rename this file. */
   public var canRename: Bool?
   /*Whether the current user can modify the sharing settings for this file. */
   public var canShare: Bool?
   /*Whether the current user can move this file to trash. */
   public var canTrash: Bool?
   /*Whether the current user can trash children of this folder. This is false when the item is not a folder. Only populated for items in shared drives. */
   public var canTrashChildren: Bool?
   /*Whether the current user can restore this file from trash. */
   public var canUntrash: Bool?
}
public struct GoogleCloudDriveFileContentHints : GoogleCloudModel {
   /*Text to be indexed for the file to improve fullText queries. This is limited to 128KB in length and may contain HTML elements. */
   public var indexableText: String?
   /*A thumbnail for the file. This will only be used if Google Drive cannot generate a standard thumbnail. */
   public var thumbnail: PlaceHolderObject?
}
public struct GoogleCloudDriveFileImageMediaMetadata : GoogleCloudModel {
   /*The aperture used to create the photo (f-number). */
   public var aperture: Double?
   /*The make of the camera used to create the photo. */
   public var cameraMake: String?
   /*The model of the camera used to create the photo. */
   public var cameraModel: String?
   /*The color space of the photo. */
   public var colorSpace: String?
   /*The exposure bias of the photo (APEX value). */
   public var exposureBias: Double?
   /*The exposure mode used to create the photo. */
   public var exposureMode: String?
   /*The length of the exposure, in seconds. */
   public var exposureTime: Double?
   /*Whether a flash was used to create the photo. */
   public var flashUsed: Bool?
   /*The focal length used to create the photo, in millimeters. */
   public var focalLength: Double?
   /*The height of the image in pixels. */
   public var height: Int?
   /*The ISO speed used to create the photo. */
   public var isoSpeed: Int?
   /*The lens used to create the photo. */
   public var lens: String?
   /*Geographic location information stored in the image. */
   public var location: PlaceHolderObject?
   /*The smallest f-number of the lens at the focal length used to create the photo (APEX value). */
   public var maxApertureValue: Double?
   /*The metering mode used to create the photo. */
   public var meteringMode: String?
   /*The rotation in clockwise degrees from the image's original orientation. */
   public var rotation: Int?
   /*The type of sensor used to create the photo. */
   public var sensor: String?
   /*The distance to the subject of the photo, in meters. */
   public var subjectDistance: Int?
   /*The date and time the photo was taken (EXIF DateTime). */
   public var time: String?
   /*The white balance mode used to create the photo. */
   public var whiteBalance: String?
   /*The width of the image in pixels. */
   public var width: Int?
}
public struct GoogleCloudDriveFileVideoMediaMetadata : GoogleCloudModel {
   /*The duration of the video in milliseconds. */
   public var durationMillis: String?
   /*The height of the video in pixels. */
   public var height: Int?
   /*The width of the video in pixels. */
   public var width: Int?
}
public struct GoogleCloudDrivePermissionPermissionDetails : GoogleCloudModel {
   /*Whether this permission is inherited. This field is always populated. This is an output-only field. */
   public var inherited: Bool?
   /*The ID of the item from which this permission is inherited. This is an output-only field and is only populated for members of the shared drive. */
   public var inheritedFrom: String?
   /*The permission type for this user. While new values may be added in future, the following are currently possible:  
- file 
- member */
   public var permissionType: String?
   /*The primary role for this user. While new values may be added in the future, the following are currently possible:  
- organizer 
- fileOrganizer 
- writer 
- commenter 
- reader */
   public var role: String?
}
public struct GoogleCloudDrivePermissionTeamDrivePermissionDetails : GoogleCloudModel {
   /*Deprecated - use permissionDetails/inherited instead. */
   public var inherited: Bool?
   /*Deprecated - use permissionDetails/inheritedFrom instead. */
   public var inheritedFrom: String?
   /*Deprecated - use permissionDetails/role instead. */
   public var role: String?
   /*Deprecated - use permissionDetails/permissionType instead. */
   public var teamDrivePermissionType: String?
}
public struct GoogleCloudDriveTeamDriveBackgroundImageFile : GoogleCloudModel {
   /*The ID of an image file in Drive to use for the background image. */
   public var id: String?
   /*The width of the cropped image in the closed range of 0 to 1. This value represents the width of the cropped image divided by the width of the entire image. The height is computed by applying a width to height aspect ratio of 80 to 9. The resulting image must be at least 1280 pixels wide and 144 pixels high. */
   public var width: Double?
   /*The X coordinate of the upper left corner of the cropping area in the background image. This is a value in the closed range of 0 to 1. This value represents the horizontal distance from the left side of the entire image to the left side of the cropping area divided by the width of the entire image. */
   public var xCoordinate: Double?
   /*The Y coordinate of the upper left corner of the cropping area in the background image. This is a value in the closed range of 0 to 1. This value represents the vertical distance from the top side of the entire image to the top side of the cropping area divided by the height of the entire image. */
   public var yCoordinate: Double?
}
public struct GoogleCloudDriveTeamDriveCapabilities : GoogleCloudModel {
   /*Whether the current user can add children to folders in this Team Drive. */
   public var canAddChildren: Bool?
   /*Whether the current user can change the copyRequiresWriterPermission restriction of this Team Drive. */
   public var canChangeCopyRequiresWriterPermissionRestriction: Bool?
   /*Whether the current user can change the domainUsersOnly restriction of this Team Drive. */
   public var canChangeDomainUsersOnlyRestriction: Bool?
   /*Whether the current user can change the background of this Team Drive. */
   public var canChangeTeamDriveBackground: Bool?
   /*Whether the current user can change the teamMembersOnly restriction of this Team Drive. */
   public var canChangeTeamMembersOnlyRestriction: Bool?
   /*Whether the current user can comment on files in this Team Drive. */
   public var canComment: Bool?
   /*Whether the current user can copy files in this Team Drive. */
   public var canCopy: Bool?
   /*Whether the current user can delete children from folders in this Team Drive. */
   public var canDeleteChildren: Bool?
   /*Whether the current user can delete this Team Drive. Attempting to delete the Team Drive may still fail if there are untrashed items inside the Team Drive. */
   public var canDeleteTeamDrive: Bool?
   /*Whether the current user can download files in this Team Drive. */
   public var canDownload: Bool?
   /*Whether the current user can edit files in this Team Drive */
   public var canEdit: Bool?
   /*Whether the current user can list the children of folders in this Team Drive. */
   public var canListChildren: Bool?
   /*Whether the current user can add members to this Team Drive or remove them or change their role. */
   public var canManageMembers: Bool?
   /*Whether the current user can read the revisions resource of files in this Team Drive. */
   public var canReadRevisions: Bool?
   /*Deprecated - use canDeleteChildren or canTrashChildren instead. */
   public var canRemoveChildren: Bool?
   /*Whether the current user can rename files or folders in this Team Drive. */
   public var canRename: Bool?
   /*Whether the current user can rename this Team Drive. */
   public var canRenameTeamDrive: Bool?
   /*Whether the current user can share files or folders in this Team Drive. */
   public var canShare: Bool?
   /*Whether the current user can trash children from folders in this Team Drive. */
   public var canTrashChildren: Bool?
}
public struct GoogleCloudDriveTeamDriveRestrictions : GoogleCloudModel {
   /*Whether administrative privileges on this Team Drive are required to modify restrictions. */
   public var adminManagedRestrictions: Bool?
   /*Whether the options to copy, print, or download files inside this Team Drive, should be disabled for readers and commenters. When this restriction is set to true, it will override the similarly named field to true for any file inside this Team Drive. */
   public var copyRequiresWriterPermission: Bool?
   /*Whether access to this Team Drive and items inside this Team Drive is restricted to users of the domain to which this Team Drive belongs. This restriction may be overridden by other sharing policies controlled outside of this Team Drive. */
   public var domainUsersOnly: Bool?
   /*Whether access to items inside this Team Drive is restricted to members of this Team Drive. */
   public var teamMembersOnly: Bool?
}
public final class GoogleCloudDriveClient {
   public var about : DriveAboutAPIProtocol
   public var changes : DriveChangesAPIProtocol
   public var channels : DriveChannelsAPIProtocol
   public var comments : DriveCommentsAPIProtocol
   public var drives : DriveDrivesAPIProtocol
   public var files : DriveFilesAPIProtocol
   public var permissions : DrivePermissionsAPIProtocol
   public var replies : DriveRepliesAPIProtocol
   public var revisions : DriveRevisionsAPIProtocol
   public var teamdrives : DriveTeamdrivesAPIProtocol


   public init(credentials: GoogleCloudCredentialsConfiguration, driveConfig: GoogleCloudDriveConfiguration, httpClient: HTTPClient, eventLoop: EventLoop) throws {
      let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: driveConfig, andClient: httpClient, eventLoop: eventLoop)
      guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
               (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
               driveConfig.project ?? credentials.project else {
         throw GoogleCloudInternalError.projectIdMissing
      }

      let request = GoogleCloudDriveRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)


      about = GoogleCloudDriveAboutAPI(request: request)
      changes = GoogleCloudDriveChangesAPI(request: request)
      channels = GoogleCloudDriveChannelsAPI(request: request)
      comments = GoogleCloudDriveCommentsAPI(request: request)
      drives = GoogleCloudDriveDrivesAPI(request: request)
      files = GoogleCloudDriveFilesAPI(request: request)
      permissions = GoogleCloudDrivePermissionsAPI(request: request)
      replies = GoogleCloudDriveRepliesAPI(request: request)
      revisions = GoogleCloudDriveRevisionsAPI(request: request)
      teamdrives = GoogleCloudDriveTeamdrivesAPI(request: request)
   }
}

