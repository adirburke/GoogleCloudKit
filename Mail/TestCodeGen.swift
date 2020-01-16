// This is Generated Code


import Foundation
import AsyncHTTPClient
import NIO
import Core
import NIOFoundationCompat
import NIOHTTP1


public enum GoogleCloudGmailScope : GoogleCloudAPIScope {
   public var value : String {
      switch self {
      case .GmailSettingsSharing: return "https://www.googleapis.com/auth/gmail.settings.sharing"
      case .FullAccess: return "https://mail.google.com/"
      case .GmailCompose: return "https://www.googleapis.com/auth/gmail.compose"
      case .GmailLabels: return "https://www.googleapis.com/auth/gmail.labels"
      case .GmailSend: return "https://www.googleapis.com/auth/gmail.send"
      case .GmailSettingsBasic: return "https://www.googleapis.com/auth/gmail.settings.basic"
      case .GmailInsert: return "https://www.googleapis.com/auth/gmail.insert"
      case .GmailModify: return "https://www.googleapis.com/auth/gmail.modify"
      case .GmailMetadata: return "https://www.googleapis.com/auth/gmail.metadata"
      case .GmailReadonly: return "https://www.googleapis.com/auth/gmail.readonly"
      }
   }

   case GmailSettingsSharing // Manage your sensitive mail settings, including who can manage your mail
   case FullAccess // Read, compose, send, and permanently delete all your email from Gmail
   case GmailCompose // Manage drafts and send emails
   case GmailLabels // Manage mailbox labels
   case GmailSend // Send email on your behalf
   case GmailSettingsBasic // Manage your basic mail settings
   case GmailInsert // Insert mail into your mailbox
   case GmailModify // View and modify but not delete your email
   case GmailMetadata // View your email message metadata such as labels and headers, but not the email body
   case GmailReadonly // View your email messages and settings
}


public struct GoogleCloudGmailConfiguration : GoogleCloudAPIConfiguration {
   public var scope : [GoogleCloudAPIScope]
   public var serviceAccount: String
   public var project: String?

   public init(scope: [GoogleCloudGmailScope], serviceAccount : String, project: String?) {
      self.scope = scope
      self.serviceAccount = serviceAccount
      self.project = project
   }
}


public enum GoogleCloudGmailError: GoogleCloudError {
   case projectIdMissing
   case unknownError(String)

   var localizedDescription: String {
      switch self {
      case .projectIdMissing:
         return "Missing project id for Gmail API. Did you forget to set your project id?"
      case .unknownError(let reason):
         return "An unknown error occured: \(reason)"
      }
   }
}
public final class GoogleCloudGmailRequest : GoogleCloudAPIRequest {
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
public protocol UsersAPIProtocol  {}
public final class GoogleCloudGmailUsersAPI : UsersAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func getProfile(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailProfile> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/profile", query: queryParams)
   }
   public func stop(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)/\(userId)/stop", query: queryParams)
   }
   public func watch(userId : String, body : GoogleCloudGmailWatchRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailWatchResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol DraftsAPIProtocol  {}
public final class GoogleCloudGmailDraftsAPI : DraftsAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func create(userId : String, body : GoogleCloudGmailDraft, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailDraft> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/drafts", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func delete(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/drafts/\(id)", query: queryParams)
   }
   public func get(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailDraft> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/drafts/\(id)", query: queryParams)
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListDraftsResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/drafts", query: queryParams)
   }
   public func send(userId : String, body : GoogleCloudGmailDraft, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/drafts/send", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func update(userId : String, id : String, body : GoogleCloudGmailDraft, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailDraft> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/drafts/\(id)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol HistoryAPIProtocol  {}
public final class GoogleCloudGmailHistoryAPI : HistoryAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListHistoryResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/history", query: queryParams)
   }
}

public protocol LabelsAPIProtocol  {}
public final class GoogleCloudGmailLabelsAPI : LabelsAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func create(userId : String, body : GoogleCloudGmailLabel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailLabel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/labels", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func delete(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/labels/\(id)", query: queryParams)
   }
   public func get(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailLabel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/labels/\(id)", query: queryParams)
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListLabelsResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/labels", query: queryParams)
   }
   public func patch(userId : String, id : String, body : GoogleCloudGmailLabel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailLabel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)/\(userId)/labels/\(id)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func update(userId : String, id : String, body : GoogleCloudGmailLabel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailLabel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/labels/\(id)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol MessagesAPIProtocol  {}
public final class GoogleCloudGmailMessagesAPI : MessagesAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func batchDelete(userId : String, body : GoogleCloudGmailBatchDeleteMessagesRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages/batchDelete", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func batchModify(userId : String, body : GoogleCloudGmailBatchModifyMessagesRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages/batchModify", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func delete(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/messages/\(id)", query: queryParams)
   }
   public func get(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/messages/\(id)", query: queryParams)
   }
   public func _import(userId : String, body : GoogleCloudGmailMessage, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages/import", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func insert(userId : String, body : GoogleCloudGmailMessage, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListMessagesResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/messages", query: queryParams)
   }
   public func modify(userId : String, id : String, body : GoogleCloudGmailModifyMessageRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages/\(id)/modify", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func send(userId : String, body : GoogleCloudGmailMessage, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages/send", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func trash(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages/\(id)/trash", query: queryParams)
   }
   public func untrash(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)/\(userId)/messages/\(id)/untrash", query: queryParams)
   }
}

public protocol SettingsAPIProtocol  {}
public final class GoogleCloudGmailSettingsAPI : SettingsAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func getAutoForwarding(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailAutoForwarding> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/autoForwarding", query: queryParams)
   }
   public func getImap(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailImapSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/imap", query: queryParams)
   }
   public func getLanguage(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailLanguageSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/language", query: queryParams)
   }
   public func getPop(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailPopSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/pop", query: queryParams)
   }
   public func getVacation(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailVacationSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/vacation", query: queryParams)
   }
   public func updateAutoForwarding(userId : String, body : GoogleCloudGmailAutoForwarding, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailAutoForwarding> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/settings/autoForwarding", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func updateImap(userId : String, body : GoogleCloudGmailImapSettings, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailImapSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/settings/imap", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func updateLanguage(userId : String, body : GoogleCloudGmailLanguageSettings, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailLanguageSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/settings/language", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func updatePop(userId : String, body : GoogleCloudGmailPopSettings, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailPopSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/settings/pop", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func updateVacation(userId : String, body : GoogleCloudGmailVacationSettings, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailVacationSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/settings/vacation", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol ThreadsAPIProtocol  {}
public final class GoogleCloudGmailThreadsAPI : ThreadsAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func delete(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/threads/\(id)", query: queryParams)
   }
   public func get(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailThread> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/threads/\(id)", query: queryParams)
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListThreadsResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/threads", query: queryParams)
   }
   public func modify(userId : String, id : String, body : GoogleCloudGmailModifyThreadRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailThread> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/threads/\(id)/modify", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func trash(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailThread> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)/\(userId)/threads/\(id)/trash", query: queryParams)
   }
   public func untrash(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailThread> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)/\(userId)/threads/\(id)/untrash", query: queryParams)
   }
}

public protocol AttachmentsAPIProtocol  {}
public final class GoogleCloudGmailAttachmentsAPI : AttachmentsAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func get(userId : String, messageId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailMessagePartBody> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/messages/\(messageId)/attachments/\(id)", query: queryParams)
   }
}

public protocol DelegatesAPIProtocol  {}
public final class GoogleCloudGmailDelegatesAPI : DelegatesAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func create(userId : String, body : GoogleCloudGmailDelegate, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailDelegate> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/settings/delegates", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func delete(userId : String, delegateEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/settings/delegates/\(delegateEmail)", query: queryParams)
   }
   public func get(userId : String, delegateEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailDelegate> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/delegates/\(delegateEmail)", query: queryParams)
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListDelegatesResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/delegates", query: queryParams)
   }
}

public protocol FiltersAPIProtocol  {}
public final class GoogleCloudGmailFiltersAPI : FiltersAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func create(userId : String, body : GoogleCloudGmailFilter, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailFilter> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/settings/filters", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func delete(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/settings/filters/\(id)", query: queryParams)
   }
   public func get(userId : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailFilter> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/filters/\(id)", query: queryParams)
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListFiltersResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/filters", query: queryParams)
   }
}

public protocol ForwardingAddressesAPIProtocol  {}
public final class GoogleCloudGmailForwardingAddressesAPI : ForwardingAddressesAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func create(userId : String, body : GoogleCloudGmailForwardingAddress, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailForwardingAddress> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/settings/forwardingAddresses", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func delete(userId : String, forwardingEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/settings/forwardingAddresses/\(forwardingEmail)", query: queryParams)
   }
   public func get(userId : String, forwardingEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailForwardingAddress> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/forwardingAddresses/\(forwardingEmail)", query: queryParams)
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListForwardingAddressesResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/forwardingAddresses", query: queryParams)
   }
}

public protocol SendAsAPIProtocol  {}
public final class GoogleCloudGmailSendAsAPI : SendAsAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func create(userId : String, body : GoogleCloudGmailSendAs, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailSendAs> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/settings/sendAs", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func delete(userId : String, sendAsEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)", query: queryParams)
   }
   public func get(userId : String, sendAsEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailSendAs> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)", query: queryParams)
   }
   public func list(userId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListSendAsResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/sendAs", query: queryParams)
   }
   public func patch(userId : String, sendAsEmail : String, body : GoogleCloudGmailSendAs, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailSendAs> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func update(userId : String, sendAsEmail : String, body : GoogleCloudGmailSendAs, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailSendAs> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func verify(userId : String, sendAsEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)/verify", query: queryParams)
   }
}

public protocol SmimeInfoAPIProtocol  {}
public final class GoogleCloudGmailSmimeInfoAPI : SmimeInfoAPIProtocol {
   let endpoint = "https://www.googleapis.com/gmail/v1/users/"
   let request : GoogleCloudGmailRequest

   init(request: GoogleCloudGmailRequest) {
      self.request = request
   }

   public func delete(userId : String, sendAsEmail : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)/smimeInfo/\(id)", query: queryParams)
   }
   public func get(userId : String, sendAsEmail : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailSmimeInfo> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)/smimeInfo/\(id)", query: queryParams)
   }
   public func insert(userId : String, sendAsEmail : String, body : GoogleCloudGmailSmimeInfo, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailSmimeInfo> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)/smimeInfo", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   public func list(userId : String, sendAsEmail : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailListSmimeInfoResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)/smimeInfo", query: queryParams)
   }
   public func setDefault(userId : String, sendAsEmail : String, id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudGmailEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)/\(userId)/settings/sendAs/\(sendAsEmail)/smimeInfo/\(id)/setDefault", query: queryParams)
   }
}

public struct PlaceHolderObject : GoogleCloudModel {}
public struct GoogleCloudGmailEmptyResponse : GoogleCloudModel {}
public struct GoogleCloudGmailAutoForwarding : GoogleCloudModel {
   public var disposition: String
   public var emailAddress: String
   public var enabled: Bool
}
public struct GoogleCloudGmailBatchDeleteMessagesRequest : GoogleCloudModel {
   public var ids: [String]
}
public struct GoogleCloudGmailBatchModifyMessagesRequest : GoogleCloudModel {
   public var addLabelIds: [String]
   public var ids: [String]
   public var removeLabelIds: [String]
}
public struct GoogleCloudGmailDelegate : GoogleCloudModel {
   public var delegateEmail: String
   public var verificationStatus: String
}
public struct GoogleCloudGmailDraft : GoogleCloudModel {
   public var id: String
   public var message:  GoogleCloudGmailMessage
}
public struct GoogleCloudGmailFilter : GoogleCloudModel {
   public var action:  GoogleCloudGmailFilterAction
   public var criteria:  GoogleCloudGmailFilterCriteria
   public var id: String
}
public struct GoogleCloudGmailFilterAction : GoogleCloudModel {
   public var addLabelIds: [String]
   public var forward: String
   public var removeLabelIds: [String]
}
public struct GoogleCloudGmailFilterCriteria : GoogleCloudModel {
   public var excludeChats: Bool
   public var from: String
   public var hasAttachment: Bool
   public var negatedQuery: String
   public var query: String
   public var size: Int
   public var sizeComparison: String
   public var subject: String
   public var to: String
}
public struct GoogleCloudGmailForwardingAddress : GoogleCloudModel {
   public var forwardingEmail: String
   public var verificationStatus: String
}
public struct GoogleCloudGmailHistory : GoogleCloudModel {
   public var id: String
   public var labelsAdded: [GoogleCloudGmailHistoryLabelAdded]
   public var labelsRemoved: [GoogleCloudGmailHistoryLabelRemoved]
   public var messages: [GoogleCloudGmailMessage]
   public var messagesAdded: [GoogleCloudGmailHistoryMessageAdded]
   public var messagesDeleted: [GoogleCloudGmailHistoryMessageDeleted]
}
public struct GoogleCloudGmailHistoryLabelAdded : GoogleCloudModel {
   public var labelIds: [String]
   public var message:  GoogleCloudGmailMessage
}
public struct GoogleCloudGmailHistoryLabelRemoved : GoogleCloudModel {
   public var labelIds: [String]
   public var message:  GoogleCloudGmailMessage
}
public struct GoogleCloudGmailHistoryMessageAdded : GoogleCloudModel {
   public var message:  GoogleCloudGmailMessage
}
public struct GoogleCloudGmailHistoryMessageDeleted : GoogleCloudModel {
   public var message:  GoogleCloudGmailMessage
}
public struct GoogleCloudGmailImapSettings : GoogleCloudModel {
   public var autoExpunge: Bool
   public var enabled: Bool
   public var expungeBehavior: String
   public var maxFolderSize: Int
}
public struct GoogleCloudGmailLabel : GoogleCloudModel {
   public var color:  GoogleCloudGmailLabelColor
   public var id: String
   public var labelListVisibility: String
   public var messageListVisibility: String
   public var messagesTotal: Int
   public var messagesUnread: Int
   public var name: String
   public var threadsTotal: Int
   public var threadsUnread: Int
   public var type: String
}
public struct GoogleCloudGmailLabelColor : GoogleCloudModel {
   public var backgroundColor: String
   public var textColor: String
}
public struct GoogleCloudGmailLanguageSettings : GoogleCloudModel {
   public var displayLanguage: String
}
public struct GoogleCloudGmailListDelegatesResponse : GoogleCloudModel {
   public var delegates: [GoogleCloudGmailDelegate]
}
public struct GoogleCloudGmailListDraftsResponse : GoogleCloudModel {
   public var drafts: [GoogleCloudGmailDraft]
   public var nextPageToken: String
   public var resultSizeEstimate: Int
}
public struct GoogleCloudGmailListFiltersResponse : GoogleCloudModel {
   public var filter: [GoogleCloudGmailFilter]
}
public struct GoogleCloudGmailListForwardingAddressesResponse : GoogleCloudModel {
   public var forwardingAddresses: [GoogleCloudGmailForwardingAddress]
}
public struct GoogleCloudGmailListHistoryResponse : GoogleCloudModel {
   public var history: [GoogleCloudGmailHistory]
   public var historyId: String
   public var nextPageToken: String
}
public struct GoogleCloudGmailListLabelsResponse : GoogleCloudModel {
   public var labels: [GoogleCloudGmailLabel]
}
public struct GoogleCloudGmailListMessagesResponse : GoogleCloudModel {
   public var messages: [GoogleCloudGmailMessage]
   public var nextPageToken: String
   public var resultSizeEstimate: Int
}
public struct GoogleCloudGmailListSendAsResponse : GoogleCloudModel {
   public var sendAs: [GoogleCloudGmailSendAs]
}
public struct GoogleCloudGmailListSmimeInfoResponse : GoogleCloudModel {
   public var smimeInfo: [GoogleCloudGmailSmimeInfo]
}
public struct GoogleCloudGmailListThreadsResponse : GoogleCloudModel {
   public var nextPageToken: String
   public var resultSizeEstimate: Int
   public var threads: [GoogleCloudGmailThread]
}
public struct GoogleCloudGmailMessage : GoogleCloudModel {
   public var historyId: String
   public var id: String
   public var internalDate: String
   public var labelIds: [String]
   public var payload:  GoogleCloudGmailMessagePart
   public var raw: String
   public var sizeEstimate: Int
   public var snippet: String
   public var threadId: String
}
public struct GoogleCloudGmailMessagePart : GoogleCloudModel {
   public var body:  GoogleCloudGmailMessagePartBody
   public var filename: String
   public var headers: [GoogleCloudGmailMessagePartHeader]
   public var mimeType: String
   public var partId: String
   public var parts: [GoogleCloudGmailMessagePart]
}
public struct GoogleCloudGmailMessagePartBody : GoogleCloudModel {
   public var attachmentId: String
   public var data: String
   public var size: Int
}
public struct GoogleCloudGmailMessagePartHeader : GoogleCloudModel {
   public var name: String
   public var value: String
}
public struct GoogleCloudGmailModifyMessageRequest : GoogleCloudModel {
   public var addLabelIds: [String]
   public var removeLabelIds: [String]
}
public struct GoogleCloudGmailModifyThreadRequest : GoogleCloudModel {
   public var addLabelIds: [String]
   public var removeLabelIds: [String]
}
public struct GoogleCloudGmailPopSettings : GoogleCloudModel {
   public var accessWindow: String
   public var disposition: String
}
public struct GoogleCloudGmailProfile : GoogleCloudModel {
   public var emailAddress: String
   public var historyId: String
   public var messagesTotal: Int
   public var threadsTotal: Int
}
public struct GoogleCloudGmailSendAs : GoogleCloudModel {
   public var displayName: String
   public var isDefault: Bool
   public var isPrimary: Bool
   public var replyToAddress: String
   public var sendAsEmail: String
   public var signature: String
   public var smtpMsa:  GoogleCloudGmailSmtpMsa
   public var treatAsAlias: Bool
   public var verificationStatus: String
}
public struct GoogleCloudGmailSmimeInfo : GoogleCloudModel {
   public var encryptedKeyPassword: String
   public var expiration: String
   public var id: String
   public var isDefault: Bool
   public var issuerCn: String
   public var pem: String
   public var pkcs12: String
}
public struct GoogleCloudGmailSmtpMsa : GoogleCloudModel {
   public var host: String
   public var password: String
   public var port: Int
   public var securityMode: String
   public var username: String
}
public struct GoogleCloudGmailThread : GoogleCloudModel {
   public var historyId: String
   public var id: String
   public var messages: [GoogleCloudGmailMessage]
   public var snippet: String
}
public struct GoogleCloudGmailVacationSettings : GoogleCloudModel {
   public var enableAutoReply: Bool
   public var endTime: String
   public var responseBodyHtml: String
   public var responseBodyPlainText: String
   public var responseSubject: String
   public var restrictToContacts: Bool
   public var restrictToDomain: Bool
   public var startTime: String
}
public struct GoogleCloudGmailWatchRequest : GoogleCloudModel {
   public var labelFilterAction: String
   public var labelIds: [String]
   public var topicName: String
}
public struct GoogleCloudGmailWatchResponse : GoogleCloudModel {
   public var expiration: String
   public var historyId: String
}
public final class GoogleCloudGmailClient {
   public var users : UsersAPIProtocol
   public var drafts : DraftsAPIProtocol
   public var history : HistoryAPIProtocol
   public var labels : LabelsAPIProtocol
   public var messages : MessagesAPIProtocol
   public var attachments : AttachmentsAPIProtocol
   public var settings : SettingsAPIProtocol
   public var delegates : DelegatesAPIProtocol
   public var filters : FiltersAPIProtocol
   public var forwardingAddresses : ForwardingAddressesAPIProtocol
   public var sendAs : SendAsAPIProtocol
   public var smimeInfo : SmimeInfoAPIProtocol
   public var threads : ThreadsAPIProtocol


   public init(credentials: GoogleCloudCredentialsConfiguration, gmailConfig: GoogleCloudGmailConfiguration, httpClient: HTTPClient, eventLoop: EventLoop) throws {
      let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: gmailConfig, andClient: httpClient, eventLoop: eventLoop)
      guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
               (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
               gmailConfig.project ?? credentials.project else {
         throw GoogleCloudGmailError.projectIdMissing
      }

      let request = GoogleCloudGmailRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)


      users = GoogleCloudGmailUsersAPI(request: request)
      drafts = GoogleCloudGmailDraftsAPI(request: request)
      history = GoogleCloudGmailHistoryAPI(request: request)
      labels = GoogleCloudGmailLabelsAPI(request: request)
      messages = GoogleCloudGmailMessagesAPI(request: request)
      attachments = GoogleCloudGmailAttachmentsAPI(request: request)
      settings = GoogleCloudGmailSettingsAPI(request: request)
      delegates = GoogleCloudGmailDelegatesAPI(request: request)
      filters = GoogleCloudGmailFiltersAPI(request: request)
      forwardingAddresses = GoogleCloudGmailForwardingAddressesAPI(request: request)
      sendAs = GoogleCloudGmailSendAsAPI(request: request)
      smimeInfo = GoogleCloudGmailSmimeInfoAPI(request: request)
      threads = GoogleCloudGmailThreadsAPI(request: request)
   }
}
