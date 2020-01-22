// This is Generated Code


import Foundation
import AsyncHTTPClient
import NIO
import Core
import NIOFoundationCompat
import NIOHTTP1


public enum GoogleCloudCalendarScope : GoogleCloudAPIScope {
   public var value : String {
      switch self {
      case .CalendarEvents: return "https://www.googleapis.com/auth/calendar.events"
      case .CalendarEventsReadonly: return "https://www.googleapis.com/auth/calendar.events.readonly"
      case .CalendarSettingsReadonly: return "https://www.googleapis.com/auth/calendar.settings.readonly"
      case .CalendarReadonly: return "https://www.googleapis.com/auth/calendar.readonly"
      case .Calendar: return "https://www.googleapis.com/auth/calendar"
      }
   }

   case CalendarEvents // View and edit events on all your calendars
   case CalendarEventsReadonly // View events on all your calendars
   case CalendarSettingsReadonly // View your Calendar settings
   case CalendarReadonly // View your calendars
   case Calendar // See, edit, share, and permanently delete all the calendars you can access using Google Calendar
}


public struct GoogleCloudCalendarConfiguration : GoogleCloudAPIConfiguration {
   public var scope : [GoogleCloudAPIScope]
   public var serviceAccount: String
   public var project: String?
   public var subscription: String?

   public init(scope: [GoogleCloudCalendarScope], serviceAccount : String, project: String?, subscription: String?) {
      self.scope = scope
      self.serviceAccount = serviceAccount
      self.project = project
      self.subscription = subscription
   }
}


public final class GoogleCloudCalendarRequest : GoogleCloudAPIRequest {
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
public final class GoogleCloudCalendarAclAPI : CalendarAclAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Deletes an access control rule.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter ruleId: ACL rule identifier.

   public func delete(calendarId : String, ruleId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)calendars/\(calendarId)/acl/\(ruleId)", query: queryParams)
   }
   /// Returns an access control rule.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter ruleId: ACL rule identifier.

   public func get(calendarId : String, ruleId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)calendars/\(calendarId)/acl/\(ruleId)", query: queryParams)
   }
   /// Creates an access control rule.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func insert(calendarId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/acl", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns the rules in the access control list for the calendar.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func list(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAcl> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)calendars/\(calendarId)/acl", query: queryParams)
   }
   /// Updates an access control rule. This method supports patch semantics.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter ruleId: ACL rule identifier.

   public func patch(calendarId : String, ruleId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)calendars/\(calendarId)/acl/\(ruleId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates an access control rule.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter ruleId: ACL rule identifier.

   public func update(calendarId : String, ruleId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)calendars/\(calendarId)/acl/\(ruleId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Watch for changes to ACL resources.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func watch(calendarId : String, body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/acl/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol CalendarAclAPIProtocol  {
   /// Deletes an access control rule.
   func delete(calendarId : String, ruleId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse>
   /// Returns an access control rule.
   func get(calendarId : String, ruleId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule>
   /// Creates an access control rule.
   func insert(calendarId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule>
   /// Returns the rules in the access control list for the calendar.
   func list(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAcl>
   /// Updates an access control rule. This method supports patch semantics.
   func patch(calendarId : String, ruleId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule>
   /// Updates an access control rule.
   func update(calendarId : String, ruleId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarAclRule>
   /// Watch for changes to ACL resources.
   func watch(calendarId : String, body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel>
}
extension CalendarAclAPIProtocol   {
      public func delete(calendarId : String, ruleId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      delete(calendarId: calendarId,ruleId: ruleId,  queryParameters: queryParameters)
   }

      public func get(calendarId : String, ruleId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      get(calendarId: calendarId,ruleId: ruleId,  queryParameters: queryParameters)
   }

      public func insert(calendarId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      insert(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

      public func list(calendarId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarAcl> {
      list(calendarId: calendarId,  queryParameters: queryParameters)
   }

      public func patch(calendarId : String, ruleId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      patch(calendarId: calendarId,ruleId: ruleId, body: body, queryParameters: queryParameters)
   }

      public func update(calendarId : String, ruleId : String, body : GoogleCloudCalendarAclRule, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarAclRule> {
      update(calendarId: calendarId,ruleId: ruleId, body: body, queryParameters: queryParameters)
   }

      public func watch(calendarId : String, body : GoogleCloudCalendarChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      watch(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudCalendarCalendarListAPI : CalendarCalendarListAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Removes a calendar from the user's calendar list.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func delete(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)users/me/calendarList/\(calendarId)", query: queryParams)
   }
   /// Returns a calendar from the user's calendar list.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func get(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)users/me/calendarList/\(calendarId)", query: queryParams)
   }
   /// Inserts an existing calendar into the user's calendar list.
   
   public func insert(body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)users/me/calendarList", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns the calendars on the user's calendar list.
   
   public func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarList> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)users/me/calendarList", query: queryParams)
   }
   /// Updates an existing calendar on the user's calendar list. This method supports patch semantics.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func patch(calendarId : String, body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)users/me/calendarList/\(calendarId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates an existing calendar on the user's calendar list.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func update(calendarId : String, body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)users/me/calendarList/\(calendarId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Watch for changes to CalendarList resources.
   
   public func watch(body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)users/me/calendarList/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol CalendarCalendarListAPIProtocol  {
   /// Removes a calendar from the user's calendar list.
   func delete(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse>
   /// Returns a calendar from the user's calendar list.
   func get(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry>
   /// Inserts an existing calendar into the user's calendar list.
   func insert(body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry>
   /// Returns the calendars on the user's calendar list.
   func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarList>
   /// Updates an existing calendar on the user's calendar list. This method supports patch semantics.
   func patch(calendarId : String, body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry>
   /// Updates an existing calendar on the user's calendar list.
   func update(calendarId : String, body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry>
   /// Watch for changes to CalendarList resources.
   func watch(body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel>
}
extension CalendarCalendarListAPIProtocol   {
      public func delete(calendarId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      delete(calendarId: calendarId,  queryParameters: queryParameters)
   }

      public func get(calendarId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      get(calendarId: calendarId,  queryParameters: queryParameters)
   }

      public func insert(body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      insert( body: body, queryParameters: queryParameters)
   }

      public func list( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendarList> {
      list(  queryParameters: queryParameters)
   }

      public func patch(calendarId : String, body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      patch(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

      public func update(calendarId : String, body : GoogleCloudCalendarCalendarListEntry, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendarListEntry> {
      update(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

      public func watch(body : GoogleCloudCalendarChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      watch( body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudCalendarCalendarsAPI : CalendarCalendarsAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func clear(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/clear", query: queryParams)
   }
   /// Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func delete(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)calendars/\(calendarId)", query: queryParams)
   }
   /// Returns metadata for a calendar.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func get(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)calendars/\(calendarId)", query: queryParams)
   }
   /// Creates a secondary calendar.
   
   public func insert(body : GoogleCloudCalendarCalendar, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)calendars", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates metadata for a calendar. This method supports patch semantics.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func patch(calendarId : String, body : GoogleCloudCalendarCalendar, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)calendars/\(calendarId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates metadata for a calendar.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func update(calendarId : String, body : GoogleCloudCalendarCalendar, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)calendars/\(calendarId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol CalendarCalendarsAPIProtocol  {
   /// Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
   func clear(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse>
   /// Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
   func delete(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse>
   /// Returns metadata for a calendar.
   func get(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar>
   /// Creates a secondary calendar.
   func insert(body : GoogleCloudCalendarCalendar, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar>
   /// Updates metadata for a calendar. This method supports patch semantics.
   func patch(calendarId : String, body : GoogleCloudCalendarCalendar, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar>
   /// Updates metadata for a calendar.
   func update(calendarId : String, body : GoogleCloudCalendarCalendar, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarCalendar>
}
extension CalendarCalendarsAPIProtocol   {
      public func clear(calendarId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      clear(calendarId: calendarId,  queryParameters: queryParameters)
   }

      public func delete(calendarId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      delete(calendarId: calendarId,  queryParameters: queryParameters)
   }

      public func get(calendarId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      get(calendarId: calendarId,  queryParameters: queryParameters)
   }

      public func insert(body : GoogleCloudCalendarCalendar, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      insert( body: body, queryParameters: queryParameters)
   }

      public func patch(calendarId : String, body : GoogleCloudCalendarCalendar, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      patch(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

      public func update(calendarId : String, body : GoogleCloudCalendarCalendar, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarCalendar> {
      update(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudCalendarChannelsAPI : CalendarChannelsAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Stop watching resources through this channel
   
   public func stop(body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
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

public protocol CalendarChannelsAPIProtocol  {
   /// Stop watching resources through this channel
   func stop(body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse>
}
extension CalendarChannelsAPIProtocol   {
      public func stop(body : GoogleCloudCalendarChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      stop( body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudCalendarColorsAPI : CalendarColorsAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Returns the color definitions for calendars and events.
   
   public func get( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarColors> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)colors", query: queryParams)
   }
}

public protocol CalendarColorsAPIProtocol  {
   /// Returns the color definitions for calendars and events.
   func get( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarColors>
}
extension CalendarColorsAPIProtocol   {
      public func get( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarColors> {
      get(  queryParameters: queryParameters)
   }

}
public final class GoogleCloudCalendarEventsAPI : CalendarEventsAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Deletes an event.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter eventId: Event identifier.

   public func delete(calendarId : String, eventId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)calendars/\(calendarId)/events/\(eventId)", query: queryParams)
   }
   /// Returns an event.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter eventId: Event identifier.

   public func get(calendarId : String, eventId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)calendars/\(calendarId)/events/\(eventId)", query: queryParams)
   }
   /// Imports an event. This operation is used to add a private copy of an existing event to a calendar.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func `import`(calendarId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/events/import", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Creates an event.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func insert(calendarId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/events", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns instances of the specified recurring event.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter eventId: Recurring event identifier.

   public func instances(calendarId : String, eventId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvents> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)calendars/\(calendarId)/events/\(eventId)/instances", query: queryParams)
   }
   /// Returns events on the specified calendar.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func list(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvents> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)calendars/\(calendarId)/events", query: queryParams)
   }
   /// Moves an event to another calendar, i.e. changes an event's organizer.
   /// - Parameter calendarId: Calendar identifier of the source calendar where the event currently is on.
/// - Parameter eventId: Event identifier.
/// - Parameter destination: Calendar identifier of the target calendar where the event is to be moved to.

   public func move(calendarId : String, eventId : String, destination : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/events/\(eventId)/move", query: queryParams)
   }
   /// Updates an event. This method supports patch semantics.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter eventId: Event identifier.

   public func patch(calendarId : String, eventId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PATCH, path: "\(endpoint)calendars/\(calendarId)/events/\(eventId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Creates an event based on a simple text string.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter text: The text describing the event to be created.

   public func quickAdd(calendarId : String, text : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/events/quickAdd", query: queryParams)
   }
   /// Updates an event.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
/// - Parameter eventId: Event identifier.

   public func update(calendarId : String, eventId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)calendars/\(calendarId)/events/\(eventId)", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Watch for changes to Events resources.
   /// - Parameter calendarId: Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.

   public func watch(calendarId : String, body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)calendars/\(calendarId)/events/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol CalendarEventsAPIProtocol  {
   /// Deletes an event.
   func delete(calendarId : String, eventId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse>
   /// Returns an event.
   func get(calendarId : String, eventId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent>
   /// Imports an event. This operation is used to add a private copy of an existing event to a calendar.
   func `import`(calendarId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent>
   /// Creates an event.
   func insert(calendarId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent>
   /// Returns instances of the specified recurring event.
   func instances(calendarId : String, eventId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvents>
   /// Returns events on the specified calendar.
   func list(calendarId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvents>
   /// Moves an event to another calendar, i.e. changes an event's organizer.
   func move(calendarId : String, eventId : String, destination : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent>
   /// Updates an event. This method supports patch semantics.
   func patch(calendarId : String, eventId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent>
   /// Creates an event based on a simple text string.
   func quickAdd(calendarId : String, text : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent>
   /// Updates an event.
   func update(calendarId : String, eventId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarEvent>
   /// Watch for changes to Events resources.
   func watch(calendarId : String, body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel>
}
extension CalendarEventsAPIProtocol   {
      public func delete(calendarId : String, eventId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEmptyResponse> {
      delete(calendarId: calendarId,eventId: eventId,  queryParameters: queryParameters)
   }

      public func get(calendarId : String, eventId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      get(calendarId: calendarId,eventId: eventId,  queryParameters: queryParameters)
   }

      public func `import`(calendarId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      `import`(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

      public func insert(calendarId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      insert(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

      public func instances(calendarId : String, eventId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvents> {
      instances(calendarId: calendarId,eventId: eventId,  queryParameters: queryParameters)
   }

      public func list(calendarId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvents> {
      list(calendarId: calendarId,  queryParameters: queryParameters)
   }

      public func move(calendarId : String, eventId : String, destination : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      move(calendarId: calendarId,eventId: eventId,destination: destination,  queryParameters: queryParameters)
   }

      public func patch(calendarId : String, eventId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      patch(calendarId: calendarId,eventId: eventId, body: body, queryParameters: queryParameters)
   }

      public func quickAdd(calendarId : String, text : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      quickAdd(calendarId: calendarId,text: text,  queryParameters: queryParameters)
   }

      public func update(calendarId : String, eventId : String, body : GoogleCloudCalendarEvent, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarEvent> {
      update(calendarId: calendarId,eventId: eventId, body: body, queryParameters: queryParameters)
   }

      public func watch(calendarId : String, body : GoogleCloudCalendarChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      watch(calendarId: calendarId, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudCalendarFreebusyAPI : CalendarFreebusyAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Returns free/busy information for a set of calendars.
   
   public func query(body : GoogleCloudCalendarFreeBusyRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarFreeBusyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)freeBusy", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol CalendarFreebusyAPIProtocol  {
   /// Returns free/busy information for a set of calendars.
   func query(body : GoogleCloudCalendarFreeBusyRequest, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarFreeBusyResponse>
}
extension CalendarFreebusyAPIProtocol   {
      public func query(body : GoogleCloudCalendarFreeBusyRequest, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarFreeBusyResponse> {
      query( body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudCalendarSettingsAPI : CalendarSettingsAPIProtocol {
   let endpoint = "https://www.googleapis.com/calendar/v3/"
   let request : GoogleCloudCalendarRequest

   init(request: GoogleCloudCalendarRequest) {
      self.request = request
   }

   /// Returns a single user setting.
   /// - Parameter setting: The id of the user setting.

   public func get(setting : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarSetting> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)users/me/settings/\(setting)", query: queryParams)
   }
   /// Returns all user settings for the authenticated user.
   
   public func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarSettings> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)users/me/settings", query: queryParams)
   }
   /// Watch for changes to Settings resources.
   
   public func watch(body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)users/me/settings/watch", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol CalendarSettingsAPIProtocol  {
   /// Returns a single user setting.
   func get(setting : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarSetting>
   /// Returns all user settings for the authenticated user.
   func list( queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarSettings>
   /// Watch for changes to Settings resources.
   func watch(body : GoogleCloudCalendarChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudCalendarChannel>
}
extension CalendarSettingsAPIProtocol   {
      public func get(setting : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarSetting> {
      get(setting: setting,  queryParameters: queryParameters)
   }

      public func list( queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarSettings> {
      list(  queryParameters: queryParameters)
   }

      public func watch(body : GoogleCloudCalendarChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudCalendarChannel> {
      watch( body: body, queryParameters: queryParameters)
   }

}
public struct GoogleCloudCalendarEmptyResponse : GoogleCloudModel {}
public struct GoogleCloudCalendarAcl : GoogleCloudModel {
   /*ETag of the collection. */
   public var etag: String?
   /*List of rules on the access control list. */
   public var items: [GoogleCloudCalendarAclRule]?
   /*Type of the collection ("calendar#acl"). */
   public var kind: String?
   /*Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided. */
   public var nextPageToken: String?
   /*Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided. */
   public var nextSyncToken: String?
}
public struct GoogleCloudCalendarAclRule : GoogleCloudModel {
   /*ETag of the resource. */
   public var etag: String?
   /*Identifier of the ACL rule. */
   public var id: String?
   /*Type of the resource ("calendar#aclRule"). */
   public var kind: String?
   /*The role assigned to the scope. Possible values are:  
- "none" - Provides no access. 
- "freeBusyReader" - Provides read access to free/busy information. 
- "reader" - Provides read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
- "writer" - Provides read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
- "owner" - Provides ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs. */
   public var role: String?
   /*The scope of the rule. */
   public var scope: GoogleCloudCalendarAclRuleScope?
}
public struct GoogleCloudCalendarCalendar : GoogleCloudModel {
   /*Conferencing properties for this calendar, for example what types of conferences are allowed. */
   public var conferenceProperties:  GoogleCloudCalendarConferenceProperties?
   /*Description of the calendar. Optional. */
   public var description: String?
   /*ETag of the resource. */
   public var etag: String?
   /*Identifier of the calendar. To retrieve IDs call the calendarList.list() method. */
   public var id: String?
   /*Type of the resource ("calendar#calendar"). */
   public var kind: String?
   /*Geographic location of the calendar as free-form text. Optional. */
   public var location: String?
   /*Title of the calendar. */
   public var summary: String?
   /*The time zone of the calendar. (Formatted as an IANA Time Zone Database name, e.g. "Europe/Zurich".) Optional. */
   public var timeZone: String?
}
public struct GoogleCloudCalendarCalendarList : GoogleCloudModel {
   /*ETag of the collection. */
   public var etag: String?
   /*Calendars that are present on the user's calendar list. */
   public var items: [GoogleCloudCalendarCalendarListEntry]?
   /*Type of the collection ("calendar#calendarList"). */
   public var kind: String?
   /*Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided. */
   public var nextPageToken: String?
   /*Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided. */
   public var nextSyncToken: String?
}
public struct GoogleCloudCalendarCalendarListEntry : GoogleCloudModel {
   /*The effective access role that the authenticated user has on the calendar. Read-only. Possible values are:  
- "freeBusyReader" - Provides read access to free/busy information. 
- "reader" - Provides read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
- "writer" - Provides read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
- "owner" - Provides ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs. */
   public var accessRole: String?
   /*The main color of the calendar in the hexadecimal format "#0088aa". This property supersedes the index-based colorId property. To set or change this property, you need to specify colorRgbFormat=true in the parameters of the insert, update and patch methods. Optional. */
   public var backgroundColor: String?
   /*The color of the calendar. This is an ID referring to an entry in the calendar section of the colors definition (see the colors endpoint). This property is superseded by the backgroundColor and foregroundColor properties and can be ignored when using these properties. Optional. */
   public var colorId: String?
   /*Conferencing properties for this calendar, for example what types of conferences are allowed. */
   public var conferenceProperties:  GoogleCloudCalendarConferenceProperties?
   /*The default reminders that the authenticated user has for this calendar. */
   public var defaultReminders: [GoogleCloudCalendarEventReminder]?
   /*Whether this calendar list entry has been deleted from the calendar list. Read-only. Optional. The default is False. */
   public var deleted: Bool?
   /*Description of the calendar. Optional. Read-only. */
   public var description: String?
   /*ETag of the resource. */
   public var etag: String?
   /*The foreground color of the calendar in the hexadecimal format "#ffffff". This property supersedes the index-based colorId property. To set or change this property, you need to specify colorRgbFormat=true in the parameters of the insert, update and patch methods. Optional. */
   public var foregroundColor: String?
   /*Whether the calendar has been hidden from the list. Optional. The default is False. */
   public var hidden: Bool?
   /*Identifier of the calendar. */
   public var id: String?
   /*Type of the resource ("calendar#calendarListEntry"). */
   public var kind: String?
   /*Geographic location of the calendar as free-form text. Optional. Read-only. */
   public var location: String?
   /*The notifications that the authenticated user is receiving for this calendar. */
   public var notificationSettings: GoogleCloudCalendarCalendarListEntryNotificationSettings?
   /*Whether the calendar is the primary calendar of the authenticated user. Read-only. Optional. The default is False. */
   public var primary: Bool?
   /*Whether the calendar content shows up in the calendar UI. Optional. The default is False. */
   public var selected: Bool?
   /*Title of the calendar. Read-only. */
   public var summary: String?
   /*The summary that the authenticated user has set for this calendar. Optional. */
   public var summaryOverride: String?
   /*The time zone of the calendar. Optional. Read-only. */
   public var timeZone: String?
}
public struct GoogleCloudCalendarCalendarNotification : GoogleCloudModel {
   /*The method used to deliver the notification. Possible values are:  
- "email" - Notifications are sent via email. 
- "sms" - Deprecated. Once this feature is shutdown, the API will no longer return notifications using this method. Any newly added SMS notifications will be ignored. See  Google Calendar SMS notifications to be removed for more information.
Notifications are sent via SMS. This value is read-only and is ignored on inserts and updates. SMS notifications are only available for G Suite customers.  
Required when adding a notification. */
   public var method: String?
   /*The type of notification. Possible values are:  
- "eventCreation" - Notification sent when a new event is put on the calendar. 
- "eventChange" - Notification sent when an event is changed. 
- "eventCancellation" - Notification sent when an event is cancelled. 
- "eventResponse" - Notification sent when an attendee responds to the event invitation. 
- "agenda" - An agenda with the events of the day (sent out in the morning).  
Required when adding a notification. */
   public var type: String?
}
public struct GoogleCloudCalendarChannel : GoogleCloudModel {
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
public struct GoogleCloudCalendarColorDefinition : GoogleCloudModel {
   /*The background color associated with this color definition. */
   public var background: String?
   /*The foreground color that can be used to write on top of a background with 'background' color. */
   public var foreground: String?
}
public struct GoogleCloudCalendarColors : GoogleCloudModel {
   /*A global palette of calendar colors, mapping from the color ID to its definition. A calendarListEntry resource refers to one of these color IDs in its color field. Read-only. */
   public var calendar: [String : GoogleCloudCalendarColorDefinition]?
   /*A global palette of event colors, mapping from the color ID to its definition. An event resource may refer to one of these color IDs in its color field. Read-only. */
   public var event: [String : GoogleCloudCalendarColorDefinition]?
   /*Type of the resource ("calendar#colors"). */
   public var kind: String?
   /*Last modification time of the color palette (as a RFC3339 timestamp). Read-only. */
   public var updated: String?
}
public struct GoogleCloudCalendarConferenceData : GoogleCloudModel {
   /*The ID of the conference.
Can be used by developers to keep track of conferences, should not be displayed to users.
Values for solution types:  
- "eventHangout": unset.
- "eventNamedHangout": the name of the Hangout.
- "hangoutsMeet": the 10-letter meeting code, for example "aaa-bbbb-ccc".
- "addOn": defined by 3P conference provider.  Optional. */
   public var conferenceId: String?
   /*The conference solution, such as Hangouts or Hangouts Meet.
Unset for a conference with a failed create request.
Either conferenceSolution and at least one entryPoint, or createRequest is required. */
   public var conferenceSolution:  GoogleCloudCalendarConferenceSolution?
   /*A request to generate a new conference and attach it to the event. The data is generated asynchronously. To see whether the data is present check the status field.
Either conferenceSolution and at least one entryPoint, or createRequest is required. */
   public var createRequest:  GoogleCloudCalendarCreateConferenceRequest?
   /*Information about individual conference entry points, such as URLs or phone numbers.
All of them must belong to the same conference.
Either conferenceSolution and at least one entryPoint, or createRequest is required. */
   public var entryPoints: [GoogleCloudCalendarEntryPoint]?
   /*Additional notes (such as instructions from the domain administrator, legal notices) to display to the user. Can contain HTML. The maximum length is 2048 characters. Optional. */
   public var notes: String?
   /*Additional properties related to a conference. An example would be a solution-specific setting for enabling video streaming. */
   public var parameters:  GoogleCloudCalendarConferenceParameters?
   /*The signature of the conference data.
Generated on server side. Must be preserved while copying the conference data between events, otherwise the conference data will not be copied.
Unset for a conference with a failed create request.
Optional for a conference with a pending create request. */
   public var signature: String?
}
public struct GoogleCloudCalendarConferenceParameters : GoogleCloudModel {
   /*Additional add-on specific data. */
   public var addOnParameters:  GoogleCloudCalendarConferenceParametersAddOnParameters?
}
public struct GoogleCloudCalendarConferenceParametersAddOnParameters : GoogleCloudModel {
   public var parameters: [String : String]?
}
public struct GoogleCloudCalendarConferenceProperties : GoogleCloudModel {
   /*The types of conference solutions that are supported for this calendar.
The possible values are:  
- "eventHangout" 
- "eventNamedHangout" 
- "hangoutsMeet"  Optional. */
   public var allowedConferenceSolutionTypes: [String]?
}
public struct GoogleCloudCalendarConferenceRequestStatus : GoogleCloudModel {
   /*The current status of the conference create request. Read-only.
The possible values are:  
- "pending": the conference create request is still being processed.
- "success": the conference create request succeeded, the entry points are populated.
- "failure": the conference create request failed, there are no entry points. */
   public var statusCode: String?
}
public struct GoogleCloudCalendarConferenceSolution : GoogleCloudModel {
   /*The user-visible icon for this solution. */
   public var iconUri: String?
   /*The key which can uniquely identify the conference solution for this event. */
   public var key:  GoogleCloudCalendarConferenceSolutionKey?
   /*The user-visible name of this solution. Not localized. */
   public var name: String?
}
public struct GoogleCloudCalendarConferenceSolutionKey : GoogleCloudModel {
   /*The conference solution type.
If a client encounters an unfamiliar or empty type, it should still be able to display the entry points. However, it should disallow modifications.
The possible values are:  
- "eventHangout" for Hangouts for consumers (http://hangouts.google.com)
- "eventNamedHangout" for classic Hangouts for G Suite users (http://hangouts.google.com)
- "hangoutsMeet" for Hangouts Meet (http://meet.google.com)
- "addOn" for 3P conference providers */
   public var type: String?
}
public struct GoogleCloudCalendarCreateConferenceRequest : GoogleCloudModel {
   /*The conference solution, such as Hangouts or Hangouts Meet. */
   public var conferenceSolutionKey:  GoogleCloudCalendarConferenceSolutionKey?
   /*The client-generated unique ID for this request.
Clients should regenerate this ID for every new request. If an ID provided is the same as for the previous request, the request is ignored. */
   public var requestId: String?
   /*The status of the conference create request. */
   public var status:  GoogleCloudCalendarConferenceRequestStatus?
}
public struct GoogleCloudCalendarEntryPoint : GoogleCloudModel {
   /*The access code to access the conference. The maximum length is 128 characters.
When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
Optional. */
   public var accessCode: String?
   /*Features of the entry point, such as being toll or toll-free. One entry point can have multiple features. However, toll and toll-free cannot be both set on the same entry point. */
   public var entryPointFeatures: [String]?
   /*The type of the conference entry point.
Possible values are:  
- "video" - joining a conference over HTTP. A conference can have zero or one video entry point.
- "phone" - joining a conference by dialing a phone number. A conference can have zero or more phone entry points.
- "sip" - joining a conference over SIP. A conference can have zero or one sip entry point.
- "more" - further conference joining instructions, for example additional phone numbers. A conference can have zero or one more entry point. A conference with only a more entry point is not a valid conference. */
   public var entryPointType: String?
   /*The label for the URI. Visible to end users. Not localized. The maximum length is 512 characters.
Examples:  
- for video: meet.google.com/aaa-bbbb-ccc
- for phone: +1 123 268 2601
- for sip: 12345678@altostrat.com
- for more: should not be filled  
Optional. */
   public var label: String?
   /*The meeting code to access the conference. The maximum length is 128 characters.
When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
Optional. */
   public var meetingCode: String?
   /*The passcode to access the conference. The maximum length is 128 characters.
When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed. */
   public var passcode: String?
   /*The password to access the conference. The maximum length is 128 characters.
When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
Optional. */
   public var password: String?
   /*The PIN to access the conference. The maximum length is 128 characters.
When creating new conference data, populate only the subset of {meetingCode, accessCode, passcode, password, pin} fields that match the terminology that the conference provider uses. Only the populated fields should be displayed.
Optional. */
   public var pin: String?
   /*The CLDR/ISO 3166 region code for the country associated with this phone access. Example: "SE" for Sweden.
Calendar backend will populate this field only for EntryPointType.PHONE. */
   public var regionCode: String?
   /*The URI of the entry point. The maximum length is 1300 characters.
Format:  
- for video, http: or https: schema is required.
- for phone, tel: schema is required. The URI should include the entire dial sequence (e.g., tel:+12345678900,,,123456789;1234).
- for sip, sip: schema is required, e.g., sip:12345678@myprovider.com.
- for more, http: or https: schema is required. */
   public var uri: String?
}
public struct GoogleCloudCalendarError : GoogleCloudModel {
   /*Domain, or broad category, of the error. */
   public var domain: String?
   /*Specific reason for the error. Some of the possible values are:  
- "groupTooBig" - The group of users requested is too large for a single query. 
- "tooManyCalendarsRequested" - The number of calendars requested is too large for a single query. 
- "notFound" - The requested resource was not found. 
- "internalError" - The API service has encountered an internal error.  Additional error types may be added in the future, so clients should gracefully handle additional error statuses not included in this list. */
   public var reason: String?
}
public struct GoogleCloudCalendarEvent : GoogleCloudModel {
   /*Whether anyone can invite themselves to the event (currently works for Google+ events only). Optional. The default is False. */
   public var anyoneCanAddSelf: Bool?
   /*File attachments for the event. Currently only Google Drive attachments are supported.
In order to modify attachments the supportsAttachments request parameter should be set to true.
There can be at most 25 attachments per event, */
   public var attachments: [GoogleCloudCalendarEventAttachment]?
   /*The attendees of the event. See the Events with attendees guide for more information on scheduling events with other calendar users. */
   public var attendees: [GoogleCloudCalendarEventAttendee]?
   /*Whether attendees may have been omitted from the event's representation. When retrieving an event, this may be due to a restriction specified by the maxAttendee query parameter. When updating an event, this can be used to only update the participant's response. Optional. The default is False. */
   public var attendeesOmitted: Bool?
   /*The color of the event. This is an ID referring to an entry in the event section of the colors definition (see the  colors endpoint). Optional. */
   public var colorId: String?
   /*The conference-related information, such as details of a Hangouts Meet conference. To create new conference details use the createRequest field. To persist your changes, remember to set the conferenceDataVersion request parameter to 1 for all event modification requests. */
   public var conferenceData:  GoogleCloudCalendarConferenceData?
   /*Creation time of the event (as a RFC3339 timestamp). Read-only. */
   public var created: String?
   /*The creator of the event. Read-only. */
   public var creator: GoogleCloudCalendarEventCreator?
   /*Description of the event. Can contain HTML. Optional. */
   public var description: String?
   /*The (exclusive) end time of the event. For a recurring event, this is the end time of the first instance. */
   public var end:  GoogleCloudCalendarEventDateTime?
   /*Whether the end time is actually unspecified. An end time is still provided for compatibility reasons, even if this attribute is set to True. The default is False. */
   public var endTimeUnspecified: Bool?
   /*ETag of the resource. */
   public var etag: String?
   /*Extended properties of the event. */
   public var extendedProperties: GoogleCloudCalendarEventExtendedProperties?
   /*A gadget that extends this event. */
   public var gadget: GoogleCloudCalendarEventGadget?
   /*Whether attendees other than the organizer can invite others to the event. Optional. The default is True. */
   public var guestsCanInviteOthers: Bool?
   /*Whether attendees other than the organizer can modify the event. Optional. The default is False. */
   public var guestsCanModify: Bool?
   /*Whether attendees other than the organizer can see who the event's attendees are. Optional. The default is True. */
   public var guestsCanSeeOtherGuests: Bool?
   /*An absolute link to the Google+ hangout associated with this event. Read-only. */
   public var hangoutLink: String?
   /*An absolute link to this event in the Google Calendar Web UI. Read-only. */
   public var htmlLink: String?
   /*Event unique identifier as defined in RFC5545. It is used to uniquely identify events accross calendaring systems and must be supplied when importing events via the import method.
Note that the icalUID and the id are not identical and only one of them should be supplied at event creation time. One difference in their semantics is that in recurring events, all occurrences of one event have different ids while they all share the same icalUIDs. */
   public var iCalUID: String?
   /*Opaque identifier of the event. When creating new single or recurring events, you can specify their IDs. Provided IDs must follow these rules:  
- characters allowed in the ID are those used in base32hex encoding, i.e. lowercase letters a-v and digits 0-9, see section 3.1.2 in RFC2938 
- the length of the ID must be between 5 and 1024 characters 
- the ID must be unique per calendar  Due to the globally distributed nature of the system, we cannot guarantee that ID collisions will be detected at event creation time. To minimize the risk of collisions we recommend using an established UUID algorithm such as one described in RFC4122.
If you do not specify an ID, it will be automatically generated by the server.
Note that the icalUID and the id are not identical and only one of them should be supplied at event creation time. One difference in their semantics is that in recurring events, all occurrences of one event have different ids while they all share the same icalUIDs. */
   public var id: String?
   /*Type of the resource ("calendar#event"). */
   public var kind: String?
   /*Geographic location of the event as free-form text. Optional. */
   public var location: String?
   /*Whether this is a locked event copy where no changes can be made to the main event fields "summary", "description", "location", "start", "end" or "recurrence". The default is False. Read-Only. */
   public var locked: Bool?
   /*The organizer of the event. If the organizer is also an attendee, this is indicated with a separate entry in attendees with the organizer field set to True. To change the organizer, use the move operation. Read-only, except when importing an event. */
   public var organizer: GoogleCloudCalendarEventOrganizer?
   /*For an instance of a recurring event, this is the time at which this event would start according to the recurrence data in the recurring event identified by recurringEventId. It uniquely identifies the instance within the recurring event series even if the instance was moved to a different time. Immutable. */
   public var originalStartTime:  GoogleCloudCalendarEventDateTime?
   /*If set to True, Event propagation is disabled. Note that it is not the same thing as Private event properties. Optional. Immutable. The default is False. */
   public var privateCopy: Bool?
   /*List of RRULE, EXRULE, RDATE and EXDATE lines for a recurring event, as specified in RFC5545. Note that DTSTART and DTEND lines are not allowed in this field; event start and end times are specified in the start and end fields. This field is omitted for single events or instances of recurring events. */
   public var recurrence: [String]?
   /*For an instance of a recurring event, this is the id of the recurring event to which this instance belongs. Immutable. */
   public var recurringEventId: String?
   /*Information about the event's reminders for the authenticated user. */
   public var reminders: GoogleCloudCalendarEventReminders?
   /*Sequence number as per iCalendar. */
   public var sequence: Int?
   /*Source from which the event was created. For example, a web page, an email message or any document identifiable by an URL with HTTP or HTTPS scheme. Can only be seen or modified by the creator of the event. */
   public var source: GoogleCloudCalendarEventSource?
   /*The (inclusive) start time of the event. For a recurring event, this is the start time of the first instance. */
   public var start:  GoogleCloudCalendarEventDateTime?
   /*Status of the event. Optional. Possible values are:  
- "confirmed" - The event is confirmed. This is the default status. 
- "tentative" - The event is tentatively confirmed. 
- "cancelled" - The event is cancelled (deleted). The list method returns cancelled events only on incremental sync (when syncToken or updatedMin are specified) or if the showDeleted flag is set to true. The get method always returns them.
A cancelled status represents two different states depending on the event type:  
- Cancelled exceptions of an uncancelled recurring event indicate that this instance should no longer be presented to the user. Clients should store these events for the lifetime of the parent recurring event.
Cancelled exceptions are only guaranteed to have values for the id, recurringEventId and originalStartTime fields populated. The other fields might be empty.  
- All other cancelled events represent deleted events. Clients should remove their locally synced copies. Such cancelled events will eventually disappear, so do not rely on them being available indefinitely.
Deleted events are only guaranteed to have the id field populated.   On the organizer's calendar, cancelled events continue to expose event details (summary, location, etc.) so that they can be restored (undeleted). Similarly, the events to which the user was invited and that they manually removed continue to provide details. However, incremental sync requests with showDeleted set to false will not return these details.
If an event changes its organizer (for example via the move operation) and the original organizer is not on the attendee list, it will leave behind a cancelled event where only the id field is guaranteed to be populated. */
   public var status: String?
   /*Title of the event. */
   public var summary: String?
   /*Whether the event blocks time on the calendar. Optional. Possible values are:  
- "opaque" - Default value. The event does block time on the calendar. This is equivalent to setting Show me as to Busy in the Calendar UI. 
- "transparent" - The event does not block time on the calendar. This is equivalent to setting Show me as to Available in the Calendar UI. */
   public var transparency: String?
   /*Last modification time of the event (as a RFC3339 timestamp). Read-only. */
   public var updated: String?
   /*Visibility of the event. Optional. Possible values are:  
- "default" - Uses the default visibility for events on the calendar. This is the default value. 
- "public" - The event is public and event details are visible to all readers of the calendar. 
- "private" - The event is private and only event attendees may view event details. 
- "confidential" - The event is private. This value is provided for compatibility reasons. */
   public var visibility: String?
}
public struct GoogleCloudCalendarEventAttachment : GoogleCloudModel {
   /*ID of the attached file. Read-only.
For Google Drive files, this is the ID of the corresponding Files resource entry in the Drive API. */
   public var fileId: String?
   /*URL link to the attachment.
For adding Google Drive file attachments use the same format as in alternateLink property of the Files resource in the Drive API.
Required when adding an attachment. */
   public var fileUrl: String?
   /*URL link to the attachment's icon. Read-only. */
   public var iconLink: String?
   /*Internet media type (MIME type) of the attachment. */
   public var mimeType: String?
   /*Attachment title. */
   public var title: String?
}
public struct GoogleCloudCalendarEventAttendee : GoogleCloudModel {
   /*Number of additional guests. Optional. The default is 0. */
   public var additionalGuests: Int?
   /*The attendee's response comment. Optional. */
   public var comment: String?
   /*The attendee's name, if available. Optional. */
   public var displayName: String?
   /*The attendee's email address, if available. This field must be present when adding an attendee. It must be a valid email address as per RFC5322.
Required when adding an attendee. */
   public var email: String?
   /*The attendee's Profile ID, if available. It corresponds to the id field in the People collection of the Google+ API */
   public var id: String?
   /*Whether this is an optional attendee. Optional. The default is False. */
   public var optional: Bool?
   /*Whether the attendee is the organizer of the event. Read-only. The default is False. */
   public var organizer: Bool?
   /*Whether the attendee is a resource. Can only be set when the attendee is added to the event for the first time. Subsequent modifications are ignored. Optional. The default is False. */
   public var resource: Bool?
   /*The attendee's response status. Possible values are:  
- "needsAction" - The attendee has not responded to the invitation. 
- "declined" - The attendee has declined the invitation. 
- "tentative" - The attendee has tentatively accepted the invitation. 
- "accepted" - The attendee has accepted the invitation. */
   public var responseStatus: String?
   /*Whether this entry represents the calendar on which this copy of the event appears. Read-only. The default is False. */
   public var `self`: Bool?
}
public struct GoogleCloudCalendarEventDateTime : GoogleCloudModel {
   /*The date, in the format "yyyy-mm-dd", if this is an all-day event. */
   public var date: String?
   /*The time, as a combined date-time value (formatted according to RFC3339). A time zone offset is required unless a time zone is explicitly specified in timeZone. */
   public var dateTime: String?
   /*The time zone in which the time is specified. (Formatted as an IANA Time Zone Database name, e.g. "Europe/Zurich".) For recurring events this field is required and specifies the time zone in which the recurrence is expanded. For single events this field is optional and indicates a custom time zone for the event start/end. */
   public var timeZone: String?
}
public struct GoogleCloudCalendarEventReminder : GoogleCloudModel {
   /*The method used by this reminder. Possible values are:  
- "email" - Reminders are sent via email. 
- "sms" - Deprecated. Once this feature is shutdown, the API will no longer return reminders using this method. Any newly added SMS reminders will be ignored. See  Google Calendar SMS notifications to be removed for more information.
Reminders are sent via SMS. These are only available for G Suite customers. Requests to set SMS reminders for other account types are ignored. 
- "popup" - Reminders are sent via a UI popup.  
Required when adding a reminder. */
   public var method: String?
   /*Number of minutes before the start of the event when the reminder should trigger. Valid values are between 0 and 40320 (4 weeks in minutes).
Required when adding a reminder. */
   public var minutes: Int?
}
public struct GoogleCloudCalendarEvents : GoogleCloudModel {
   /*The user's access role for this calendar. Read-only. Possible values are:  
- "none" - The user has no access. 
- "freeBusyReader" - The user has read access to free/busy information. 
- "reader" - The user has read access to the calendar. Private events will appear to users with reader access, but event details will be hidden. 
- "writer" - The user has read and write access to the calendar. Private events will appear to users with writer access, and event details will be visible. 
- "owner" - The user has ownership of the calendar. This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs. */
   public var accessRole: String?
   /*The default reminders on the calendar for the authenticated user. These reminders apply to all events on this calendar that do not explicitly override them (i.e. do not have reminders.useDefault set to True). */
   public var defaultReminders: [GoogleCloudCalendarEventReminder]?
   /*Description of the calendar. Read-only. */
   public var description: String?
   /*ETag of the collection. */
   public var etag: String?
   /*List of events on the calendar. */
   public var items: [GoogleCloudCalendarEvent]?
   /*Type of the collection ("calendar#events"). */
   public var kind: String?
   /*Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided. */
   public var nextPageToken: String?
   /*Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided. */
   public var nextSyncToken: String?
   /*Title of the calendar. Read-only. */
   public var summary: String?
   /*The time zone of the calendar. Read-only. */
   public var timeZone: String?
   /*Last modification time of the calendar (as a RFC3339 timestamp). Read-only. */
   public var updated: String?
}
public struct GoogleCloudCalendarFreeBusyCalendar : GoogleCloudModel {
   /*List of time ranges during which this calendar should be regarded as busy. */
   public var busy: [GoogleCloudCalendarTimePeriod]?
   /*Optional error(s) (if computation for the calendar failed). */
   public var errors: [GoogleCloudCalendarError]?
}
public struct GoogleCloudCalendarFreeBusyGroup : GoogleCloudModel {
   /*List of calendars' identifiers within a group. */
   public var calendars: [String]?
   /*Optional error(s) (if computation for the group failed). */
   public var errors: [GoogleCloudCalendarError]?
}
public struct GoogleCloudCalendarFreeBusyRequest : GoogleCloudModel {
   /*Maximal number of calendars for which FreeBusy information is to be provided. Optional. Maximum value is 50. */
   public var calendarExpansionMax: Int?
   /*Maximal number of calendar identifiers to be provided for a single group. Optional. An error is returned for a group with more members than this value. Maximum value is 100. */
   public var groupExpansionMax: Int?
   /*List of calendars and/or groups to query. */
   public var items: [GoogleCloudCalendarFreeBusyRequestItem]?
   /*The end of the interval for the query formatted as per RFC3339. */
   public var timeMax: String?
   /*The start of the interval for the query formatted as per RFC3339. */
   public var timeMin: String?
   /*Time zone used in the response. Optional. The default is UTC. */
   public var timeZone: String?
}
public struct GoogleCloudCalendarFreeBusyRequestItem : GoogleCloudModel {
   /*The identifier of a calendar or a group. */
   public var id: String?
}
public struct GoogleCloudCalendarFreeBusyResponse : GoogleCloudModel {
   /*List of free/busy information for calendars. */
   public var calendars: [String : GoogleCloudCalendarFreeBusyCalendar]?
   /*Expansion of groups. */
   public var groups: [String : GoogleCloudCalendarFreeBusyGroup]?
   /*Type of the resource ("calendar#freeBusy"). */
   public var kind: String?
   /*The end of the interval. */
   public var timeMax: String?
   /*The start of the interval. */
   public var timeMin: String?
}
public struct GoogleCloudCalendarSetting : GoogleCloudModel {
   /*ETag of the resource. */
   public var etag: String?
   /*The id of the user setting. */
   public var id: String?
   /*Type of the resource ("calendar#setting"). */
   public var kind: String?
   /*Value of the user setting. The format of the value depends on the ID of the setting. It must always be a UTF-8 string of length up to 1024 characters. */
   public var value: String?
}
public struct GoogleCloudCalendarSettings : GoogleCloudModel {
   /*Etag of the collection. */
   public var etag: String?
   /*List of user settings. */
   public var items: [GoogleCloudCalendarSetting]?
   /*Type of the collection ("calendar#settings"). */
   public var kind: String?
   /*Token used to access the next page of this result. Omitted if no further results are available, in which case nextSyncToken is provided. */
   public var nextPageToken: String?
   /*Token used at a later point in time to retrieve only the entries that have changed since this result was returned. Omitted if further results are available, in which case nextPageToken is provided. */
   public var nextSyncToken: String?
}
public struct GoogleCloudCalendarTimePeriod : GoogleCloudModel {
   /*The (exclusive) end of the time period. */
   public var end: String?
   /*The (inclusive) start of the time period. */
   public var start: String?
}
public struct GoogleCloudCalendarAclRuleScope : GoogleCloudModel {
   /*The type of the scope. Possible values are:  
- "default" - The public scope. This is the default value. 
- "user" - Limits the scope to a single user. 
- "group" - Limits the scope to a group. 
- "domain" - Limits the scope to a domain.  Note: The permissions granted to the "default", or public, scope apply to any user, authenticated or not. */
   public var type: String?
   /*The email address of a user or group, or the name of a domain, depending on the scope type. Omitted for type "default". */
   public var value: String?
}
public struct GoogleCloudCalendarCalendarListEntryNotificationSettings : GoogleCloudModel {
   /*The list of notifications set for this calendar. */
   public var notifications: [GoogleCloudCalendarCalendarNotification]?
}
public struct GoogleCloudCalendarEventCreator : GoogleCloudModel {
   /*The creator's name, if available. */
   public var displayName: String?
   /*The creator's email address, if available. */
   public var email: String?
   /*The creator's Profile ID, if available. It corresponds to the id field in the People collection of the Google+ API */
   public var id: String?
   /*Whether the creator corresponds to the calendar on which this copy of the event appears. Read-only. The default is False. */
   public var `self`: Bool?
}
public struct GoogleCloudCalendarEventExtendedProperties : GoogleCloudModel {
   /*Properties that are private to the copy of the event that appears on this calendar. */
   public var `private`: [String :String]?
   /*Properties that are shared between copies of the event on other attendees' calendars. */
   public var shared: [String :String]?
}
public struct GoogleCloudCalendarEventGadget : GoogleCloudModel {
   /*The gadget's display mode. Optional. Possible values are:  
- "icon" - The gadget displays next to the event's title in the calendar view. 
- "chip" - The gadget displays when the event is clicked. */
   public var display: String?
   /*The gadget's height in pixels. The height must be an integer greater than 0. Optional. */
   public var height: Int?
   /*The gadget's icon URL. The URL scheme must be HTTPS. */
   public var iconLink: String?
   /*The gadget's URL. The URL scheme must be HTTPS. */
   public var link: String?
   /*Preferences. */
   public var preferences: [String :String]?
   /*The gadget's title. */
   public var title: String?
   /*The gadget's type. */
   public var type: String?
   /*The gadget's width in pixels. The width must be an integer greater than 0. Optional. */
   public var width: Int?
}
public struct GoogleCloudCalendarEventOrganizer : GoogleCloudModel {
   /*The organizer's name, if available. */
   public var displayName: String?
   /*The organizer's email address, if available. It must be a valid email address as per RFC5322. */
   public var email: String?
   /*The organizer's Profile ID, if available. It corresponds to the id field in the People collection of the Google+ API */
   public var id: String?
   /*Whether the organizer corresponds to the calendar on which this copy of the event appears. Read-only. The default is False. */
   public var `self`: Bool?
}
public struct GoogleCloudCalendarEventReminders : GoogleCloudModel {
   /*If the event doesn't use the default reminders, this lists the reminders specific to the event, or, if not set, indicates that no reminders are set for this event. The maximum number of override reminders is 5. */
   public var overrides: [GoogleCloudCalendarEventReminder]?
   /*Whether the default reminders of the calendar apply to the event. */
   public var useDefault: Bool?
}
public struct GoogleCloudCalendarEventSource : GoogleCloudModel {
   /*Title of the source; for example a title of a web page or an email subject. */
   public var title: String?
   /*URL of the source pointing to a resource. The URL scheme must be HTTP or HTTPS. */
   public var url: String?
}
public final class GoogleCloudCalendarClient {
   public var acl : CalendarAclAPIProtocol
   public var calendarList : CalendarCalendarListAPIProtocol
   public var calendars : CalendarCalendarsAPIProtocol
   public var channels : CalendarChannelsAPIProtocol
   public var colors : CalendarColorsAPIProtocol
   public var events : CalendarEventsAPIProtocol
   public var freebusy : CalendarFreebusyAPIProtocol
   public var settings : CalendarSettingsAPIProtocol


   public init(credentials: GoogleCloudCredentialsConfiguration, calendarConfig: GoogleCloudCalendarConfiguration, httpClient: HTTPClient, eventLoop: EventLoop) throws {
      let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: calendarConfig, andClient: httpClient, eventLoop: eventLoop)
      guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
               (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
               calendarConfig.project ?? credentials.project else {
         throw GoogleCloudInternalError.projectIdMissing
      }

      let request = GoogleCloudCalendarRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)


      acl = GoogleCloudCalendarAclAPI(request: request)
      calendarList = GoogleCloudCalendarCalendarListAPI(request: request)
      calendars = GoogleCloudCalendarCalendarsAPI(request: request)
      channels = GoogleCloudCalendarChannelsAPI(request: request)
      colors = GoogleCloudCalendarColorsAPI(request: request)
      events = GoogleCloudCalendarEventsAPI(request: request)
      freebusy = GoogleCloudCalendarFreebusyAPI(request: request)
      settings = GoogleCloudCalendarSettingsAPI(request: request)
   }
}

