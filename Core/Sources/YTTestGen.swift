// This is Generated Code


import Foundation
import AsyncHTTPClient
import NIO
import Core
import NIOFoundationCompat
import NIOHTTP1
import CodableWrappers


public enum GoogleCloudYoutubeScope : GoogleCloudAPIScope {
   public var value : String {
      switch self {
      case .YoutubeReadonly: return "https://www.googleapis.com/auth/youtube.readonly"
      case .YoutubepartnerChannelAudit: return "https://www.googleapis.com/auth/youtubepartner-channel-audit"
      case .YoutubeUpload: return "https://www.googleapis.com/auth/youtube.upload"
      case .Youtubepartner: return "https://www.googleapis.com/auth/youtubepartner"
      case .Youtube: return "https://www.googleapis.com/auth/youtube"
      case .YoutubeForceSsl: return "https://www.googleapis.com/auth/youtube.force-ssl"
      }
   }

   case YoutubeReadonly // View your YouTube account
   case YoutubepartnerChannelAudit // View private information of your YouTube channel relevant during the audit process with a YouTube partner
   case YoutubeUpload // Manage your YouTube videos
   case Youtubepartner // View and manage your assets and associated content on YouTube
   case Youtube // Manage your YouTube account
   case YoutubeForceSsl // See, edit, and permanently delete your YouTube videos, ratings, comments and captions
}


public struct GoogleCloudYoutubeConfiguration : GoogleCloudAPIConfiguration {
   public var scope : [GoogleCloudAPIScope]
   public var serviceAccount: String
   public var project: String?
   public var subscription: String?

   public init(scope: [GoogleCloudYoutubeScope], serviceAccount : String, project: String?, subscription: String?) {
      self.scope = scope
      self.serviceAccount = serviceAccount
      self.project = project
      self.subscription = subscription
   }
}


public final class GoogleCloudYoutubeRequest : GoogleCloudAPIRequest {
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
public final class GoogleCloudYoutubeActivitiesAPI : YoutubeActivitiesAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)  Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.

   public func insert(part : String, body : GoogleCloudYoutubeActivity, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeActivity> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)activities", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.  If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeActivityListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)activities", query: queryParams)
   }
}

public protocol YoutubeActivitiesAPIProtocol  {
   /// Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)  Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
   func insert(part : String, body : GoogleCloudYoutubeActivity, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeActivity>
   /// Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeActivityListResponse>
}
extension YoutubeActivitiesAPIProtocol   {
      public func insert(part : String, body : GoogleCloudYoutubeActivity, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeActivity> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeActivityListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeCaptionsAPI : YoutubeCaptionsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a specified caption track.
   /// - Parameter id: The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)captions", query: queryParams)
   }
   /// Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
   /// - Parameter id: The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.

   public func download(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)captions/\(id)", query: queryParams)
   }
   /// Uploads a caption track.
   /// - Parameter part: The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.

   public func insert(part : String, body : GoogleCloudYoutubeCaption, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCaption> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)captions", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
/// - Parameter videoId: The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.

   public func list(part : String, videoId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCaptionListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)captions", query: queryParams)
   }
   /// Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.

   public func update(part : String, body : GoogleCloudYoutubeCaption, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCaption> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)captions", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeCaptionsAPIProtocol  {
   /// Deletes a specified caption track.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
   func download(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Uploads a caption track.
   func insert(part : String, body : GoogleCloudYoutubeCaption, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCaption>
   /// Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
   func list(part : String, videoId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCaptionListResponse>
   /// Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
   func update(part : String, body : GoogleCloudYoutubeCaption, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCaption>
}
extension YoutubeCaptionsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func download(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      download(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeCaption, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeCaption> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String, videoId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeCaptionListResponse> {
      list(part: part,videoId: videoId,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeCaption, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeCaption> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeChannelBannersAPI : YoutubeChannelBannersAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:  - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels. - Extract the url property's value from the response that the API returns for step 1. - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
   
   public func insert(body : GoogleCloudYoutubeChannelBannerResource, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelBannerResource> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)channelBanners/insert", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeChannelBannersAPIProtocol  {
   /// Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:  - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels. - Extract the url property's value from the response that the API returns for step 1. - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
   func insert(body : GoogleCloudYoutubeChannelBannerResource, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelBannerResource>
}
extension YoutubeChannelBannersAPIProtocol   {
      public func insert(body : GoogleCloudYoutubeChannelBannerResource, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeChannelBannerResource> {
      insert( body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeChannelSectionsAPI : YoutubeChannelSectionsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a channelSection.
   /// - Parameter id: The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)channelSections", query: queryParams)
   }
   /// Adds a channelSection for the authenticated user's channel.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  The part names that you can include in the parameter value are snippet and contentDetails.

   public func insert(part : String, body : GoogleCloudYoutubeChannelSection, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelSection> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)channelSections", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns channelSection resources that match the API request criteria.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.  If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelSectionListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)channelSections", query: queryParams)
   }
   /// Update a channelSection.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  The part names that you can include in the parameter value are snippet and contentDetails.

   public func update(part : String, body : GoogleCloudYoutubeChannelSection, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelSection> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)channelSections", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeChannelSectionsAPIProtocol  {
   /// Deletes a channelSection.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Adds a channelSection for the authenticated user's channel.
   func insert(part : String, body : GoogleCloudYoutubeChannelSection, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelSection>
   /// Returns channelSection resources that match the API request criteria.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelSectionListResponse>
   /// Update a channelSection.
   func update(part : String, body : GoogleCloudYoutubeChannelSection, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelSection>
}
extension YoutubeChannelSectionsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeChannelSection, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeChannelSection> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeChannelSectionListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeChannelSection, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeChannelSection> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeChannelsAPI : YoutubeChannelsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Returns a collection of zero or more channel resources that match the request criteria.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.  If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)channels", query: queryParams)
   }
   /// Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)  Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.

   public func update(part : String, body : GoogleCloudYoutubeChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannel> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)channels", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeChannelsAPIProtocol  {
   /// Returns a collection of zero or more channel resources that match the request criteria.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannelListResponse>
   /// Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
   func update(part : String, body : GoogleCloudYoutubeChannel, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeChannel>
}
extension YoutubeChannelsAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeChannelListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeChannel, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeChannel> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeCommentThreadsAPI : YoutubeCommentThreadsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
   /// - Parameter part: The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.

   public func insert(part : String, body : GoogleCloudYoutubeCommentThread, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentThread> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)commentThreads", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a list of comment threads that match the API request parameters.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentThreadListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)commentThreads", query: queryParams)
   }
   /// Modifies the top-level comment in a comment thread.
   /// - Parameter part: The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.

   public func update(part : String, body : GoogleCloudYoutubeCommentThread, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentThread> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)commentThreads", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeCommentThreadsAPIProtocol  {
   /// Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
   func insert(part : String, body : GoogleCloudYoutubeCommentThread, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentThread>
   /// Returns a list of comment threads that match the API request parameters.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentThreadListResponse>
   /// Modifies the top-level comment in a comment thread.
   func update(part : String, body : GoogleCloudYoutubeCommentThread, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentThread>
}
extension YoutubeCommentThreadsAPIProtocol   {
      public func insert(part : String, body : GoogleCloudYoutubeCommentThread, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeCommentThread> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeCommentThreadListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeCommentThread, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeCommentThread> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeCommentsAPI : YoutubeCommentsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a comment.
   /// - Parameter id: The id parameter specifies the comment ID for the resource that is being deleted.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)comments", query: queryParams)
   }
   /// Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
   /// - Parameter part: The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.

   public func insert(part : String, body : GoogleCloudYoutubeComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeComment> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)comments", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a list of comments that match the API request parameters.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)comments", query: queryParams)
   }
   /// Expresses the caller's opinion that one or more comments should be flagged as spam.
   /// - Parameter id: The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.

   public func markAsSpam(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)comments/markAsSpam", query: queryParams)
   }
   /// Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
   /// - Parameter id: The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
/// - Parameter moderationStatus: Identifies the new moderation status of the specified comments.

   public func setModerationStatus(id : String, moderationStatus : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)comments/setModerationStatus", query: queryParams)
   }
   /// Modifies a comment.
   /// - Parameter part: The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.

   public func update(part : String, body : GoogleCloudYoutubeComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeComment> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)comments", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeCommentsAPIProtocol  {
   /// Deletes a comment.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
   func insert(part : String, body : GoogleCloudYoutubeComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeComment>
   /// Returns a list of comments that match the API request parameters.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeCommentListResponse>
   /// Expresses the caller's opinion that one or more comments should be flagged as spam.
   func markAsSpam(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
   func setModerationStatus(id : String, moderationStatus : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Modifies a comment.
   func update(part : String, body : GoogleCloudYoutubeComment, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeComment>
}
extension YoutubeCommentsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeComment, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeComment> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeCommentListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func markAsSpam(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      markAsSpam(id: id,  queryParameters: queryParameters)
   }

      public func setModerationStatus(id : String, moderationStatus : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      setModerationStatus(id: id,moderationStatus: moderationStatus,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeComment, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeComment> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeGuideCategoriesAPI : YoutubeGuideCategoriesAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Returns a list of categories that can be associated with YouTube channels.
   /// - Parameter part: The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeGuideCategoryListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)guideCategories", query: queryParams)
   }
}

public protocol YoutubeGuideCategoriesAPIProtocol  {
   /// Returns a list of categories that can be associated with YouTube channels.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeGuideCategoryListResponse>
}
extension YoutubeGuideCategoriesAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeGuideCategoryListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeI18nLanguagesAPI : YoutubeI18nLanguagesAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Returns a list of application languages that the YouTube website supports.
   /// - Parameter part: The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeI18nLanguageListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)i18nLanguages", query: queryParams)
   }
}

public protocol YoutubeI18nLanguagesAPIProtocol  {
   /// Returns a list of application languages that the YouTube website supports.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeI18nLanguageListResponse>
}
extension YoutubeI18nLanguagesAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeI18nLanguageListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeI18nRegionsAPI : YoutubeI18nRegionsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Returns a list of content regions that the YouTube website supports.
   /// - Parameter part: The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeI18nRegionListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)i18nRegions", query: queryParams)
   }
}

public protocol YoutubeI18nRegionsAPIProtocol  {
   /// Returns a list of content regions that the YouTube website supports.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeI18nRegionListResponse>
}
extension YoutubeI18nRegionsAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeI18nRegionListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeLiveBroadcastsAPI : YoutubeLiveBroadcastsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
   /// - Parameter id: The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
/// - Parameter part: The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.

   public func bind(id : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)liveBroadcasts/bind", query: queryParams)
   }
   /// Controls the settings for a slate that can be displayed in the broadcast stream.
   /// - Parameter id: The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
/// - Parameter part: The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.

   public func control(id : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)liveBroadcasts/control", query: queryParams)
   }
   /// Deletes a broadcast.
   /// - Parameter id: The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)liveBroadcasts", query: queryParams)
   }
   /// Creates a broadcast.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.

   public func insert(part : String, body : GoogleCloudYoutubeLiveBroadcast, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)liveBroadcasts", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a list of YouTube broadcasts that match the API request parameters.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcastListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)liveBroadcasts", query: queryParams)
   }
   /// Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
   /// - Parameter broadcastStatus: The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
/// - Parameter id: The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
/// - Parameter part: The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.

   public func transition(broadcastStatus : String, id : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)liveBroadcasts/transition", query: queryParams)
   }
   /// Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.  Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.

   public func update(part : String, body : GoogleCloudYoutubeLiveBroadcast, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)liveBroadcasts", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeLiveBroadcastsAPIProtocol  {
   /// Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
   func bind(id : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast>
   /// Controls the settings for a slate that can be displayed in the broadcast stream.
   func control(id : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast>
   /// Deletes a broadcast.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Creates a broadcast.
   func insert(part : String, body : GoogleCloudYoutubeLiveBroadcast, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast>
   /// Returns a list of YouTube broadcasts that match the API request parameters.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcastListResponse>
   /// Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
   func transition(broadcastStatus : String, id : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast>
   /// Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
   func update(part : String, body : GoogleCloudYoutubeLiveBroadcast, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast>
}
extension YoutubeLiveBroadcastsAPIProtocol   {
      public func bind(id : String, part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      bind(id: id,part: part,  queryParameters: queryParameters)
   }

      public func control(id : String, part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      control(id: id,part: part,  queryParameters: queryParameters)
   }

      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeLiveBroadcast, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcastListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func transition(broadcastStatus : String, id : String, part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      transition(broadcastStatus: broadcastStatus,id: id,part: part,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeLiveBroadcast, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveBroadcast> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeLiveChatBansAPI : YoutubeLiveChatBansAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Removes a chat ban.
   /// - Parameter id: The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)liveChat/bans", query: queryParams)
   }
   /// Adds a new ban to the chat.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.

   public func insert(part : String, body : GoogleCloudYoutubeLiveChatBan, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatBan> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)liveChat/bans", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeLiveChatBansAPIProtocol  {
   /// Removes a chat ban.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Adds a new ban to the chat.
   func insert(part : String, body : GoogleCloudYoutubeLiveChatBan, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatBan>
}
extension YoutubeLiveChatBansAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeLiveChatBan, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveChatBan> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeLiveChatMessagesAPI : YoutubeLiveChatMessagesAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a chat message.
   /// - Parameter id: The id parameter specifies the YouTube chat message ID of the resource that is being deleted.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)liveChat/messages", query: queryParams)
   }
   /// Adds a message to a live chat.
   /// - Parameter part: The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.

   public func insert(part : String, body : GoogleCloudYoutubeLiveChatMessage, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatMessage> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)liveChat/messages", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Lists live chat messages for a specific chat.
   /// - Parameter liveChatId: The liveChatId parameter specifies the ID of the chat whose messages will be returned.
/// - Parameter part: The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.

   public func list(liveChatId : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatMessageListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)liveChat/messages", query: queryParams)
   }
}

public protocol YoutubeLiveChatMessagesAPIProtocol  {
   /// Deletes a chat message.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Adds a message to a live chat.
   func insert(part : String, body : GoogleCloudYoutubeLiveChatMessage, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatMessage>
   /// Lists live chat messages for a specific chat.
   func list(liveChatId : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatMessageListResponse>
}
extension YoutubeLiveChatMessagesAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeLiveChatMessage, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveChatMessage> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(liveChatId : String, part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveChatMessageListResponse> {
      list(liveChatId: liveChatId,part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeLiveChatModeratorsAPI : YoutubeLiveChatModeratorsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Removes a chat moderator.
   /// - Parameter id: The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)liveChat/moderators", query: queryParams)
   }
   /// Adds a new moderator for the chat.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.

   public func insert(part : String, body : GoogleCloudYoutubeLiveChatModerator, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatModerator> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)liveChat/moderators", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Lists moderators for a live chat.
   /// - Parameter liveChatId: The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
/// - Parameter part: The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.

   public func list(liveChatId : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatModeratorListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)liveChat/moderators", query: queryParams)
   }
}

public protocol YoutubeLiveChatModeratorsAPIProtocol  {
   /// Removes a chat moderator.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Adds a new moderator for the chat.
   func insert(part : String, body : GoogleCloudYoutubeLiveChatModerator, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatModerator>
   /// Lists moderators for a live chat.
   func list(liveChatId : String, part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveChatModeratorListResponse>
}
extension YoutubeLiveChatModeratorsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeLiveChatModerator, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveChatModerator> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(liveChatId : String, part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveChatModeratorListResponse> {
      list(liveChatId: liveChatId,part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeLiveStreamsAPI : YoutubeLiveStreamsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a video stream.
   /// - Parameter id: The id parameter specifies the YouTube live stream ID for the resource that is being deleted.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)liveStreams", query: queryParams)
   }
   /// Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  The part properties that you can include in the parameter value are id, snippet, cdn, and status.

   public func insert(part : String, body : GoogleCloudYoutubeLiveStream, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveStream> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)liveStreams", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a list of video streams that match the API request parameters.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveStreamListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)liveStreams", query: queryParams)
   }
   /// Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  The part properties that you can include in the parameter value are id, snippet, cdn, and status.  Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.

   public func update(part : String, body : GoogleCloudYoutubeLiveStream, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveStream> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)liveStreams", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeLiveStreamsAPIProtocol  {
   /// Deletes a video stream.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
   func insert(part : String, body : GoogleCloudYoutubeLiveStream, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveStream>
   /// Returns a list of video streams that match the API request parameters.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveStreamListResponse>
   /// Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
   func update(part : String, body : GoogleCloudYoutubeLiveStream, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeLiveStream>
}
extension YoutubeLiveStreamsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeLiveStream, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveStream> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveStreamListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeLiveStream, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeLiveStream> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeMembersAPI : YoutubeMembersAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Lists members for a channel.
   /// - Parameter part: The part parameter specifies the member resource parts that the API response will include. Set the parameter value to snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeMemberListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)members", query: queryParams)
   }
}

public protocol YoutubeMembersAPIProtocol  {
   /// Lists members for a channel.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeMemberListResponse>
}
extension YoutubeMembersAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeMemberListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeMembershipsLevelsAPI : YoutubeMembershipsLevelsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Lists pricing levels for a channel.
   /// - Parameter part: The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeMembershipsLevelListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)membershipsLevels", query: queryParams)
   }
}

public protocol YoutubeMembershipsLevelsAPIProtocol  {
   /// Lists pricing levels for a channel.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeMembershipsLevelListResponse>
}
extension YoutubeMembershipsLevelsAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeMembershipsLevelListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubePlaylistItemsAPI : YoutubePlaylistItemsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a playlist item.
   /// - Parameter id: The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)playlistItems", query: queryParams)
   }
   /// Adds a resource to a playlist.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.

   public func insert(part : String, body : GoogleCloudYoutubePlaylistItem, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistItem> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)playlistItems", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.  If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistItemListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)playlistItems", query: queryParams)
   }
   /// Modifies a playlist item. For example, you could update the item's position in the playlist.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.

   public func update(part : String, body : GoogleCloudYoutubePlaylistItem, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistItem> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)playlistItems", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubePlaylistItemsAPIProtocol  {
   /// Deletes a playlist item.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Adds a resource to a playlist.
   func insert(part : String, body : GoogleCloudYoutubePlaylistItem, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistItem>
   /// Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistItemListResponse>
   /// Modifies a playlist item. For example, you could update the item's position in the playlist.
   func update(part : String, body : GoogleCloudYoutubePlaylistItem, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistItem>
}
extension YoutubePlaylistItemsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubePlaylistItem, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubePlaylistItem> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubePlaylistItemListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubePlaylistItem, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubePlaylistItem> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubePlaylistsAPI : YoutubePlaylistsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a playlist.
   /// - Parameter id: The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)playlists", query: queryParams)
   }
   /// Creates a playlist.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.

   public func insert(part : String, body : GoogleCloudYoutubePlaylist, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylist> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)playlists", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.  If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)playlists", query: queryParams)
   }
   /// Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.

   public func update(part : String, body : GoogleCloudYoutubePlaylist, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylist> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)playlists", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubePlaylistsAPIProtocol  {
   /// Deletes a playlist.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Creates a playlist.
   func insert(part : String, body : GoogleCloudYoutubePlaylist, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylist>
   /// Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylistListResponse>
   /// Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
   func update(part : String, body : GoogleCloudYoutubePlaylist, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubePlaylist>
}
extension YoutubePlaylistsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubePlaylist, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubePlaylist> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubePlaylistListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubePlaylist, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubePlaylist> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeSearchAPI : YoutubeSearchAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSearchListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)search", query: queryParams)
   }
}

public protocol YoutubeSearchAPIProtocol  {
   /// Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSearchListResponse>
}
extension YoutubeSearchAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeSearchListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeSponsorsAPI : YoutubeSponsorsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Lists sponsors for a channel.
   /// - Parameter part: The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSponsorListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)sponsors", query: queryParams)
   }
}

public protocol YoutubeSponsorsAPIProtocol  {
   /// Lists sponsors for a channel.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSponsorListResponse>
}
extension YoutubeSponsorsAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeSponsorListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeSubscriptionsAPI : YoutubeSubscriptionsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a subscription.
   /// - Parameter id: The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)subscriptions", query: queryParams)
   }
   /// Adds a subscription for the authenticated user's channel.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.

   public func insert(part : String, body : GoogleCloudYoutubeSubscription, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSubscription> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)subscriptions", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns subscription resources that match the API request criteria.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.  If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSubscriptionListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)subscriptions", query: queryParams)
   }
}

public protocol YoutubeSubscriptionsAPIProtocol  {
   /// Deletes a subscription.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Adds a subscription for the authenticated user's channel.
   func insert(part : String, body : GoogleCloudYoutubeSubscription, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSubscription>
   /// Returns subscription resources that match the API request criteria.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSubscriptionListResponse>
}
extension YoutubeSubscriptionsAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeSubscription, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeSubscription> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeSubscriptionListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeSuperChatEventsAPI : YoutubeSuperChatEventsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Lists Super Chat events for a channel.
   /// - Parameter part: The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSuperChatEventListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)superChatEvents", query: queryParams)
   }
}

public protocol YoutubeSuperChatEventsAPIProtocol  {
   /// Lists Super Chat events for a channel.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeSuperChatEventListResponse>
}
extension YoutubeSuperChatEventsAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeSuperChatEventListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeThumbnailsAPI : YoutubeThumbnailsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Uploads a custom video thumbnail to YouTube and sets it for a video.
   /// - Parameter videoId: The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.

   public func set(videoId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeThumbnailSetResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)thumbnails/set", query: queryParams)
   }
}

public protocol YoutubeThumbnailsAPIProtocol  {
   /// Uploads a custom video thumbnail to YouTube and sets it for a video.
   func set(videoId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeThumbnailSetResponse>
}
extension YoutubeThumbnailsAPIProtocol   {
      public func set(videoId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeThumbnailSetResponse> {
      set(videoId: videoId,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeVideoAbuseReportReasonsAPI : YoutubeVideoAbuseReportReasonsAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Returns a list of abuse reasons that can be used for reporting abusive videos.
   /// - Parameter part: The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoAbuseReportReasonListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)videoAbuseReportReasons", query: queryParams)
   }
}

public protocol YoutubeVideoAbuseReportReasonsAPIProtocol  {
   /// Returns a list of abuse reasons that can be used for reporting abusive videos.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoAbuseReportReasonListResponse>
}
extension YoutubeVideoAbuseReportReasonsAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeVideoAbuseReportReasonListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeVideoCategoriesAPI : YoutubeVideoCategoriesAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Returns a list of categories that can be associated with YouTube videos.
   /// - Parameter part: The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoCategoryListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)videoCategories", query: queryParams)
   }
}

public protocol YoutubeVideoCategoriesAPIProtocol  {
   /// Returns a list of categories that can be associated with YouTube videos.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoCategoryListResponse>
}
extension YoutubeVideoCategoriesAPIProtocol   {
      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeVideoCategoryListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeVideosAPI : YoutubeVideosAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Deletes a YouTube video.
   /// - Parameter id: The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.

   public func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .DELETE, path: "\(endpoint)videos", query: queryParams)
   }
   /// Retrieves the ratings that the authorized user gave to a list of specified videos.
   /// - Parameter id: The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.

   public func getRating(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoGetRatingResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)videos/getRating", query: queryParams)
   }
   /// Uploads a video to YouTube and optionally sets the video's metadata.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.

   public func insert(part : String, body : GoogleCloudYoutubeVideo, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideo> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)videos", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Returns a list of videos that match the API request parameters.
   /// - Parameter part: The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.  If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.

   public func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoListResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .GET, path: "\(endpoint)videos", query: queryParams)
   }
   /// Add a like or dislike rating to a video or remove a rating from a video.
   /// - Parameter id: The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
/// - Parameter rating: Specifies the rating to record.

   public func rate(id : String, rating : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)videos/rate", query: queryParams)
   }
   /// Report abuse for a video.
   
   public func reportAbuse(body : GoogleCloudYoutubeVideoAbuseReport, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)videos/reportAbuse", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Updates a video's metadata.
   /// - Parameter part: The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.  Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.  In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.

   public func update(part : String, body : GoogleCloudYoutubeVideo, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideo> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .PUT, path: "\(endpoint)videos", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
}

public protocol YoutubeVideosAPIProtocol  {
   /// Deletes a YouTube video.
   func delete(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Retrieves the ratings that the authorized user gave to a list of specified videos.
   func getRating(id : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoGetRatingResponse>
   /// Uploads a video to YouTube and optionally sets the video's metadata.
   func insert(part : String, body : GoogleCloudYoutubeVideo, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideo>
   /// Returns a list of videos that match the API request parameters.
   func list(part : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideoListResponse>
   /// Add a like or dislike rating to a video or remove a rating from a video.
   func rate(id : String, rating : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Report abuse for a video.
   func reportAbuse(body : GoogleCloudYoutubeVideoAbuseReport, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Updates a video's metadata.
   func update(part : String, body : GoogleCloudYoutubeVideo, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeVideo>
}
extension YoutubeVideosAPIProtocol   {
      public func delete(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      delete(id: id,  queryParameters: queryParameters)
   }

      public func getRating(id : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeVideoGetRatingResponse> {
      getRating(id: id,  queryParameters: queryParameters)
   }

      public func insert(part : String, body : GoogleCloudYoutubeVideo, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeVideo> {
      insert(part: part, body: body, queryParameters: queryParameters)
   }

      public func list(part : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeVideoListResponse> {
      list(part: part,  queryParameters: queryParameters)
   }

      public func rate(id : String, rating : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      rate(id: id,rating: rating,  queryParameters: queryParameters)
   }

      public func reportAbuse(body : GoogleCloudYoutubeVideoAbuseReport, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      reportAbuse( body: body, queryParameters: queryParameters)
   }

      public func update(part : String, body : GoogleCloudYoutubeVideo, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeVideo> {
      update(part: part, body: body, queryParameters: queryParameters)
   }

}
public final class GoogleCloudYoutubeWatermarksAPI : YoutubeWatermarksAPIProtocol {
   let endpoint = "https://www.googleapis.com/youtube/v3/"
   let request : GoogleCloudYoutubeRequest

   init(request: GoogleCloudYoutubeRequest) {
      self.request = request
   }

   /// Uploads a watermark image to YouTube and sets it for a channel.
   /// - Parameter channelId: The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.

   public func set(channelId : String, body : GoogleCloudYoutubeInvideoBranding, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      do {
         let data = try JSONEncoder().encode(body)
         return request.send(method: .POST, path: "\(endpoint)watermarks/set", query: queryParams, body: .data(data))
      } catch {
         return request.httpClient.eventLoopGroup.next().makeFailedFuture(error)
   }
   }
   /// Deletes a channel's watermark image.
   /// - Parameter channelId: The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.

   public func unset(channelId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      var queryParams = ""
      if let queryParameters = queryParameters {
         queryParams = queryParameters.queryParameters
      }
      return request.send(method: .POST, path: "\(endpoint)watermarks/unset", query: queryParams)
   }
}

public protocol YoutubeWatermarksAPIProtocol  {
   /// Uploads a watermark image to YouTube and sets it for a channel.
   func set(channelId : String, body : GoogleCloudYoutubeInvideoBranding, queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
   /// Deletes a channel's watermark image.
   func unset(channelId : String,  queryParameters: [String: String]?) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse>
}
extension YoutubeWatermarksAPIProtocol   {
      public func set(channelId : String, body : GoogleCloudYoutubeInvideoBranding, queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      set(channelId: channelId, body: body, queryParameters: queryParameters)
   }

      public func unset(channelId : String,  queryParameters: [String: String]? = nil) -> EventLoopFuture<GoogleCloudYoutubeEmptyResponse> {
      unset(channelId: channelId,  queryParameters: queryParameters)
   }

}
public struct GoogleCloudYoutubeEmptyResponse : GoogleCloudModel {}
public struct GoogleCloudYoutubeAccessPolicy : GoogleCloudModel {
   /*The value of allowed indicates whether the access to the policy is allowed or denied by default. */
   public var allowed: Bool?
   /*A list of region codes that identify countries where the default policy do not apply. */
   public var exception: [String]?
   public init(allowed:Bool?, exception:[String]?) {
      self.allowed = allowed
      self.exception = exception
   }
}
public struct GoogleCloudYoutubeActivity : GoogleCloudModel {
   /*The contentDetails object contains information about the content associated with the activity. For example, if the snippet.type value is videoRated, then the contentDetails object's content identifies the rated video. */
   public var contentDetails: GoogleCloudYoutubeActivityContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the activity. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#activity". */
   public var kind: String?
   /*The snippet object contains basic details about the activity, including the activity's type and group ID. */
   public var snippet: GoogleCloudYoutubeActivitySnippet?
   public init(contentDetails:GoogleCloudYoutubeActivityContentDetails?, etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeActivitySnippet?) {
      self.contentDetails = contentDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeActivityContentDetails : GoogleCloudModel {
   /*The bulletin object contains details about a channel bulletin post. This object is only present if the snippet.type is bulletin. */
   public var bulletin: GoogleCloudYoutubeActivityContentDetailsBulletin?
   /*The channelItem object contains details about a resource which was added to a channel. This property is only present if the snippet.type is channelItem. */
   public var channelItem: GoogleCloudYoutubeActivityContentDetailsChannelItem?
   /*The comment object contains information about a resource that received a comment. This property is only present if the snippet.type is comment. */
   public var comment: GoogleCloudYoutubeActivityContentDetailsComment?
   /*The favorite object contains information about a video that was marked as a favorite video. This property is only present if the snippet.type is favorite. */
   public var favorite: GoogleCloudYoutubeActivityContentDetailsFavorite?
   /*The like object contains information about a resource that received a positive (like) rating. This property is only present if the snippet.type is like. */
   public var like: GoogleCloudYoutubeActivityContentDetailsLike?
   /*The playlistItem object contains information about a new playlist item. This property is only present if the snippet.type is playlistItem. */
   public var playlistItem: GoogleCloudYoutubeActivityContentDetailsPlaylistItem?
   /*The promotedItem object contains details about a resource which is being promoted. This property is only present if the snippet.type is promotedItem. */
   public var promotedItem: GoogleCloudYoutubeActivityContentDetailsPromotedItem?
   /*The recommendation object contains information about a recommended resource. This property is only present if the snippet.type is recommendation. */
   public var recommendation: GoogleCloudYoutubeActivityContentDetailsRecommendation?
   /*The social object contains details about a social network post. This property is only present if the snippet.type is social. */
   public var social: GoogleCloudYoutubeActivityContentDetailsSocial?
   /*The subscription object contains information about a channel that a user subscribed to. This property is only present if the snippet.type is subscription. */
   public var subscription: GoogleCloudYoutubeActivityContentDetailsSubscription?
   /*The upload object contains information about the uploaded video. This property is only present if the snippet.type is upload. */
   public var upload: GoogleCloudYoutubeActivityContentDetailsUpload?
   public init(bulletin:GoogleCloudYoutubeActivityContentDetailsBulletin?, channelItem:GoogleCloudYoutubeActivityContentDetailsChannelItem?, comment:GoogleCloudYoutubeActivityContentDetailsComment?, favorite:GoogleCloudYoutubeActivityContentDetailsFavorite?, like:GoogleCloudYoutubeActivityContentDetailsLike?, playlistItem:GoogleCloudYoutubeActivityContentDetailsPlaylistItem?, promotedItem:GoogleCloudYoutubeActivityContentDetailsPromotedItem?, recommendation:GoogleCloudYoutubeActivityContentDetailsRecommendation?, social:GoogleCloudYoutubeActivityContentDetailsSocial?, subscription:GoogleCloudYoutubeActivityContentDetailsSubscription?, upload:GoogleCloudYoutubeActivityContentDetailsUpload?) {
      self.bulletin = bulletin
      self.channelItem = channelItem
      self.comment = comment
      self.favorite = favorite
      self.like = like
      self.playlistItem = playlistItem
      self.promotedItem = promotedItem
      self.recommendation = recommendation
      self.social = social
      self.subscription = subscription
      self.upload = upload
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsBulletin : GoogleCloudModel {
   /*The resourceId object contains information that identifies the resource associated with a bulletin post. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   public init(resourceId:GoogleCloudYoutubeResourceId?) {
      self.resourceId = resourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsChannelItem : GoogleCloudModel {
   /*The resourceId object contains information that identifies the resource that was added to the channel. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   public init(resourceId:GoogleCloudYoutubeResourceId?) {
      self.resourceId = resourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsComment : GoogleCloudModel {
   /*The resourceId object contains information that identifies the resource associated with the comment. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   public init(resourceId:GoogleCloudYoutubeResourceId?) {
      self.resourceId = resourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsFavorite : GoogleCloudModel {
   /*The resourceId object contains information that identifies the resource that was marked as a favorite. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   public init(resourceId:GoogleCloudYoutubeResourceId?) {
      self.resourceId = resourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsLike : GoogleCloudModel {
   /*The resourceId object contains information that identifies the rated resource. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   public init(resourceId:GoogleCloudYoutubeResourceId?) {
      self.resourceId = resourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsPlaylistItem : GoogleCloudModel {
   /*The value that YouTube uses to uniquely identify the playlist. */
   public var playlistId: String?
   /*ID of the item within the playlist. */
   public var playlistItemId: String?
   /*The resourceId object contains information about the resource that was added to the playlist. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   public init(playlistId:String?, playlistItemId:String?, resourceId:GoogleCloudYoutubeResourceId?) {
      self.playlistId = playlistId
      self.playlistItemId = playlistItemId
      self.resourceId = resourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsPromotedItem : GoogleCloudModel {
   /*The URL the client should fetch to request a promoted item. */
   public var adTag: String?
   /*The URL the client should ping to indicate that the user clicked through on this promoted item. */
   public var clickTrackingUrl: String?
   /*The URL the client should ping to indicate that the user was shown this promoted item. */
   public var creativeViewUrl: String?
   /*The type of call-to-action, a message to the user indicating action that can be taken. */
   public var ctaType: String?
   /*The custom call-to-action button text. If specified, it will override the default button text for the cta_type. */
   public var customCtaButtonText: String?
   /*The text description to accompany the promoted item. */
   public var descriptionText: String?
   /*The URL the client should direct the user to, if the user chooses to visit the advertiser's website. */
   public var destinationUrl: String?
   /*The list of forecasting URLs. The client should ping all of these URLs when a promoted item is not available, to indicate that a promoted item could have been shown. */
   public var forecastingUrl: [String]?
   /*The list of impression URLs. The client should ping all of these URLs to indicate that the user was shown this promoted item. */
   public var impressionUrl: [String]?
   /*The ID that YouTube uses to uniquely identify the promoted video. */
   public var videoId: String?
   public init(adTag:String?, clickTrackingUrl:String?, creativeViewUrl:String?, ctaType:String?, customCtaButtonText:String?, descriptionText:String?, destinationUrl:String?, forecastingUrl:[String]?, impressionUrl:[String]?, videoId:String?) {
      self.adTag = adTag
      self.clickTrackingUrl = clickTrackingUrl
      self.creativeViewUrl = creativeViewUrl
      self.ctaType = ctaType
      self.customCtaButtonText = customCtaButtonText
      self.descriptionText = descriptionText
      self.destinationUrl = destinationUrl
      self.forecastingUrl = forecastingUrl
      self.impressionUrl = impressionUrl
      self.videoId = videoId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsRecommendation : GoogleCloudModel {
   /*The reason that the resource is recommended to the user. */
   public var reason: String?
   /*The resourceId object contains information that identifies the recommended resource. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   /*The seedResourceId object contains information about the resource that caused the recommendation. */
   public var seedResourceId: GoogleCloudYoutubeResourceId?
   public init(reason:String?, resourceId:GoogleCloudYoutubeResourceId?, seedResourceId:GoogleCloudYoutubeResourceId?) {
      self.reason = reason
      self.resourceId = resourceId
      self.seedResourceId = seedResourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsSocial : GoogleCloudModel {
   /*The author of the social network post. */
   public var author: String?
   /*An image of the post's author. */
   public var imageUrl: String?
   /*The URL of the social network post. */
   public var referenceUrl: String?
   /*The resourceId object encapsulates information that identifies the resource associated with a social network post. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   /*The name of the social network. */
   public var type: String?
   public init(author:String?, imageUrl:String?, referenceUrl:String?, resourceId:GoogleCloudYoutubeResourceId?, type:String?) {
      self.author = author
      self.imageUrl = imageUrl
      self.referenceUrl = referenceUrl
      self.resourceId = resourceId
      self.type = type
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsSubscription : GoogleCloudModel {
   /*The resourceId object contains information that identifies the resource that the user subscribed to. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   public init(resourceId:GoogleCloudYoutubeResourceId?) {
      self.resourceId = resourceId
   }
}
public struct GoogleCloudYoutubeActivityContentDetailsUpload : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the uploaded video. */
   public var videoId: String?
   public init(videoId:String?) {
      self.videoId = videoId
   }
}
public struct GoogleCloudYoutubeActivityListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of activities, or events, that match the request criteria. */
   public var items: [GoogleCloudYoutubeActivity]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#activityListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeActivity]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeActivitySnippet : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the channel associated with the activity. */
   public var channelId: String?
   /*Channel title for the channel responsible for this activity */
   public var channelTitle: String?
   /*The description of the resource primarily associated with the activity. */
   public var description: String?
   /*The group ID associated with the activity. A group ID identifies user events that are associated with the same user and resource. For example, if a user rates a video and marks the same video as a favorite, the entries for those events would have the same group ID in the user's activity feed. In your user interface, you can avoid repetition by grouping events with the same groupId value. */
   public var groupId: String?
   /*The date and time that the video was uploaded. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*A map of thumbnail images associated with the resource that is primarily associated with the activity. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The title of the resource primarily associated with the activity. */
   public var title: String?
   /*The type of activity that the resource describes. */
   public var type: String?
   public init(channelId:String?, channelTitle:String?, description:String?, groupId:String?, publishedAt:String?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?, type:String?) {
      self.channelId = channelId
      self.channelTitle = channelTitle
      self.description = description
      self.groupId = groupId
      self.publishedAt = publishedAt
      self.thumbnails = thumbnails
      self.title = title
      self.type = type
   }
}
public struct GoogleCloudYoutubeCaption : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the caption track. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#caption". */
   public var kind: String?
   /*The snippet object contains basic details about the caption. */
   public var snippet: GoogleCloudYoutubeCaptionSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeCaptionSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeCaptionListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of captions that match the request criteria. */
   public var items: [GoogleCloudYoutubeCaption]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#captionListResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeCaption]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeCaptionSnippet : GoogleCloudModel {
   /*The type of audio track associated with the caption track. */
   public var audioTrackType: String?
   /*The reason that YouTube failed to process the caption track. This property is only present if the state property's value is failed. */
   public var failureReason: String?
   /*Indicates whether YouTube synchronized the caption track to the audio track in the video. The value will be true if a sync was explicitly requested when the caption track was uploaded. For example, when calling the captions.insert or captions.update methods, you can set the sync parameter to true to instruct YouTube to sync the uploaded track to the video. If the value is false, YouTube uses the time codes in the uploaded caption track to determine when to display captions. */
   public var isAutoSynced: Bool?
   /*Indicates whether the track contains closed captions for the deaf and hard of hearing. The default value is false. */
   public var isCC: Bool?
   /*Indicates whether the caption track is a draft. If the value is true, then the track is not publicly visible. The default value is false. */
   public var isDraft: Bool?
   /*Indicates whether caption track is formatted for "easy reader," meaning it is at a third-grade level for language learners. The default value is false. */
   public var isEasyReader: Bool?
   /*Indicates whether the caption track uses large text for the vision-impaired. The default value is false. */
   public var isLarge: Bool?
   /*The language of the caption track. The property value is a BCP-47 language tag. */
   public var language: String?
   /*The date and time when the caption track was last updated. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var lastUpdated: String?
   /*The name of the caption track. The name is intended to be visible to the user as an option during playback. */
   public var name: String?
   /*The caption track's status. */
   public var status: String?
   /*The caption track's type. */
   public var trackKind: String?
   /*The ID that YouTube uses to uniquely identify the video associated with the caption track. */
   public var videoId: String?
   public init(audioTrackType:String?, failureReason:String?, isAutoSynced:Bool?, isCC:Bool?, isDraft:Bool?, isEasyReader:Bool?, isLarge:Bool?, language:String?, lastUpdated:String?, name:String?, status:String?, trackKind:String?, videoId:String?) {
      self.audioTrackType = audioTrackType
      self.failureReason = failureReason
      self.isAutoSynced = isAutoSynced
      self.isCC = isCC
      self.isDraft = isDraft
      self.isEasyReader = isEasyReader
      self.isLarge = isLarge
      self.language = language
      self.lastUpdated = lastUpdated
      self.name = name
      self.status = status
      self.trackKind = trackKind
      self.videoId = videoId
   }
}
public struct GoogleCloudYoutubeCdnSettings : GoogleCloudModel {
   /*The format of the video stream that you are sending to Youtube. */
   public var format: String?
   /*The frame rate of the inbound video data. */
   public var frameRate: String?
   /*The ingestionInfo object contains information that YouTube provides that you need to transmit your RTMP or HTTP stream to YouTube. */
   public var ingestionInfo: GoogleCloudYoutubeIngestionInfo?
   /*The method or protocol used to transmit the video stream. */
   public var ingestionType: String?
   /*The resolution of the inbound video data. */
   public var resolution: String?
   public init(format:String?, frameRate:String?, ingestionInfo:GoogleCloudYoutubeIngestionInfo?, ingestionType:String?, resolution:String?) {
      self.format = format
      self.frameRate = frameRate
      self.ingestionInfo = ingestionInfo
      self.ingestionType = ingestionType
      self.resolution = resolution
   }
}
public struct GoogleCloudYoutubeChannel : GoogleCloudModel {
   /*The auditionDetails object encapsulates channel data that is relevant for YouTube Partners during the audition process. */
   public var auditDetails: GoogleCloudYoutubeChannelAuditDetails?
   /*The brandingSettings object encapsulates information about the branding of the channel. */
   public var brandingSettings: GoogleCloudYoutubeChannelBrandingSettings?
   /*The contentDetails object encapsulates information about the channel's content. */
   public var contentDetails: GoogleCloudYoutubeChannelContentDetails?
   /*The contentOwnerDetails object encapsulates channel data that is relevant for YouTube Partners linked with the channel. */
   public var contentOwnerDetails: GoogleCloudYoutubeChannelContentOwnerDetails?
   /*The conversionPings object encapsulates information about conversion pings that need to be respected by the channel. */
   public var conversionPings: GoogleCloudYoutubeChannelConversionPings?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the channel. */
   public var id: String?
   /*The invideoPromotion object encapsulates information about promotion campaign associated with the channel. */
   public var invideoPromotion: GoogleCloudYoutubeInvideoPromotion?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#channel". */
   public var kind: String?
   /*Localizations for different languages */
   public var localizations: [String : GoogleCloudYoutubeChannelLocalization]?
   /*The snippet object contains basic details about the channel, such as its title, description, and thumbnail images. */
   public var snippet: GoogleCloudYoutubeChannelSnippet?
   /*The statistics object encapsulates statistics for the channel. */
   public var statistics: GoogleCloudYoutubeChannelStatistics?
   /*The status object encapsulates information about the privacy status of the channel. */
   public var status: GoogleCloudYoutubeChannelStatus?
   /*The topicDetails object encapsulates information about Freebase topics associated with the channel. */
   public var topicDetails: GoogleCloudYoutubeChannelTopicDetails?
   public init(auditDetails:GoogleCloudYoutubeChannelAuditDetails?, brandingSettings:GoogleCloudYoutubeChannelBrandingSettings?, contentDetails:GoogleCloudYoutubeChannelContentDetails?, contentOwnerDetails:GoogleCloudYoutubeChannelContentOwnerDetails?, conversionPings:GoogleCloudYoutubeChannelConversionPings?, etag:String?, id:String?, invideoPromotion:GoogleCloudYoutubeInvideoPromotion?, kind:String?, localizations:[String : GoogleCloudYoutubeChannelLocalization]?, snippet:GoogleCloudYoutubeChannelSnippet?, statistics:GoogleCloudYoutubeChannelStatistics?, status:GoogleCloudYoutubeChannelStatus?, topicDetails:GoogleCloudYoutubeChannelTopicDetails?) {
      self.auditDetails = auditDetails
      self.brandingSettings = brandingSettings
      self.contentDetails = contentDetails
      self.contentOwnerDetails = contentOwnerDetails
      self.conversionPings = conversionPings
      self.etag = etag
      self.id = id
      self.invideoPromotion = invideoPromotion
      self.kind = kind
      self.localizations = localizations
      self.snippet = snippet
      self.statistics = statistics
      self.status = status
      self.topicDetails = topicDetails
   }
}
public struct GoogleCloudYoutubeChannelAuditDetails : GoogleCloudModel {
   /*Whether or not the channel respects the community guidelines. */
   public var communityGuidelinesGoodStanding: Bool?
   /*Whether or not the channel has any unresolved claims. */
   public var contentIdClaimsGoodStanding: Bool?
   /*Whether or not the channel has any copyright strikes. */
   public var copyrightStrikesGoodStanding: Bool?
   public init(communityGuidelinesGoodStanding:Bool?, contentIdClaimsGoodStanding:Bool?, copyrightStrikesGoodStanding:Bool?) {
      self.communityGuidelinesGoodStanding = communityGuidelinesGoodStanding
      self.contentIdClaimsGoodStanding = contentIdClaimsGoodStanding
      self.copyrightStrikesGoodStanding = copyrightStrikesGoodStanding
   }
}
public struct GoogleCloudYoutubeChannelBannerResource : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#channelBannerResource". */
   public var kind: String?
   /*The URL of this banner image. */
   public var url: String?
   public init(etag:String?, kind:String?, url:String?) {
      self.etag = etag
      self.kind = kind
      self.url = url
   }
}
public struct GoogleCloudYoutubeChannelBrandingSettings : GoogleCloudModel {
   /*Branding properties for the channel view. */
   public var `channel`: GoogleCloudYoutubeChannelSettings?
   /*Additional experimental branding properties. */
   public var hints: [GoogleCloudYoutubePropertyValue]?
   /*Branding properties for branding images. */
   public var image: GoogleCloudYoutubeImageSettings?
   /*Branding properties for the watch page. */
   public var watch: GoogleCloudYoutubeWatchSettings?
   public init(`channel`:GoogleCloudYoutubeChannelSettings?, hints:[GoogleCloudYoutubePropertyValue]?, image:GoogleCloudYoutubeImageSettings?, watch:GoogleCloudYoutubeWatchSettings?) {
      self.`channel` = `channel`
      self.hints = hints
      self.image = image
      self.watch = watch
   }
}
public struct GoogleCloudYoutubeChannelContentDetails : GoogleCloudModel {
   public var relatedPlaylists: GoogleCloudYoutubeChannelContentDetailsRelatedPlaylists?
   public init(relatedPlaylists:GoogleCloudYoutubeChannelContentDetailsRelatedPlaylists?) {
      self.relatedPlaylists = relatedPlaylists
   }
}
public struct GoogleCloudYoutubeChannelContentOwnerDetails : GoogleCloudModel {
   /*The ID of the content owner linked to the channel. */
   public var contentOwner: String?
   /*The date and time of when the channel was linked to the content owner. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var timeLinked: String?
   public init(contentOwner:String?, timeLinked:String?) {
      self.contentOwner = contentOwner
      self.timeLinked = timeLinked
   }
}
public struct GoogleCloudYoutubeChannelConversionPing : GoogleCloudModel {
   /*Defines the context of the ping. */
   public var context: String?
   /*The url (without the schema) that the player shall send the ping to. It's at caller's descretion to decide which schema to use (http vs https) Example of a returned url: //googleads.g.doubleclick.net/pagead/ viewthroughconversion/962985656/?data=path%3DtHe_path%3Btype%3D cview%3Butuid%3DGISQtTNGYqaYl4sKxoVvKA&labe=default The caller must append biscotti authentication (ms param in case of mobile, for example) to this ping. */
   public var conversionUrl: String?
   public init(context:String?, conversionUrl:String?) {
      self.context = context
      self.conversionUrl = conversionUrl
   }
}
public struct GoogleCloudYoutubeChannelConversionPings : GoogleCloudModel {
   /*Pings that the app shall fire (authenticated by biscotti cookie). Each ping has a context, in which the app must fire the ping, and a url identifying the ping. */
   public var pings: [GoogleCloudYoutubeChannelConversionPing]?
   public init(pings:[GoogleCloudYoutubeChannelConversionPing]?) {
      self.pings = pings
   }
}
public struct GoogleCloudYoutubeChannelListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of channels that match the request criteria. */
   public var items: [GoogleCloudYoutubeChannel]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#channelListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeChannel]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeChannelLocalization : GoogleCloudModel {
   /*The localized strings for channel's description. */
   public var description: String?
   /*The localized strings for channel's title. */
   public var title: String?
   public init(description:String?, title:String?) {
      self.description = description
      self.title = title
   }
}
public struct GoogleCloudYoutubeChannelProfileDetails : GoogleCloudModel {
   /*The YouTube channel ID. */
   public var channelId: String?
   /*The channel's URL. */
   public var channelUrl: String?
   /*The channel's display name. */
   public var displayName: String?
   /*The channels's avatar URL. */
   public var profileImageUrl: String?
   public init(channelId:String?, channelUrl:String?, displayName:String?, profileImageUrl:String?) {
      self.channelId = channelId
      self.channelUrl = channelUrl
      self.displayName = displayName
      self.profileImageUrl = profileImageUrl
   }
}
public struct GoogleCloudYoutubeChannelSection : GoogleCloudModel {
   /*The contentDetails object contains details about the channel section content, such as a list of playlists or channels featured in the section. */
   public var contentDetails: GoogleCloudYoutubeChannelSectionContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the channel section. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#channelSection". */
   public var kind: String?
   /*Localizations for different languages */
   public var localizations: [String : GoogleCloudYoutubeChannelSectionLocalization]?
   /*The snippet object contains basic details about the channel section, such as its type, style and title. */
   public var snippet: GoogleCloudYoutubeChannelSectionSnippet?
   /*The targeting object contains basic targeting settings about the channel section. */
   public var targeting: GoogleCloudYoutubeChannelSectionTargeting?
   public init(contentDetails:GoogleCloudYoutubeChannelSectionContentDetails?, etag:String?, id:String?, kind:String?, localizations:[String : GoogleCloudYoutubeChannelSectionLocalization]?, snippet:GoogleCloudYoutubeChannelSectionSnippet?, targeting:GoogleCloudYoutubeChannelSectionTargeting?) {
      self.contentDetails = contentDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.localizations = localizations
      self.snippet = snippet
      self.targeting = targeting
   }
}
public struct GoogleCloudYoutubeChannelSectionContentDetails : GoogleCloudModel {
   /*The channel ids for type multiple_channels. */
   public var channels: [String]?
   /*The playlist ids for type single_playlist and multiple_playlists. For singlePlaylist, only one playlistId is allowed. */
   public var playlists: [String]?
   public init(channels:[String]?, playlists:[String]?) {
      self.channels = channels
      self.playlists = playlists
   }
}
public struct GoogleCloudYoutubeChannelSectionListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of ChannelSections that match the request criteria. */
   public var items: [GoogleCloudYoutubeChannelSection]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#channelSectionListResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeChannelSection]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeChannelSectionLocalization : GoogleCloudModel {
   /*The localized strings for channel section's title. */
   public var title: String?
   public init(title:String?) {
      self.title = title
   }
}
public struct GoogleCloudYoutubeChannelSectionSnippet : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the channel that published the channel section. */
   public var channelId: String?
   /*The language of the channel section's default title and description. */
   public var defaultLanguage: String?
   /*Localized title, read-only. */
   public var localized: GoogleCloudYoutubeChannelSectionLocalization?
   /*The position of the channel section in the channel. */
   @CodingUses<Coder> public var position: UInt?
   /*The style of the channel section. */
   public var style: String?
   /*The channel section's title for multiple_playlists and multiple_channels. */
   public var title: String?
   /*The type of the channel section. */
   public var type: String?
   public init(channelId:String?, defaultLanguage:String?, localized:GoogleCloudYoutubeChannelSectionLocalization?, position:UInt?, style:String?, title:String?, type:String?) {
      self.channelId = channelId
      self.defaultLanguage = defaultLanguage
      self.localized = localized
      self.position = position
      self.style = style
      self.title = title
      self.type = type
   }
}
public struct GoogleCloudYoutubeChannelSectionTargeting : GoogleCloudModel {
   /*The country the channel section is targeting. */
   public var countries: [String]?
   /*The language the channel section is targeting. */
   public var languages: [String]?
   /*The region the channel section is targeting. */
   public var regions: [String]?
   public init(countries:[String]?, languages:[String]?, regions:[String]?) {
      self.countries = countries
      self.languages = languages
      self.regions = regions
   }
}
public struct GoogleCloudYoutubeChannelSettings : GoogleCloudModel {
   /*The country of the channel. */
   public var country: String?
   public var defaultLanguage: String?
   /*Which content tab users should see when viewing the channel. */
   public var defaultTab: String?
   /*Specifies the channel description. */
   public var description: String?
   /*Title for the featured channels tab. */
   public var featuredChannelsTitle: String?
   /*The list of featured channels. */
   public var featuredChannelsUrls: [String]?
   /*Lists keywords associated with the channel, comma-separated. */
   public var keywords: String?
   /*Whether user-submitted comments left on the channel page need to be approved by the channel owner to be publicly visible. */
   public var moderateComments: Bool?
   /*A prominent color that can be rendered on this channel page. */
   public var profileColor: String?
   /*Whether the tab to browse the videos should be displayed. */
   public var showBrowseView: Bool?
   /*Whether related channels should be proposed. */
   public var showRelatedChannels: Bool?
   /*Specifies the channel title. */
   public var title: String?
   /*The ID for a Google Analytics account to track and measure traffic to the channels. */
   public var trackingAnalyticsAccountId: String?
   /*The trailer of the channel, for users that are not subscribers. */
   public var unsubscribedTrailer: String?
   public init(country:String?, defaultLanguage:String?, defaultTab:String?, description:String?, featuredChannelsTitle:String?, featuredChannelsUrls:[String]?, keywords:String?, moderateComments:Bool?, profileColor:String?, showBrowseView:Bool?, showRelatedChannels:Bool?, title:String?, trackingAnalyticsAccountId:String?, unsubscribedTrailer:String?) {
      self.country = country
      self.defaultLanguage = defaultLanguage
      self.defaultTab = defaultTab
      self.description = description
      self.featuredChannelsTitle = featuredChannelsTitle
      self.featuredChannelsUrls = featuredChannelsUrls
      self.keywords = keywords
      self.moderateComments = moderateComments
      self.profileColor = profileColor
      self.showBrowseView = showBrowseView
      self.showRelatedChannels = showRelatedChannels
      self.title = title
      self.trackingAnalyticsAccountId = trackingAnalyticsAccountId
      self.unsubscribedTrailer = unsubscribedTrailer
   }
}
public struct GoogleCloudYoutubeChannelSnippet : GoogleCloudModel {
   /*The country of the channel. */
   public var country: String?
   /*The custom url of the channel. */
   public var customUrl: String?
   /*The language of the channel's default title and description. */
   public var defaultLanguage: String?
   /*The description of the channel. */
   public var description: String?
   /*Localized title and description, read-only. */
   public var localized: GoogleCloudYoutubeChannelLocalization?
   /*The date and time that the channel was created. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*A map of thumbnail images associated with the channel. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail.

When displaying thumbnails in your application, make sure that your code uses the image URLs exactly as they are returned in API responses. For example, your application should not use the http domain instead of the https domain in a URL returned in an API response.

Beginning in July 2018, channel thumbnail URLs will only be available in the https domain, which is how the URLs appear in API responses. After that time, you might see broken images in your application if it tries to load YouTube images from the http domain. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The channel's title. */
   public var title: String?
   public init(country:String?, customUrl:String?, defaultLanguage:String?, description:String?, localized:GoogleCloudYoutubeChannelLocalization?, publishedAt:String?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.country = country
      self.customUrl = customUrl
      self.defaultLanguage = defaultLanguage
      self.description = description
      self.localized = localized
      self.publishedAt = publishedAt
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubeChannelStatistics : GoogleCloudModel {
   /*The number of comments for the channel. */
   @CodingUses<Coder> public var commentCount: UInt?
   /*Whether or not the number of subscribers is shown for this user. */
   public var hiddenSubscriberCount: Bool?
   /*The number of subscribers that the channel has. */
   @CodingUses<Coder> public var subscriberCount: UInt?
   /*The number of videos uploaded to the channel. */
   @CodingUses<Coder> public var videoCount: UInt?
   /*The number of times the channel has been viewed. */
   @CodingUses<Coder> public var viewCount: UInt?
   public init(commentCount:UInt?, hiddenSubscriberCount:Bool?, subscriberCount:UInt?, videoCount:UInt?, viewCount:UInt?) {
      self.commentCount = commentCount
      self.hiddenSubscriberCount = hiddenSubscriberCount
      self.subscriberCount = subscriberCount
      self.videoCount = videoCount
      self.viewCount = viewCount
   }
}
public struct GoogleCloudYoutubeChannelStatus : GoogleCloudModel {
   /*If true, then the user is linked to either a YouTube username or G+ account. Otherwise, the user doesn't have a public YouTube identity. */
   public var isLinked: Bool?
   /*The long uploads status of this channel. See */
   public var longUploadsStatus: String?
   public var madeForKids: Bool?
   /*Privacy status of the channel. */
   public var privacyStatus: String?
   public var selfDeclaredMadeForKids: Bool?
   public init(isLinked:Bool?, longUploadsStatus:String?, madeForKids:Bool?, privacyStatus:String?, selfDeclaredMadeForKids:Bool?) {
      self.isLinked = isLinked
      self.longUploadsStatus = longUploadsStatus
      self.madeForKids = madeForKids
      self.privacyStatus = privacyStatus
      self.selfDeclaredMadeForKids = selfDeclaredMadeForKids
   }
}
public struct GoogleCloudYoutubeChannelTopicDetails : GoogleCloudModel {
   /*A list of Wikipedia URLs that describe the channel's content. */
   public var topicCategories: [String]?
   /*A list of Freebase topic IDs associated with the channel. You can retrieve information about each topic using the Freebase Topic API. */
   public var topicIds: [String]?
   public init(topicCategories:[String]?, topicIds:[String]?) {
      self.topicCategories = topicCategories
      self.topicIds = topicIds
   }
}
public struct GoogleCloudYoutubeComment : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the comment. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#comment". */
   public var kind: String?
   /*The snippet object contains basic details about the comment. */
   public var snippet: GoogleCloudYoutubeCommentSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeCommentSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeCommentListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of comments that match the request criteria. */
   public var items: [GoogleCloudYoutubeComment]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#commentListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeComment]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeCommentSnippet : GoogleCloudModel {
   /*The id of the author's YouTube channel, if any. */
    public var authorChannelId: [String: String]?
   /*Link to the author's YouTube channel, if any. */
   public var authorChannelUrl: String?
   /*The name of the user who posted the comment. */
   public var authorDisplayName: String?
   /*The URL for the avatar of the user who posted the comment. */
   public var authorProfileImageUrl: String?
   /*Whether the current viewer can rate this comment. */
   public var canRate: Bool?
   /*The id of the corresponding YouTube channel. In case of a channel comment this is the channel the comment refers to. In case of a video comment it's the video's channel. */
   public var channelId: String?
   /*The total number of likes this comment has received. */
   @CodingUses<Coder> public var likeCount: UInt?
   /*The comment's moderation status. Will not be set if the comments were requested through the id filter. */
   public var moderationStatus: String?
   /*The unique id of the parent comment, only set for replies. */
   public var parentId: String?
   /*The date and time when the comment was orignally published. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*The comment's text. The format is either plain text or HTML dependent on what has been requested. Even the plain text representation may differ from the text originally posted in that it may replace video links with video titles etc. */
   public var textDisplay: String?
   /*The comment's original raw text as initially posted or last updated. The original text will only be returned if it is accessible to the viewer, which is only guaranteed if the viewer is the comment's author. */
   public var textOriginal: String?
   /*The date and time when was last updated . The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var updatedAt: String?
   /*The ID of the video the comment refers to, if any. */
   public var videoId: String?
   /*The rating the viewer has given to this comment. For the time being this will never return RATE_TYPE_DISLIKE and instead return RATE_TYPE_NONE. This may change in the future. */
   public var viewerRating: String?
   public init(authorChannelId:[String: String]?, authorChannelUrl:String?, authorDisplayName:String?, authorProfileImageUrl:String?, canRate:Bool?, channelId:String?, likeCount:UInt?, moderationStatus:String?, parentId:String?, publishedAt:String?, textDisplay:String?, textOriginal:String?, updatedAt:String?, videoId:String?, viewerRating:String?) {
      self.authorChannelId = authorChannelId
      self.authorChannelUrl = authorChannelUrl
      self.authorDisplayName = authorDisplayName
      self.authorProfileImageUrl = authorProfileImageUrl
      self.canRate = canRate
      self.channelId = channelId
      self.likeCount = likeCount
      self.moderationStatus = moderationStatus
      self.parentId = parentId
      self.publishedAt = publishedAt
      self.textDisplay = textDisplay
      self.textOriginal = textOriginal
      self.updatedAt = updatedAt
      self.videoId = videoId
      self.viewerRating = viewerRating
   }
}
public struct GoogleCloudYoutubeCommentThread : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the comment thread. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#commentThread". */
   public var kind: String?
   /*The replies object contains a limited number of replies (if any) to the top level comment found in the snippet. */
   public var replies: GoogleCloudYoutubeCommentThreadReplies?
   /*The snippet object contains basic details about the comment thread and also the top level comment. */
   public var snippet: GoogleCloudYoutubeCommentThreadSnippet?
   public init(etag:String?, id:String?, kind:String?, replies:GoogleCloudYoutubeCommentThreadReplies?, snippet:GoogleCloudYoutubeCommentThreadSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.replies = replies
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeCommentThreadListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of comment threads that match the request criteria. */
   public var items: [GoogleCloudYoutubeCommentThread]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#commentThreadListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeCommentThread]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeCommentThreadReplies : GoogleCloudModel {
   /*A limited number of replies. Unless the number of replies returned equals total_reply_count in the snippet the returned replies are only a subset of the total number of replies. */
   public var comments: [GoogleCloudYoutubeComment]?
   public init(comments:[GoogleCloudYoutubeComment]?) {
      self.comments = comments
   }
}
public struct GoogleCloudYoutubeCommentThreadSnippet : GoogleCloudModel {
   /*Whether the current viewer of the thread can reply to it. This is viewer specific - other viewers may see a different value for this field. */
   public var canReply: Bool?
   /*The YouTube channel the comments in the thread refer to or the channel with the video the comments refer to. If video_id isn't set the comments refer to the channel itself. */
   public var channelId: String?
   /*Whether the thread (and therefore all its comments) is visible to all YouTube users. */
   public var isPublic: Bool?
   /*The top level comment of this thread. */
   public var topLevelComment: GoogleCloudYoutubeComment?
   /*The total number of replies (not including the top level comment). */
   @CodingUses<Coder> public var totalReplyCount: UInt?
   /*The ID of the video the comments refer to, if any. No video_id implies a channel discussion comment. */
   public var videoId: String?
   public init(canReply:Bool?, channelId:String?, isPublic:Bool?, topLevelComment:GoogleCloudYoutubeComment?, totalReplyCount:UInt?, videoId:String?) {
      self.canReply = canReply
      self.channelId = channelId
      self.isPublic = isPublic
      self.topLevelComment = topLevelComment
      self.totalReplyCount = totalReplyCount
      self.videoId = videoId
   }
}
public struct GoogleCloudYoutubeContentRating : GoogleCloudModel {
   /*The video's Australian Classification Board (ACB) or Australian Communications and Media Authority (ACMA) rating. ACMA ratings are used to classify children's television programming. */
   public var acbRating: String?
   /*The video's rating from Italy's Autorità per le Garanzie nelle Comunicazioni (AGCOM). */
   public var agcomRating: String?
   /*The video's Anatel (Asociación Nacional de Televisión) rating for Chilean television. */
   public var anatelRating: String?
   /*The video's British Board of Film Classification (BBFC) rating. */
   public var bbfcRating: String?
   /*The video's rating from Thailand's Board of Film and Video Censors. */
   public var bfvcRating: String?
   /*The video's rating from the Austrian Board of Media Classification (Bundesministerium für Unterricht, Kunst und Kultur). */
   public var bmukkRating: String?
   /*Rating system for Canadian TV - Canadian TV Classification System The video's rating from the Canadian Radio-Television and Telecommunications Commission (CRTC) for Canadian English-language broadcasts. For more information, see the Canadian Broadcast Standards Council website. */
   public var catvRating: String?
   /*The video's rating from the Canadian Radio-Television and Telecommunications Commission (CRTC) for Canadian French-language broadcasts. For more information, see the Canadian Broadcast Standards Council website. */
   public var catvfrRating: String?
   /*The video's Central Board of Film Certification (CBFC - India) rating. */
   public var cbfcRating: String?
   /*The video's Consejo de Calificación Cinematográfica (Chile) rating. */
   public var cccRating: String?
   /*The video's rating from Portugal's Comissão de Classificação de Espect´culos. */
   public var cceRating: String?
   /*The video's rating in Switzerland. */
   public var chfilmRating: String?
   /*The video's Canadian Home Video Rating System (CHVRS) rating. */
   public var chvrsRating: String?
   /*The video's rating from the Commission de Contrôle des Films (Belgium). */
   public var cicfRating: String?
   /*The video's rating from Romania's CONSILIUL NATIONAL AL AUDIOVIZUALULUI (CNA). */
   public var cnaRating: String?
   /*Rating system in France - Commission de classification cinematographique */
   public var cncRating: String?
   /*The video's rating from France's Conseil supérieur de l?audiovisuel, which rates broadcast content. */
   public var csaRating: String?
   /*The video's rating from Luxembourg's Commission de surveillance de la classification des films (CSCF). */
   public var cscfRating: String?
   /*The video's rating in the Czech Republic. */
   public var czfilmRating: String?
   /*The video's Departamento de Justiça, Classificação, Qualificação e Títulos (DJCQT - Brazil) rating. */
   public var djctqRating: String?
   /*Reasons that explain why the video received its DJCQT (Brazil) rating. */
   public var djctqRatingReasons: [String]?
   /*Rating system in Turkey - Evaluation and Classification Board of the Ministry of Culture and Tourism */
   public var ecbmctRating: String?
   /*The video's rating in Estonia. */
   public var eefilmRating: String?
   /*The video's rating in Egypt. */
   public var egfilmRating: String?
   /*The video's Eirin (映倫) rating. Eirin is the Japanese rating system. */
   public var eirinRating: String?
   /*The video's rating from Malaysia's Film Censorship Board. */
   public var fcbmRating: String?
   /*The video's rating from Hong Kong's Office for Film, Newspaper and Article Administration. */
   public var fcoRating: String?
   /*This property has been deprecated. Use the contentDetails.contentRating.cncRating instead. */
   public var fmocRating: String?
   /*The video's rating from South Africa's Film and Publication Board. */
   public var fpbRating: String?
   /*Reasons that explain why the video received its FPB (South Africa) rating. */
   public var fpbRatingReasons: [String]?
   /*The video's Freiwillige Selbstkontrolle der Filmwirtschaft (FSK - Germany) rating. */
   public var fskRating: String?
   /*The video's rating in Greece. */
   public var grfilmRating: String?
   /*The video's Instituto de la Cinematografía y de las Artes Audiovisuales (ICAA - Spain) rating. */
   public var icaaRating: String?
   /*The video's Irish Film Classification Office (IFCO - Ireland) rating. See the IFCO website for more information. */
   public var ifcoRating: String?
   /*The video's rating in Israel. */
   public var ilfilmRating: String?
   /*The video's INCAA (Instituto Nacional de Cine y Artes Audiovisuales - Argentina) rating. */
   public var incaaRating: String?
   /*The video's rating from the Kenya Film Classification Board. */
   public var kfcbRating: String?
   /*voor de Classificatie van Audiovisuele Media (Netherlands). */
   public var kijkwijzerRating: String?
   /*The video's Korea Media Rating Board (영상물등급위원회) rating. The KMRB rates videos in South Korea. */
   public var kmrbRating: String?
   /*The video's rating from Indonesia's Lembaga Sensor Film. */
   public var lsfRating: String?
   /*The video's rating from Malta's Film Age-Classification Board. */
   public var mccaaRating: String?
   /*The video's rating from the Danish Film Institute's (Det Danske Filminstitut) Media Council for Children and Young People. */
   public var mccypRating: String?
   /*The video's rating system for Vietnam - MCST */
   public var mcstRating: String?
   /*The video's rating from Singapore's Media Development Authority (MDA) and, specifically, it's Board of Film Censors (BFC). */
   public var mdaRating: String?
   /*The video's rating from Medietilsynet, the Norwegian Media Authority. */
   public var medietilsynetRating: String?
   /*The video's rating from Finland's Kansallinen Audiovisuaalinen Instituutti (National Audiovisual Institute). */
   public var mekuRating: String?
   /*The rating system for MENA countries, a clone of MPAA. It is needed to */
   public var menaMpaaRating: String?
   /*The video's rating from the Ministero dei Beni e delle Attività Culturali e del Turismo (Italy). */
   public var mibacRating: String?
   /*The video's Ministerio de Cultura (Colombia) rating. */
   public var mocRating: String?
   /*The video's rating from Taiwan's Ministry of Culture (文化部). */
   public var moctwRating: String?
   /*The video's Motion Picture Association of America (MPAA) rating. */
   public var mpaaRating: String?
   /*The rating system for trailer, DVD, and Ad in the US. See http://movielabs.com/md/ratings/v2.3/html/US_MPAAT_Ratings.html. */
   public var mpaatRating: String?
   /*The video's rating from the Movie and Television Review and Classification Board (Philippines). */
   public var mtrcbRating: String?
   /*The video's rating from the Maldives National Bureau of Classification. */
   public var nbcRating: String?
   /*The video's rating in Poland. */
   public var nbcplRating: String?
   /*The video's rating from the Bulgarian National Film Center. */
   public var nfrcRating: String?
   /*The video's rating from Nigeria's National Film and Video Censors Board. */
   public var nfvcbRating: String?
   /*The video's rating from the Nacionãlais Kino centrs (National Film Centre of Latvia). */
   public var nkclvRating: String?
   public var nmcRating: String?
   /*The video's Office of Film and Literature Classification (OFLC - New Zealand) rating. */
   public var oflcRating: String?
   /*The video's rating in Peru. */
   public var pefilmRating: String?
   /*The video's rating from the Hungarian Nemzeti Filmiroda, the Rating Committee of the National Office of Film. */
   public var rcnofRating: String?
   /*The video's rating in Venezuela. */
   public var resorteviolenciaRating: String?
   /*The video's General Directorate of Radio, Television and Cinematography (Mexico) rating. */
   public var rtcRating: String?
   /*The video's rating from Ireland's Raidió Teilifís Éireann. */
   public var rteRating: String?
   /*The video's National Film Registry of the Russian Federation (MKRF - Russia) rating. */
   public var russiaRating: String?
   /*The video's rating in Slovakia. */
   public var skfilmRating: String?
   /*The video's rating in Iceland. */
   public var smaisRating: String?
   /*The video's rating from Statens medieråd (Sweden's National Media Council). */
   public var smsaRating: String?
   /*The video's TV Parental Guidelines (TVPG) rating. */
   public var tvpgRating: String?
   /*A rating that YouTube uses to identify age-restricted content. */
   public var ytRating: String?
   public init(acbRating:String?, agcomRating:String?, anatelRating:String?, bbfcRating:String?, bfvcRating:String?, bmukkRating:String?, catvRating:String?, catvfrRating:String?, cbfcRating:String?, cccRating:String?, cceRating:String?, chfilmRating:String?, chvrsRating:String?, cicfRating:String?, cnaRating:String?, cncRating:String?, csaRating:String?, cscfRating:String?, czfilmRating:String?, djctqRating:String?, djctqRatingReasons:[String]?, ecbmctRating:String?, eefilmRating:String?, egfilmRating:String?, eirinRating:String?, fcbmRating:String?, fcoRating:String?, fmocRating:String?, fpbRating:String?, fpbRatingReasons:[String]?, fskRating:String?, grfilmRating:String?, icaaRating:String?, ifcoRating:String?, ilfilmRating:String?, incaaRating:String?, kfcbRating:String?, kijkwijzerRating:String?, kmrbRating:String?, lsfRating:String?, mccaaRating:String?, mccypRating:String?, mcstRating:String?, mdaRating:String?, medietilsynetRating:String?, mekuRating:String?, menaMpaaRating:String?, mibacRating:String?, mocRating:String?, moctwRating:String?, mpaaRating:String?, mpaatRating:String?, mtrcbRating:String?, nbcRating:String?, nbcplRating:String?, nfrcRating:String?, nfvcbRating:String?, nkclvRating:String?, nmcRating:String?, oflcRating:String?, pefilmRating:String?, rcnofRating:String?, resorteviolenciaRating:String?, rtcRating:String?, rteRating:String?, russiaRating:String?, skfilmRating:String?, smaisRating:String?, smsaRating:String?, tvpgRating:String?, ytRating:String?) {
      self.acbRating = acbRating
      self.agcomRating = agcomRating
      self.anatelRating = anatelRating
      self.bbfcRating = bbfcRating
      self.bfvcRating = bfvcRating
      self.bmukkRating = bmukkRating
      self.catvRating = catvRating
      self.catvfrRating = catvfrRating
      self.cbfcRating = cbfcRating
      self.cccRating = cccRating
      self.cceRating = cceRating
      self.chfilmRating = chfilmRating
      self.chvrsRating = chvrsRating
      self.cicfRating = cicfRating
      self.cnaRating = cnaRating
      self.cncRating = cncRating
      self.csaRating = csaRating
      self.cscfRating = cscfRating
      self.czfilmRating = czfilmRating
      self.djctqRating = djctqRating
      self.djctqRatingReasons = djctqRatingReasons
      self.ecbmctRating = ecbmctRating
      self.eefilmRating = eefilmRating
      self.egfilmRating = egfilmRating
      self.eirinRating = eirinRating
      self.fcbmRating = fcbmRating
      self.fcoRating = fcoRating
      self.fmocRating = fmocRating
      self.fpbRating = fpbRating
      self.fpbRatingReasons = fpbRatingReasons
      self.fskRating = fskRating
      self.grfilmRating = grfilmRating
      self.icaaRating = icaaRating
      self.ifcoRating = ifcoRating
      self.ilfilmRating = ilfilmRating
      self.incaaRating = incaaRating
      self.kfcbRating = kfcbRating
      self.kijkwijzerRating = kijkwijzerRating
      self.kmrbRating = kmrbRating
      self.lsfRating = lsfRating
      self.mccaaRating = mccaaRating
      self.mccypRating = mccypRating
      self.mcstRating = mcstRating
      self.mdaRating = mdaRating
      self.medietilsynetRating = medietilsynetRating
      self.mekuRating = mekuRating
      self.menaMpaaRating = menaMpaaRating
      self.mibacRating = mibacRating
      self.mocRating = mocRating
      self.moctwRating = moctwRating
      self.mpaaRating = mpaaRating
      self.mpaatRating = mpaatRating
      self.mtrcbRating = mtrcbRating
      self.nbcRating = nbcRating
      self.nbcplRating = nbcplRating
      self.nfrcRating = nfrcRating
      self.nfvcbRating = nfvcbRating
      self.nkclvRating = nkclvRating
      self.nmcRating = nmcRating
      self.oflcRating = oflcRating
      self.pefilmRating = pefilmRating
      self.rcnofRating = rcnofRating
      self.resorteviolenciaRating = resorteviolenciaRating
      self.rtcRating = rtcRating
      self.rteRating = rteRating
      self.russiaRating = russiaRating
      self.skfilmRating = skfilmRating
      self.smaisRating = smaisRating
      self.smsaRating = smsaRating
      self.tvpgRating = tvpgRating
      self.ytRating = ytRating
   }
}
public struct GoogleCloudYoutubeGeoPoint : GoogleCloudModel {
   /*Altitude above the reference ellipsoid, in meters. */
   @CodingUses<Coder> public var altitude: Double?
   /*Latitude in degrees. */
   @CodingUses<Coder> public var latitude: Double?
   /*Longitude in degrees. */
   @CodingUses<Coder> public var longitude: Double?
   public init(altitude:Double?, latitude:Double?, longitude:Double?) {
      self.altitude = altitude
      self.latitude = latitude
      self.longitude = longitude
   }
}
public struct GoogleCloudYoutubeGuideCategory : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the guide category. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#guideCategory". */
   public var kind: String?
   /*The snippet object contains basic details about the category, such as its title. */
   public var snippet: GoogleCloudYoutubeGuideCategorySnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeGuideCategorySnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeGuideCategoryListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of categories that can be associated with YouTube channels. In this map, the category ID is the map key, and its value is the corresponding guideCategory resource. */
   public var items: [GoogleCloudYoutubeGuideCategory]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#guideCategoryListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeGuideCategory]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeGuideCategorySnippet : GoogleCloudModel {
   public var channelId: String?
   /*Description of the guide category. */
   public var title: String?
   public init(channelId:String?, title:String?) {
      self.channelId = channelId
      self.title = title
   }
}
public struct GoogleCloudYoutubeI18nLanguage : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the i18n language. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#i18nLanguage". */
   public var kind: String?
   /*The snippet object contains basic details about the i18n language, such as language code and human-readable name. */
   public var snippet: GoogleCloudYoutubeI18nLanguageSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeI18nLanguageSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeI18nLanguageListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of supported i18n languages. In this map, the i18n language ID is the map key, and its value is the corresponding i18nLanguage resource. */
   public var items: [GoogleCloudYoutubeI18nLanguage]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#i18nLanguageListResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeI18nLanguage]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeI18nLanguageSnippet : GoogleCloudModel {
   /*A short BCP-47 code that uniquely identifies a language. */
   public var hl: String?
   /*The human-readable name of the language in the language itself. */
   public var name: String?
   public init(hl:String?, name:String?) {
      self.hl = hl
      self.name = name
   }
}
public struct GoogleCloudYoutubeI18nRegion : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the i18n region. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#i18nRegion". */
   public var kind: String?
   /*The snippet object contains basic details about the i18n region, such as region code and human-readable name. */
   public var snippet: GoogleCloudYoutubeI18nRegionSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeI18nRegionSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeI18nRegionListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of regions where YouTube is available. In this map, the i18n region ID is the map key, and its value is the corresponding i18nRegion resource. */
   public var items: [GoogleCloudYoutubeI18nRegion]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#i18nRegionListResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeI18nRegion]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeI18nRegionSnippet : GoogleCloudModel {
   /*The region code as a 2-letter ISO country code. */
   public var gl: String?
   /*The human-readable name of the region. */
   public var name: String?
   public init(gl:String?, name:String?) {
      self.gl = gl
      self.name = name
   }
}
public struct GoogleCloudYoutubeImageSettings : GoogleCloudModel {
   /*The URL for the background image shown on the video watch page. The image should be 1200px by 615px, with a maximum file size of 128k. */
   public var backgroundImageUrl: GoogleCloudYoutubeLocalizedProperty?
   /*This is used only in update requests; if it's set, we use this URL to generate all of the above banner URLs. */
   public var bannerExternalUrl: String?
   /*Banner image. Desktop size (1060x175). */
   public var bannerImageUrl: String?
   /*Banner image. Mobile size high resolution (1440x395). */
   public var bannerMobileExtraHdImageUrl: String?
   /*Banner image. Mobile size high resolution (1280x360). */
   public var bannerMobileHdImageUrl: String?
   /*Banner image. Mobile size (640x175). */
   public var bannerMobileImageUrl: String?
   /*Banner image. Mobile size low resolution (320x88). */
   public var bannerMobileLowImageUrl: String?
   /*Banner image. Mobile size medium/high resolution (960x263). */
   public var bannerMobileMediumHdImageUrl: String?
   /*Banner image. Tablet size extra high resolution (2560x424). */
   public var bannerTabletExtraHdImageUrl: String?
   /*Banner image. Tablet size high resolution (2276x377). */
   public var bannerTabletHdImageUrl: String?
   /*Banner image. Tablet size (1707x283). */
   public var bannerTabletImageUrl: String?
   /*Banner image. Tablet size low resolution (1138x188). */
   public var bannerTabletLowImageUrl: String?
   /*Banner image. TV size high resolution (1920x1080). */
   public var bannerTvHighImageUrl: String?
   /*Banner image. TV size extra high resolution (2120x1192). */
   public var bannerTvImageUrl: String?
   /*Banner image. TV size low resolution (854x480). */
   public var bannerTvLowImageUrl: String?
   /*Banner image. TV size medium resolution (1280x720). */
   public var bannerTvMediumImageUrl: String?
   /*The image map script for the large banner image. */
   public var largeBrandedBannerImageImapScript: GoogleCloudYoutubeLocalizedProperty?
   /*The URL for the 854px by 70px image that appears below the video player in the expanded video view of the video watch page. */
   public var largeBrandedBannerImageUrl: GoogleCloudYoutubeLocalizedProperty?
   /*The image map script for the small banner image. */
   public var smallBrandedBannerImageImapScript: GoogleCloudYoutubeLocalizedProperty?
   /*The URL for the 640px by 70px banner image that appears below the video player in the default view of the video watch page. */
   public var smallBrandedBannerImageUrl: GoogleCloudYoutubeLocalizedProperty?
   /*The URL for a 1px by 1px tracking pixel that can be used to collect statistics for views of the channel or video pages. */
   public var trackingImageUrl: String?
   /*The URL for the image that appears above the top-left corner of the video player. This is a 25-pixel-high image with a flexible width that cannot exceed 170 pixels. */
   public var watchIconImageUrl: String?
   public init(backgroundImageUrl:GoogleCloudYoutubeLocalizedProperty?, bannerExternalUrl:String?, bannerImageUrl:String?, bannerMobileExtraHdImageUrl:String?, bannerMobileHdImageUrl:String?, bannerMobileImageUrl:String?, bannerMobileLowImageUrl:String?, bannerMobileMediumHdImageUrl:String?, bannerTabletExtraHdImageUrl:String?, bannerTabletHdImageUrl:String?, bannerTabletImageUrl:String?, bannerTabletLowImageUrl:String?, bannerTvHighImageUrl:String?, bannerTvImageUrl:String?, bannerTvLowImageUrl:String?, bannerTvMediumImageUrl:String?, largeBrandedBannerImageImapScript:GoogleCloudYoutubeLocalizedProperty?, largeBrandedBannerImageUrl:GoogleCloudYoutubeLocalizedProperty?, smallBrandedBannerImageImapScript:GoogleCloudYoutubeLocalizedProperty?, smallBrandedBannerImageUrl:GoogleCloudYoutubeLocalizedProperty?, trackingImageUrl:String?, watchIconImageUrl:String?) {
      self.backgroundImageUrl = backgroundImageUrl
      self.bannerExternalUrl = bannerExternalUrl
      self.bannerImageUrl = bannerImageUrl
      self.bannerMobileExtraHdImageUrl = bannerMobileExtraHdImageUrl
      self.bannerMobileHdImageUrl = bannerMobileHdImageUrl
      self.bannerMobileImageUrl = bannerMobileImageUrl
      self.bannerMobileLowImageUrl = bannerMobileLowImageUrl
      self.bannerMobileMediumHdImageUrl = bannerMobileMediumHdImageUrl
      self.bannerTabletExtraHdImageUrl = bannerTabletExtraHdImageUrl
      self.bannerTabletHdImageUrl = bannerTabletHdImageUrl
      self.bannerTabletImageUrl = bannerTabletImageUrl
      self.bannerTabletLowImageUrl = bannerTabletLowImageUrl
      self.bannerTvHighImageUrl = bannerTvHighImageUrl
      self.bannerTvImageUrl = bannerTvImageUrl
      self.bannerTvLowImageUrl = bannerTvLowImageUrl
      self.bannerTvMediumImageUrl = bannerTvMediumImageUrl
      self.largeBrandedBannerImageImapScript = largeBrandedBannerImageImapScript
      self.largeBrandedBannerImageUrl = largeBrandedBannerImageUrl
      self.smallBrandedBannerImageImapScript = smallBrandedBannerImageImapScript
      self.smallBrandedBannerImageUrl = smallBrandedBannerImageUrl
      self.trackingImageUrl = trackingImageUrl
      self.watchIconImageUrl = watchIconImageUrl
   }
}
public struct GoogleCloudYoutubeIngestionInfo : GoogleCloudModel {
   /*The backup ingestion URL that you should use to stream video to YouTube. You have the option of simultaneously streaming the content that you are sending to the ingestionAddress to this URL. */
   public var backupIngestionAddress: String?
   /*The primary ingestion URL that you should use to stream video to YouTube. You must stream video to this URL.

Depending on which application or tool you use to encode your video stream, you may need to enter the stream URL and stream name separately or you may need to concatenate them in the following format:

STREAM_URL/STREAM_NAME */
   public var ingestionAddress: String?
   /*The HTTP or RTMP stream name that YouTube assigns to the video stream. */
   public var streamName: String?
   public init(backupIngestionAddress:String?, ingestionAddress:String?, streamName:String?) {
      self.backupIngestionAddress = backupIngestionAddress
      self.ingestionAddress = ingestionAddress
      self.streamName = streamName
   }
}
public struct GoogleCloudYoutubeInvideoBranding : GoogleCloudModel {
   @CodingUses<Coder> public var imageBytes: Data?
   public var imageUrl: String?
   public var position: GoogleCloudYoutubeInvideoPosition?
   public var targetChannelId: String?
   public var timing: GoogleCloudYoutubeInvideoTiming?
   public init(imageBytes:Data?, imageUrl:String?, position:GoogleCloudYoutubeInvideoPosition?, targetChannelId:String?, timing:GoogleCloudYoutubeInvideoTiming?) {
      self.imageBytes = imageBytes
      self.imageUrl = imageUrl
      self.position = position
      self.targetChannelId = targetChannelId
      self.timing = timing
   }
}
public struct GoogleCloudYoutubeInvideoPosition : GoogleCloudModel {
   /*Describes in which corner of the video the visual widget will appear. */
   public var cornerPosition: String?
   /*Defines the position type. */
   public var type: String?
   public init(cornerPosition:String?, type:String?) {
      self.cornerPosition = cornerPosition
      self.type = type
   }
}
public struct GoogleCloudYoutubeInvideoPromotion : GoogleCloudModel {
   /*The default temporal position within the video where the promoted item will be displayed. Can be overriden by more specific timing in the item. */
   public var defaultTiming: GoogleCloudYoutubeInvideoTiming?
   /*List of promoted items in decreasing priority. */
   public var items: [GoogleCloudYoutubePromotedItem]?
   /*The spatial position within the video where the promoted item will be displayed. */
   public var position: GoogleCloudYoutubeInvideoPosition?
   /*Indicates whether the channel's promotional campaign uses "smart timing." This feature attempts to show promotions at a point in the video when they are more likely to be clicked and less likely to disrupt the viewing experience. This feature also picks up a single promotion to show on each video. */
   public var useSmartTiming: Bool?
   public init(defaultTiming:GoogleCloudYoutubeInvideoTiming?, items:[GoogleCloudYoutubePromotedItem]?, position:GoogleCloudYoutubeInvideoPosition?, useSmartTiming:Bool?) {
      self.defaultTiming = defaultTiming
      self.items = items
      self.position = position
      self.useSmartTiming = useSmartTiming
   }
}
public struct GoogleCloudYoutubeInvideoTiming : GoogleCloudModel {
   /*Defines the duration in milliseconds for which the promotion should be displayed. If missing, the client should use the default. */
   @CodingUses<Coder> public var durationMs: UInt?
   /*Defines the time at which the promotion will appear. Depending on the value of type the value of the offsetMs field will represent a time offset from the start or from the end of the video, expressed in milliseconds. */
   @CodingUses<Coder> public var offsetMs: UInt?
   /*Describes a timing type. If the value is offsetFromStart, then the offsetMs field represents an offset from the start of the video. If the value is offsetFromEnd, then the offsetMs field represents an offset from the end of the video. */
   public var type: String?
   public init(durationMs:UInt?, offsetMs:UInt?, type:String?) {
      self.durationMs = durationMs
      self.offsetMs = offsetMs
      self.type = type
   }
}
public struct GoogleCloudYoutubeLanguageTag : GoogleCloudModel {
   public var value: String?
   public init(value:String?) {
      self.value = value
   }
}
public struct GoogleCloudYoutubeLevelDetails : GoogleCloudModel {
   public var displayName: String?
   public init(displayName:String?) {
      self.displayName = displayName
   }
}
public struct GoogleCloudYoutubeLiveBroadcast : GoogleCloudModel {
   /*The contentDetails object contains information about the event's video content, such as whether the content can be shown in an embedded video player or if it will be archived and therefore available for viewing after the event has concluded. */
   public var contentDetails: GoogleCloudYoutubeLiveBroadcastContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube assigns to uniquely identify the broadcast. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveBroadcast". */
   public var kind: String?
   /*The snippet object contains basic details about the event, including its title, description, start time, and end time. */
   public var snippet: GoogleCloudYoutubeLiveBroadcastSnippet?
   /*The statistics object contains info about the event's current stats. These include concurrent viewers and total chat count. Statistics can change (in either direction) during the lifetime of an event. Statistics are only returned while the event is live. */
   public var statistics: GoogleCloudYoutubeLiveBroadcastStatistics?
   /*The status object contains information about the event's status. */
   public var status: GoogleCloudYoutubeLiveBroadcastStatus?
   public init(contentDetails:GoogleCloudYoutubeLiveBroadcastContentDetails?, etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeLiveBroadcastSnippet?, statistics:GoogleCloudYoutubeLiveBroadcastStatistics?, status:GoogleCloudYoutubeLiveBroadcastStatus?) {
      self.contentDetails = contentDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
      self.statistics = statistics
      self.status = status
   }
}
public struct GoogleCloudYoutubeLiveBroadcastContentDetails : GoogleCloudModel {
   /*This value uniquely identifies the live stream bound to the broadcast. */
   public var boundStreamId: String?
   /*The date and time that the live stream referenced by boundStreamId was last updated. */
   @CodingUses<Coder> public var boundStreamLastUpdateTimeMs: String?
   public var closedCaptionsType: String?
   /*This setting indicates whether auto start is enabled for this broadcast. */
   public var enableAutoStart: Bool?
   /*This setting indicates whether HTTP POST closed captioning is enabled for this broadcast. The ingestion URL of the closed captions is returned through the liveStreams API. This is mutually exclusive with using the closed_captions_type property, and is equivalent to setting closed_captions_type to CLOSED_CAPTIONS_HTTP_POST. */
   public var enableClosedCaptions: Bool?
   /*This setting indicates whether YouTube should enable content encryption for the broadcast. */
   public var enableContentEncryption: Bool?
   /*This setting determines whether viewers can access DVR controls while watching the video. DVR controls enable the viewer to control the video playback experience by pausing, rewinding, or fast forwarding content. The default value for this property is true.



Important: You must set the value to true and also set the enableArchive property's value to true if you want to make playback available immediately after the broadcast ends. */
   public var enableDvr: Bool?
   /*This setting indicates whether the broadcast video can be played in an embedded player. If you choose to archive the video (using the enableArchive property), this setting will also apply to the archived video. */
   public var enableEmbed: Bool?
   /*Indicates whether this broadcast has low latency enabled. */
   public var enableLowLatency: Bool?
   /*If both this and enable_low_latency are set, they must match. LATENCY_NORMAL should match enable_low_latency=false LATENCY_LOW should match enable_low_latency=true LATENCY_ULTRA_LOW should have enable_low_latency omitted. */
   public var latencyPreference: String?
   @CodingUses<Coder> public var mesh: Data?
   /*The monitorStream object contains information about the monitor stream, which the broadcaster can use to review the event content before the broadcast stream is shown publicly. */
   public var monitorStream: GoogleCloudYoutubeMonitorStreamInfo?
   /*The projection format of this broadcast. This defaults to rectangular. */
   public var projection: String?
   /*Automatically start recording after the event goes live. The default value for this property is true.



Important: You must also set the enableDvr property's value to true if you want the playback to be available immediately after the broadcast ends. If you set this property's value to true but do not also set the enableDvr property to true, there may be a delay of around one day before the archived video will be available for playback. */
   public var recordFromStart: Bool?
   /*This setting indicates whether the broadcast should automatically begin with an in-stream slate when you update the broadcast's status to live. After updating the status, you then need to send a liveCuepoints.insert request that sets the cuepoint's eventState to end to remove the in-stream slate and make your broadcast stream visible to viewers. */
   public var startWithSlate: Bool?
   public var stereoLayout: String?
   public init(boundStreamId:String?, boundStreamLastUpdateTimeMs:String?, closedCaptionsType:String?, enableAutoStart:Bool?, enableClosedCaptions:Bool?, enableContentEncryption:Bool?, enableDvr:Bool?, enableEmbed:Bool?, enableLowLatency:Bool?, latencyPreference:String?, mesh:Data?, monitorStream:GoogleCloudYoutubeMonitorStreamInfo?, projection:String?, recordFromStart:Bool?, startWithSlate:Bool?, stereoLayout:String?) {
      self.boundStreamId = boundStreamId
      self.boundStreamLastUpdateTimeMs = boundStreamLastUpdateTimeMs
      self.closedCaptionsType = closedCaptionsType
      self.enableAutoStart = enableAutoStart
      self.enableClosedCaptions = enableClosedCaptions
      self.enableContentEncryption = enableContentEncryption
      self.enableDvr = enableDvr
      self.enableEmbed = enableEmbed
      self.enableLowLatency = enableLowLatency
      self.latencyPreference = latencyPreference
      self.mesh = mesh
      self.monitorStream = monitorStream
      self.projection = projection
      self.recordFromStart = recordFromStart
      self.startWithSlate = startWithSlate
      self.stereoLayout = stereoLayout
   }
}
public struct GoogleCloudYoutubeLiveBroadcastListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of broadcasts that match the request criteria. */
   public var items: [GoogleCloudYoutubeLiveBroadcast]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveBroadcastListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeLiveBroadcast]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeLiveBroadcastSnippet : GoogleCloudModel {
   /*The date and time that the broadcast actually ended. This information is only available once the broadcast's state is complete. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var actualEndTime: String?
   /*The date and time that the broadcast actually started. This information is only available once the broadcast's state is live. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var actualStartTime: String?
   public var broadcastType: String?
   /*The ID that YouTube uses to uniquely identify the channel that is publishing the broadcast. */
   public var channelId: String?
   /*The broadcast's description. As with the title, you can set this field by modifying the broadcast resource or by setting the description field of the corresponding video resource. */
   public var description: String?
   public var isDefaultBroadcast: Bool?
   /*The id of the live chat for this broadcast. */
   public var liveChatId: String?
   /*The date and time that the broadcast was added to YouTube's live broadcast schedule. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*The date and time that the broadcast is scheduled to end. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var scheduledEndTime: String?
   /*The date and time that the broadcast is scheduled to start. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var scheduledStartTime: String?
   /*A map of thumbnail images associated with the broadcast. For each nested object in this object, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The broadcast's title. Note that the broadcast represents exactly one YouTube video. You can set this field by modifying the broadcast resource or by setting the title field of the corresponding video resource. */
   public var title: String?
   public init(actualEndTime:String?, actualStartTime:String?, broadcastType:String?, channelId:String?, description:String?, isDefaultBroadcast:Bool?, liveChatId:String?, publishedAt:String?, scheduledEndTime:String?, scheduledStartTime:String?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.actualEndTime = actualEndTime
      self.actualStartTime = actualStartTime
      self.broadcastType = broadcastType
      self.channelId = channelId
      self.description = description
      self.isDefaultBroadcast = isDefaultBroadcast
      self.liveChatId = liveChatId
      self.publishedAt = publishedAt
      self.scheduledEndTime = scheduledEndTime
      self.scheduledStartTime = scheduledStartTime
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubeLiveBroadcastStatistics : GoogleCloudModel {
   /*The number of viewers currently watching the broadcast. The property and its value will be present if the broadcast has current viewers and the broadcast owner has not hidden the viewcount for the video. Note that YouTube stops tracking the number of concurrent viewers for a broadcast when the broadcast ends. So, this property would not identify the number of viewers watching an archived video of a live broadcast that already ended. */
   @CodingUses<Coder> public var concurrentViewers: UInt?
   /*The total number of live chat messages currently on the broadcast. The property and its value will be present if the broadcast is public, has the live chat feature enabled, and has at least one message. Note that this field will not be filled after the broadcast ends. So this property would not identify the number of chat messages for an archived video of a completed live broadcast. */
   @CodingUses<Coder> public var totalChatCount: UInt?
   public init(concurrentViewers:UInt?, totalChatCount:UInt?) {
      self.concurrentViewers = concurrentViewers
      self.totalChatCount = totalChatCount
   }
}
public struct GoogleCloudYoutubeLiveBroadcastStatus : GoogleCloudModel {
   /*The broadcast's status. The status can be updated using the API's liveBroadcasts.transition method. */
   public var lifeCycleStatus: String?
   /*Priority of the live broadcast event (internal state). */
   public var liveBroadcastPriority: String?
   public var madeForKids: Bool?
   /*The broadcast's privacy status. Note that the broadcast represents exactly one YouTube video, so the privacy settings are identical to those supported for videos. In addition, you can set this field by modifying the broadcast resource or by setting the privacyStatus field of the corresponding video resource. */
   public var privacyStatus: String?
   /*The broadcast's recording status. */
   public var recordingStatus: String?
   public var selfDeclaredMadeForKids: Bool?
   public init(lifeCycleStatus:String?, liveBroadcastPriority:String?, madeForKids:Bool?, privacyStatus:String?, recordingStatus:String?, selfDeclaredMadeForKids:Bool?) {
      self.lifeCycleStatus = lifeCycleStatus
      self.liveBroadcastPriority = liveBroadcastPriority
      self.madeForKids = madeForKids
      self.privacyStatus = privacyStatus
      self.recordingStatus = recordingStatus
      self.selfDeclaredMadeForKids = selfDeclaredMadeForKids
   }
}
public struct GoogleCloudYoutubeLiveChatBan : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube assigns to uniquely identify the ban. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveChatBan". */
   public var kind: String?
   /*The snippet object contains basic details about the ban. */
   public var snippet: GoogleCloudYoutubeLiveChatBanSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeLiveChatBanSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeLiveChatBanSnippet : GoogleCloudModel {
   /*The duration of a ban, only filled if the ban has type TEMPORARY. */
   @CodingUses<Coder> public var banDurationSeconds: UInt?
   public var bannedUserDetails: GoogleCloudYoutubeChannelProfileDetails?
   /*The chat this ban is pertinent to. */
   public var liveChatId: String?
   /*The type of ban. */
   public var type: String?
   public init(banDurationSeconds:UInt?, bannedUserDetails:GoogleCloudYoutubeChannelProfileDetails?, liveChatId:String?, type:String?) {
      self.banDurationSeconds = banDurationSeconds
      self.bannedUserDetails = bannedUserDetails
      self.liveChatId = liveChatId
      self.type = type
   }
}
public struct GoogleCloudYoutubeLiveChatFanFundingEventDetails : GoogleCloudModel {
   /*A rendered string that displays the fund amount and currency to the user. */
   public var amountDisplayString: String?
   /*The amount of the fund. */
   @CodingUses<Coder> public var amountMicros: UInt?
   /*The currency in which the fund was made. */
   public var currency: String?
   /*The comment added by the user to this fan funding event. */
   public var userComment: String?
   public init(amountDisplayString:String?, amountMicros:UInt?, currency:String?, userComment:String?) {
      self.amountDisplayString = amountDisplayString
      self.amountMicros = amountMicros
      self.currency = currency
      self.userComment = userComment
   }
}
public struct GoogleCloudYoutubeLiveChatMessage : GoogleCloudModel {
   /*The authorDetails object contains basic details about the user that posted this message. */
   public var authorDetails: GoogleCloudYoutubeLiveChatMessageAuthorDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube assigns to uniquely identify the message. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveChatMessage". */
   public var kind: String?
   /*The snippet object contains basic details about the message. */
   public var snippet: GoogleCloudYoutubeLiveChatMessageSnippet?
   public init(authorDetails:GoogleCloudYoutubeLiveChatMessageAuthorDetails?, etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeLiveChatMessageSnippet?) {
      self.authorDetails = authorDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeLiveChatMessageAuthorDetails : GoogleCloudModel {
   /*The YouTube channel ID. */
   public var channelId: String?
   /*The channel's URL. */
   public var channelUrl: String?
   /*The channel's display name. */
   public var displayName: String?
   /*Whether the author is a moderator of the live chat. */
   public var isChatModerator: Bool?
   /*Whether the author is the owner of the live chat. */
   public var isChatOwner: Bool?
   /*Whether the author is a sponsor of the live chat. */
   public var isChatSponsor: Bool?
   /*Whether the author's identity has been verified by YouTube. */
   public var isVerified: Bool?
   /*The channels's avatar URL. */
   public var profileImageUrl: String?
   public init(channelId:String?, channelUrl:String?, displayName:String?, isChatModerator:Bool?, isChatOwner:Bool?, isChatSponsor:Bool?, isVerified:Bool?, profileImageUrl:String?) {
      self.channelId = channelId
      self.channelUrl = channelUrl
      self.displayName = displayName
      self.isChatModerator = isChatModerator
      self.isChatOwner = isChatOwner
      self.isChatSponsor = isChatSponsor
      self.isVerified = isVerified
      self.profileImageUrl = profileImageUrl
   }
}
public struct GoogleCloudYoutubeLiveChatMessageDeletedDetails : GoogleCloudModel {
   public var deletedMessageId: String?
   public init(deletedMessageId:String?) {
      self.deletedMessageId = deletedMessageId
   }
}
public struct GoogleCloudYoutubeLiveChatMessageListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of live chat messages. */
   public var items: [GoogleCloudYoutubeLiveChatMessage]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveChatMessageListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   /*The date and time when the underlying stream went offline. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var offlineAt: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The amount of time the client should wait before polling again. */
   @CodingUses<Coder> public var pollingIntervalMillis: UInt?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeLiveChatMessage]?, kind:String?, nextPageToken:String?, offlineAt:String?, pageInfo:GoogleCloudYoutubePageInfo?, pollingIntervalMillis:UInt?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.offlineAt = offlineAt
      self.pageInfo = pageInfo
      self.pollingIntervalMillis = pollingIntervalMillis
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeLiveChatMessageRetractedDetails : GoogleCloudModel {
   public var retractedMessageId: String?
   public init(retractedMessageId:String?) {
      self.retractedMessageId = retractedMessageId
   }
}
public struct GoogleCloudYoutubeLiveChatMessageSnippet : GoogleCloudModel {
   /*The ID of the user that authored this message, this field is not always filled. textMessageEvent - the user that wrote the message fanFundingEvent - the user that funded the broadcast newSponsorEvent - the user that just became a sponsor messageDeletedEvent - the moderator that took the action messageRetractedEvent - the author that retracted their message userBannedEvent - the moderator that took the action superChatEvent - the user that made the purchase */
   public var authorChannelId: String?
   /*Contains a string that can be displayed to the user. If this field is not present the message is silent, at the moment only messages of type TOMBSTONE and CHAT_ENDED_EVENT are silent. */
   public var displayMessage: String?
   /*Details about the funding event, this is only set if the type is 'fanFundingEvent'. */
   public var fanFundingEventDetails: GoogleCloudYoutubeLiveChatFanFundingEventDetails?
   /*Whether the message has display content that should be displayed to users. */
   public var hasDisplayContent: Bool?
   public var liveChatId: String?
   public var messageDeletedDetails: GoogleCloudYoutubeLiveChatMessageDeletedDetails?
   public var messageRetractedDetails: GoogleCloudYoutubeLiveChatMessageRetractedDetails?
   public var pollClosedDetails: GoogleCloudYoutubeLiveChatPollClosedDetails?
   public var pollEditedDetails: GoogleCloudYoutubeLiveChatPollEditedDetails?
   public var pollOpenedDetails: GoogleCloudYoutubeLiveChatPollOpenedDetails?
   public var pollVotedDetails: GoogleCloudYoutubeLiveChatPollVotedDetails?
   /*The date and time when the message was orignally published. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*Details about the Super Chat event, this is only set if the type is 'superChatEvent'. */
   public var superChatDetails: GoogleCloudYoutubeLiveChatSuperChatDetails?
   /*Details about the Super Sticker event, this is only set if the type is 'superStickerEvent'. */
   public var superStickerDetails: GoogleCloudYoutubeLiveChatSuperStickerDetails?
   /*Details about the text message, this is only set if the type is 'textMessageEvent'. */
   public var textMessageDetails: GoogleCloudYoutubeLiveChatTextMessageDetails?
   /*The type of message, this will always be present, it determines the contents of the message as well as which fields will be present. */
   public var type: String?
   public var userBannedDetails: GoogleCloudYoutubeLiveChatUserBannedMessageDetails?
   public init(authorChannelId:String?, displayMessage:String?, fanFundingEventDetails:GoogleCloudYoutubeLiveChatFanFundingEventDetails?, hasDisplayContent:Bool?, liveChatId:String?, messageDeletedDetails:GoogleCloudYoutubeLiveChatMessageDeletedDetails?, messageRetractedDetails:GoogleCloudYoutubeLiveChatMessageRetractedDetails?, pollClosedDetails:GoogleCloudYoutubeLiveChatPollClosedDetails?, pollEditedDetails:GoogleCloudYoutubeLiveChatPollEditedDetails?, pollOpenedDetails:GoogleCloudYoutubeLiveChatPollOpenedDetails?, pollVotedDetails:GoogleCloudYoutubeLiveChatPollVotedDetails?, publishedAt:String?, superChatDetails:GoogleCloudYoutubeLiveChatSuperChatDetails?, superStickerDetails:GoogleCloudYoutubeLiveChatSuperStickerDetails?, textMessageDetails:GoogleCloudYoutubeLiveChatTextMessageDetails?, type:String?, userBannedDetails:GoogleCloudYoutubeLiveChatUserBannedMessageDetails?) {
      self.authorChannelId = authorChannelId
      self.displayMessage = displayMessage
      self.fanFundingEventDetails = fanFundingEventDetails
      self.hasDisplayContent = hasDisplayContent
      self.liveChatId = liveChatId
      self.messageDeletedDetails = messageDeletedDetails
      self.messageRetractedDetails = messageRetractedDetails
      self.pollClosedDetails = pollClosedDetails
      self.pollEditedDetails = pollEditedDetails
      self.pollOpenedDetails = pollOpenedDetails
      self.pollVotedDetails = pollVotedDetails
      self.publishedAt = publishedAt
      self.superChatDetails = superChatDetails
      self.superStickerDetails = superStickerDetails
      self.textMessageDetails = textMessageDetails
      self.type = type
      self.userBannedDetails = userBannedDetails
   }
}
public struct GoogleCloudYoutubeLiveChatModerator : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube assigns to uniquely identify the moderator. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveChatModerator". */
   public var kind: String?
   /*The snippet object contains basic details about the moderator. */
   public var snippet: GoogleCloudYoutubeLiveChatModeratorSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeLiveChatModeratorSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeLiveChatModeratorListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of moderators that match the request criteria. */
   public var items: [GoogleCloudYoutubeLiveChatModerator]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveChatModeratorListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeLiveChatModerator]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeLiveChatModeratorSnippet : GoogleCloudModel {
   /*The ID of the live chat this moderator can act on. */
   public var liveChatId: String?
   /*Details about the moderator. */
   public var moderatorDetails: GoogleCloudYoutubeChannelProfileDetails?
   public init(liveChatId:String?, moderatorDetails:GoogleCloudYoutubeChannelProfileDetails?) {
      self.liveChatId = liveChatId
      self.moderatorDetails = moderatorDetails
   }
}
public struct GoogleCloudYoutubeLiveChatPollClosedDetails : GoogleCloudModel {
   /*The id of the poll that was closed. */
   public var pollId: String?
   public init(pollId:String?) {
      self.pollId = pollId
   }
}
public struct GoogleCloudYoutubeLiveChatPollEditedDetails : GoogleCloudModel {
   public var id: String?
   public var items: [GoogleCloudYoutubeLiveChatPollItem]?
   public var prompt: String?
   public init(id:String?, items:[GoogleCloudYoutubeLiveChatPollItem]?, prompt:String?) {
      self.id = id
      self.items = items
      self.prompt = prompt
   }
}
public struct GoogleCloudYoutubeLiveChatPollItem : GoogleCloudModel {
   /*Plain text description of the item. */
   public var description: String?
   public var itemId: String?
   public init(description:String?, itemId:String?) {
      self.description = description
      self.itemId = itemId
   }
}
public struct GoogleCloudYoutubeLiveChatPollOpenedDetails : GoogleCloudModel {
   public var id: String?
   public var items: [GoogleCloudYoutubeLiveChatPollItem]?
   public var prompt: String?
   public init(id:String?, items:[GoogleCloudYoutubeLiveChatPollItem]?, prompt:String?) {
      self.id = id
      self.items = items
      self.prompt = prompt
   }
}
public struct GoogleCloudYoutubeLiveChatPollVotedDetails : GoogleCloudModel {
   /*The poll item the user chose. */
   public var itemId: String?
   /*The poll the user voted on. */
   public var pollId: String?
   public init(itemId:String?, pollId:String?) {
      self.itemId = itemId
      self.pollId = pollId
   }
}
public struct GoogleCloudYoutubeLiveChatSuperChatDetails : GoogleCloudModel {
   /*A rendered string that displays the fund amount and currency to the user. */
   public var amountDisplayString: String?
   /*The amount purchased by the user, in micros (1,750,000 micros = 1.75). */
   @CodingUses<Coder> public var amountMicros: UInt?
   /*The currency in which the purchase was made. */
   public var currency: String?
   /*The tier in which the amount belongs. Lower amounts belong to lower tiers. The lowest tier is 1. */
   @CodingUses<Coder> public var tier: UInt?
   /*The comment added by the user to this Super Chat event. */
   public var userComment: String?
   public init(amountDisplayString:String?, amountMicros:UInt?, currency:String?, tier:UInt?, userComment:String?) {
      self.amountDisplayString = amountDisplayString
      self.amountMicros = amountMicros
      self.currency = currency
      self.tier = tier
      self.userComment = userComment
   }
}
public struct GoogleCloudYoutubeLiveChatSuperStickerDetails : GoogleCloudModel {
   /*A rendered string that displays the fund amount and currency to the user. */
   public var amountDisplayString: String?
   /*The amount purchased by the user, in micros (1,750,000 micros = 1.75). */
   @CodingUses<Coder> public var amountMicros: UInt?
   /*The currency in which the purchase was made. */
   public var currency: String?
   /*Information about the Super Sticker. */
   public var superStickerMetadata: GoogleCloudYoutubeSuperStickerMetadata?
   /*The tier in which the amount belongs. Lower amounts belong to lower tiers. The lowest tier is 1. */
   @CodingUses<Coder> public var tier: UInt?
   public init(amountDisplayString:String?, amountMicros:UInt?, currency:String?, superStickerMetadata:GoogleCloudYoutubeSuperStickerMetadata?, tier:UInt?) {
      self.amountDisplayString = amountDisplayString
      self.amountMicros = amountMicros
      self.currency = currency
      self.superStickerMetadata = superStickerMetadata
      self.tier = tier
   }
}
public struct GoogleCloudYoutubeLiveChatTextMessageDetails : GoogleCloudModel {
   /*The user's message. */
   public var messageText: String?
   public init(messageText:String?) {
      self.messageText = messageText
   }
}
public struct GoogleCloudYoutubeLiveChatUserBannedMessageDetails : GoogleCloudModel {
   /*The duration of the ban. This property is only present if the banType is temporary. */
   @CodingUses<Coder> public var banDurationSeconds: UInt?
   /*The type of ban. */
   public var banType: String?
   /*The details of the user that was banned. */
   public var bannedUserDetails: GoogleCloudYoutubeChannelProfileDetails?
   public init(banDurationSeconds:UInt?, banType:String?, bannedUserDetails:GoogleCloudYoutubeChannelProfileDetails?) {
      self.banDurationSeconds = banDurationSeconds
      self.banType = banType
      self.bannedUserDetails = bannedUserDetails
   }
}
public struct GoogleCloudYoutubeLiveStream : GoogleCloudModel {
   /*The cdn object defines the live stream's content delivery network (CDN) settings. These settings provide details about the manner in which you stream your content to YouTube. */
   public var cdn: GoogleCloudYoutubeCdnSettings?
   /*The content_details object contains information about the stream, including the closed captions ingestion URL. */
   public var contentDetails: GoogleCloudYoutubeLiveStreamContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube assigns to uniquely identify the stream. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveStream". */
   public var kind: String?
   /*The snippet object contains basic details about the stream, including its channel, title, and description. */
   public var snippet: GoogleCloudYoutubeLiveStreamSnippet?
   /*The status object contains information about live stream's status. */
   public var status: GoogleCloudYoutubeLiveStreamStatus?
   public init(cdn:GoogleCloudYoutubeCdnSettings?, contentDetails:GoogleCloudYoutubeLiveStreamContentDetails?, etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeLiveStreamSnippet?, status:GoogleCloudYoutubeLiveStreamStatus?) {
      self.cdn = cdn
      self.contentDetails = contentDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
      self.status = status
   }
}
public struct GoogleCloudYoutubeLiveStreamConfigurationIssue : GoogleCloudModel {
   /*The long-form description of the issue and how to resolve it. */
   public var description: String?
   /*The short-form reason for this issue. */
   public var reason: String?
   /*How severe this issue is to the stream. */
   public var severity: String?
   /*The kind of error happening. */
   public var type: String?
   public init(description:String?, reason:String?, severity:String?, type:String?) {
      self.description = description
      self.reason = reason
      self.severity = severity
      self.type = type
   }
}
public struct GoogleCloudYoutubeLiveStreamContentDetails : GoogleCloudModel {
   /*The ingestion URL where the closed captions of this stream are sent. */
   public var closedCaptionsIngestionUrl: String?
   /*Indicates whether the stream is reusable, which means that it can be bound to multiple broadcasts. It is common for broadcasters to reuse the same stream for many different broadcasts if those broadcasts occur at different times.

If you set this value to false, then the stream will not be reusable, which means that it can only be bound to one broadcast. Non-reusable streams differ from reusable streams in the following ways:  
- A non-reusable stream can only be bound to one broadcast. 
- A non-reusable stream might be deleted by an automated process after the broadcast ends. 
- The  liveStreams.list method does not list non-reusable streams if you call the method and set the mine parameter to true. The only way to use that method to retrieve the resource for a non-reusable stream is to use the id parameter to identify the stream. */
   public var isReusable: Bool?
   public init(closedCaptionsIngestionUrl:String?, isReusable:Bool?) {
      self.closedCaptionsIngestionUrl = closedCaptionsIngestionUrl
      self.isReusable = isReusable
   }
}
public struct GoogleCloudYoutubeLiveStreamHealthStatus : GoogleCloudModel {
   /*The configurations issues on this stream */
   public var configurationIssues: [GoogleCloudYoutubeLiveStreamConfigurationIssue]?
   /*The last time this status was updated (in seconds) */
   @CodingUses<Coder> public var lastUpdateTimeSeconds: UInt?
   /*The status code of this stream */
   public var status: String?
   public init(configurationIssues:[GoogleCloudYoutubeLiveStreamConfigurationIssue]?, lastUpdateTimeSeconds:UInt?, status:String?) {
      self.configurationIssues = configurationIssues
      self.lastUpdateTimeSeconds = lastUpdateTimeSeconds
      self.status = status
   }
}
public struct GoogleCloudYoutubeLiveStreamListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of live streams that match the request criteria. */
   public var items: [GoogleCloudYoutubeLiveStream]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#liveStreamListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeLiveStream]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeLiveStreamSnippet : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the channel that is transmitting the stream. */
   public var channelId: String?
   /*The stream's description. The value cannot be longer than 10000 characters. */
   public var description: String?
   public var isDefaultStream: Bool?
   /*The date and time that the stream was created. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*The stream's title. The value must be between 1 and 128 characters long. */
   public var title: String?
   public init(channelId:String?, description:String?, isDefaultStream:Bool?, publishedAt:String?, title:String?) {
      self.channelId = channelId
      self.description = description
      self.isDefaultStream = isDefaultStream
      self.publishedAt = publishedAt
      self.title = title
   }
}
public struct GoogleCloudYoutubeLiveStreamStatus : GoogleCloudModel {
   /*The health status of the stream. */
   public var healthStatus: GoogleCloudYoutubeLiveStreamHealthStatus?
   public var streamStatus: String?
   public init(healthStatus:GoogleCloudYoutubeLiveStreamHealthStatus?, streamStatus:String?) {
      self.healthStatus = healthStatus
      self.streamStatus = streamStatus
   }
}
public struct GoogleCloudYoutubeLocalizedProperty : GoogleCloudModel {
   public var `default`: String?
   /*The language of the default property. */
   public var defaultLanguage: GoogleCloudYoutubeLanguageTag?
   public var localized: [GoogleCloudYoutubeLocalizedString]?
   public init(`default`:String?, defaultLanguage:GoogleCloudYoutubeLanguageTag?, localized:[GoogleCloudYoutubeLocalizedString]?) {
      self.`default` = `default`
      self.defaultLanguage = defaultLanguage
      self.localized = localized
   }
}
public struct GoogleCloudYoutubeLocalizedString : GoogleCloudModel {
   public var language: String?
   public var value: String?
   public init(language:String?, value:String?) {
      self.language = language
      self.value = value
   }
}
public struct GoogleCloudYoutubeMember : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#member". */
   public var kind: String?
   /*The snippet object contains basic details about the member. */
   public var snippet: GoogleCloudYoutubeMemberSnippet?
   public init(etag:String?, kind:String?, snippet:GoogleCloudYoutubeMemberSnippet?) {
      self.etag = etag
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeMemberListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of members that match the request criteria. */
   public var items: [GoogleCloudYoutubeMember]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#memberListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeMember]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeMemberSnippet : GoogleCloudModel {
   /*The id of the channel that's offering memberships. */
   public var creatorChannelId: String?
   /*Details about the member. */
   public var memberDetails: GoogleCloudYoutubeChannelProfileDetails?
   /*Details about the user's membership. */
   public var membershipsDetails: GoogleCloudYoutubeMembershipsDetails?
   public init(creatorChannelId:String?, memberDetails:GoogleCloudYoutubeChannelProfileDetails?, membershipsDetails:GoogleCloudYoutubeMembershipsDetails?) {
      self.creatorChannelId = creatorChannelId
      self.memberDetails = memberDetails
      self.membershipsDetails = membershipsDetails
   }
}
public struct GoogleCloudYoutubeMembershipsDetails : GoogleCloudModel {
   /*All levels that the user has access to. This includes the currently active level and all other levels that are included because of a higher purchase. */
   public var accessibleLevels: [String]?
   /*The highest level that the user has access to at the moment. */
   public var highestAccessibleLevel: String?
   /*Display name for the highest level that the user has access to at the moment. */
   public var highestAccessibleLevelDisplayName: String?
   /*The date and time when the user became a continuous member across all levels. */
   public var memberSince: String?
   /*The date and time when the user started to continuously have access to the currently highest level. */
   public var memberSinceCurrentLevel: String?
   /*The cumulative time the user has been a member across all levels in complete months (the time is rounded down to the nearest integer). */
   @CodingUses<Coder> public var memberTotalDuration: Int?
   /*The cumulative time the user has had access to the currently highest level in complete months (the time is rounded down to the nearest integer). */
   @CodingUses<Coder> public var memberTotalDurationCurrentLevel: Int?
   /*The highest level that the user has access to at the moment. DEPRECATED - highest_accessible_level should be used instead. This will be removed after we make sure there are no 3rd parties relying on it. */
   public var purchasedLevel: String?
   public init(accessibleLevels:[String]?, highestAccessibleLevel:String?, highestAccessibleLevelDisplayName:String?, memberSince:String?, memberSinceCurrentLevel:String?, memberTotalDuration:Int?, memberTotalDurationCurrentLevel:Int?, purchasedLevel:String?) {
      self.accessibleLevels = accessibleLevels
      self.highestAccessibleLevel = highestAccessibleLevel
      self.highestAccessibleLevelDisplayName = highestAccessibleLevelDisplayName
      self.memberSince = memberSince
      self.memberSinceCurrentLevel = memberSinceCurrentLevel
      self.memberTotalDuration = memberTotalDuration
      self.memberTotalDurationCurrentLevel = memberTotalDurationCurrentLevel
      self.purchasedLevel = purchasedLevel
   }
}
public struct GoogleCloudYoutubeMembershipsLevel : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube assigns to uniquely identify the memberships level. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#membershipsLevel". */
   public var kind: String?
   /*The snippet object contains basic details about the level. */
   public var snippet: GoogleCloudYoutubeMembershipsLevelSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeMembershipsLevelSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeMembershipsLevelListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of pricing levels offered by a creator to the fans. */
   public var items: [GoogleCloudYoutubeMembershipsLevel]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#membershipsLevelListResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeMembershipsLevel]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeMembershipsLevelSnippet : GoogleCloudModel {
   /*The id of the channel that's offering channel memberships. */
   public var creatorChannelId: String?
   public var levelDetails: GoogleCloudYoutubeLevelDetails?
   public init(creatorChannelId:String?, levelDetails:GoogleCloudYoutubeLevelDetails?) {
      self.creatorChannelId = creatorChannelId
      self.levelDetails = levelDetails
   }
}
public struct GoogleCloudYoutubeMonitorStreamInfo : GoogleCloudModel {
   /*If you have set the enableMonitorStream property to true, then this property determines the length of the live broadcast delay. */
   @CodingUses<Coder> public var broadcastStreamDelayMs: UInt?
   /*HTML code that embeds a player that plays the monitor stream. */
   public var embedHtml: String?
   /*This value determines whether the monitor stream is enabled for the broadcast. If the monitor stream is enabled, then YouTube will broadcast the event content on a special stream intended only for the broadcaster's consumption. The broadcaster can use the stream to review the event content and also to identify the optimal times to insert cuepoints.

You need to set this value to true if you intend to have a broadcast delay for your event.

Note: This property cannot be updated once the broadcast is in the testing or live state. */
   public var enableMonitorStream: Bool?
   public init(broadcastStreamDelayMs:UInt?, embedHtml:String?, enableMonitorStream:Bool?) {
      self.broadcastStreamDelayMs = broadcastStreamDelayMs
      self.embedHtml = embedHtml
      self.enableMonitorStream = enableMonitorStream
   }
}
public struct GoogleCloudYoutubeNonprofit : GoogleCloudModel {
   /*Id of the nonprofit. */
   public var nonprofitId: GoogleCloudYoutubeNonprofitId?
   /*Legal name of the nonprofit. */
   public var nonprofitLegalName: String?
   public init(nonprofitId:GoogleCloudYoutubeNonprofitId?, nonprofitLegalName:String?) {
      self.nonprofitId = nonprofitId
      self.nonprofitLegalName = nonprofitLegalName
   }
}
public struct GoogleCloudYoutubeNonprofitId : GoogleCloudModel {
   public var value: String?
   public init(value:String?) {
      self.value = value
   }
}
public struct GoogleCloudYoutubePageInfo : GoogleCloudModel {
   /*The number of results included in the API response. */
   @CodingUses<Coder> public var resultsPerPage: Int?
   /*The total number of results in the result set. */
   @CodingUses<Coder> public var totalResults: Int?
   public init(resultsPerPage:Int?, totalResults:Int?) {
      self.resultsPerPage = resultsPerPage
      self.totalResults = totalResults
   }
}
public struct GoogleCloudYoutubePlaylist : GoogleCloudModel {
   /*The contentDetails object contains information like video count. */
   public var contentDetails: GoogleCloudYoutubePlaylistContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the playlist. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#playlist". */
   public var kind: String?
   /*Localizations for different languages */
   public var localizations: [String : GoogleCloudYoutubePlaylistLocalization]?
   /*The player object contains information that you would use to play the playlist in an embedded player. */
   public var player: GoogleCloudYoutubePlaylistPlayer?
   /*The snippet object contains basic details about the playlist, such as its title and description. */
   public var snippet: GoogleCloudYoutubePlaylistSnippet?
   /*The status object contains status information for the playlist. */
   public var status: GoogleCloudYoutubePlaylistStatus?
   public init(contentDetails:GoogleCloudYoutubePlaylistContentDetails?, etag:String?, id:String?, kind:String?, localizations:[String : GoogleCloudYoutubePlaylistLocalization]?, player:GoogleCloudYoutubePlaylistPlayer?, snippet:GoogleCloudYoutubePlaylistSnippet?, status:GoogleCloudYoutubePlaylistStatus?) {
      self.contentDetails = contentDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.localizations = localizations
      self.player = player
      self.snippet = snippet
      self.status = status
   }
}
public struct GoogleCloudYoutubePlaylistContentDetails : GoogleCloudModel {
   /*The number of videos in the playlist. */
   @CodingUses<Coder> public var itemCount: UInt?
   public init(itemCount:UInt?) {
      self.itemCount = itemCount
   }
}
public struct GoogleCloudYoutubePlaylistItem : GoogleCloudModel {
   /*The contentDetails object is included in the resource if the included item is a YouTube video. The object contains additional information about the video. */
   public var contentDetails: GoogleCloudYoutubePlaylistItemContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the playlist item. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#playlistItem". */
   public var kind: String?
   /*The snippet object contains basic details about the playlist item, such as its title and position in the playlist. */
   public var snippet: GoogleCloudYoutubePlaylistItemSnippet?
   /*The status object contains information about the playlist item's privacy status. */
   public var status: GoogleCloudYoutubePlaylistItemStatus?
   public init(contentDetails:GoogleCloudYoutubePlaylistItemContentDetails?, etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubePlaylistItemSnippet?, status:GoogleCloudYoutubePlaylistItemStatus?) {
      self.contentDetails = contentDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
      self.status = status
   }
}
public struct GoogleCloudYoutubePlaylistItemContentDetails : GoogleCloudModel {
   /*The time, measured in seconds from the start of the video, when the video should stop playing. (The playlist owner can specify the times when the video should start and stop playing when the video is played in the context of the playlist.) By default, assume that the video.endTime is the end of the video. */
   public var endAt: String?
   /*A user-generated note for this item. */
   public var note: String?
   /*The time, measured in seconds from the start of the video, when the video should start playing. (The playlist owner can specify the times when the video should start and stop playing when the video is played in the context of the playlist.) The default value is 0. */
   public var startAt: String?
   /*The ID that YouTube uses to uniquely identify a video. To retrieve the video resource, set the id query parameter to this value in your API request. */
   public var videoId: String?
   /*The date and time that the video was published to YouTube. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var videoPublishedAt: String?
   public init(endAt:String?, note:String?, startAt:String?, videoId:String?, videoPublishedAt:String?) {
      self.endAt = endAt
      self.note = note
      self.startAt = startAt
      self.videoId = videoId
      self.videoPublishedAt = videoPublishedAt
   }
}
public struct GoogleCloudYoutubePlaylistItemListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of playlist items that match the request criteria. */
   public var items: [GoogleCloudYoutubePlaylistItem]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#playlistItemListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubePlaylistItem]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubePlaylistItemSnippet : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the user that added the item to the playlist. */
   public var channelId: String?
   /*Channel title for the channel that the playlist item belongs to. */
   public var channelTitle: String?
   /*The item's description. */
   public var description: String?
   /*The ID that YouTube uses to uniquely identify the playlist that the playlist item is in. */
   public var playlistId: String?
   /*The order in which the item appears in the playlist. The value uses a zero-based index, so the first item has a position of 0, the second item has a position of 1, and so forth. */
   @CodingUses<Coder> public var position: UInt?
   /*The date and time that the item was added to the playlist. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*The id object contains information that can be used to uniquely identify the resource that is included in the playlist as the playlist item. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   /*A map of thumbnail images associated with the playlist item. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The item's title. */
   public var title: String?
   public init(channelId:String?, channelTitle:String?, description:String?, playlistId:String?, position:UInt?, publishedAt:String?, resourceId:GoogleCloudYoutubeResourceId?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.channelId = channelId
      self.channelTitle = channelTitle
      self.description = description
      self.playlistId = playlistId
      self.position = position
      self.publishedAt = publishedAt
      self.resourceId = resourceId
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubePlaylistItemStatus : GoogleCloudModel {
   /*This resource's privacy status. */
   public var privacyStatus: String?
   public init(privacyStatus:String?) {
      self.privacyStatus = privacyStatus
   }
}
public struct GoogleCloudYoutubePlaylistListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of playlists that match the request criteria. */
   public var items: [GoogleCloudYoutubePlaylist]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#playlistListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubePlaylist]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubePlaylistLocalization : GoogleCloudModel {
   /*The localized strings for playlist's description. */
   public var description: String?
   /*The localized strings for playlist's title. */
   public var title: String?
   public init(description:String?, title:String?) {
      self.description = description
      self.title = title
   }
}
public struct GoogleCloudYoutubePlaylistPlayer : GoogleCloudModel {
   /*An <iframe> tag that embeds a player that will play the playlist. */
   public var embedHtml: String?
   public init(embedHtml:String?) {
      self.embedHtml = embedHtml
   }
}
public struct GoogleCloudYoutubePlaylistSnippet : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the channel that published the playlist. */
   public var channelId: String?
   /*The channel title of the channel that the video belongs to. */
   public var channelTitle: String?
   /*The language of the playlist's default title and description. */
   public var defaultLanguage: String?
   /*The playlist's description. */
   public var description: String?
   /*Localized title and description, read-only. */
   public var localized: GoogleCloudYoutubePlaylistLocalization?
   /*The date and time that the playlist was created. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*Keyword tags associated with the playlist. */
   public var tags: [String]?
   /*A map of thumbnail images associated with the playlist. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The playlist's title. */
   public var title: String?
   public init(channelId:String?, channelTitle:String?, defaultLanguage:String?, description:String?, localized:GoogleCloudYoutubePlaylistLocalization?, publishedAt:String?, tags:[String]?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.channelId = channelId
      self.channelTitle = channelTitle
      self.defaultLanguage = defaultLanguage
      self.description = description
      self.localized = localized
      self.publishedAt = publishedAt
      self.tags = tags
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubePlaylistStatus : GoogleCloudModel {
   /*The playlist's privacy status. */
   public var privacyStatus: String?
   public init(privacyStatus:String?) {
      self.privacyStatus = privacyStatus
   }
}
public struct GoogleCloudYoutubePromotedItem : GoogleCloudModel {
   /*A custom message to display for this promotion. This field is currently ignored unless the promoted item is a website. */
   public var customMessage: String?
   /*Identifies the promoted item. */
   public var id: GoogleCloudYoutubePromotedItemId?
   /*If true, the content owner's name will be used when displaying the promotion. This field can only be set when the update is made on behalf of the content owner. */
   public var promotedByContentOwner: Bool?
   /*The temporal position within the video where the promoted item will be displayed. If present, it overrides the default timing. */
   public var timing: GoogleCloudYoutubeInvideoTiming?
   public init(customMessage:String?, id:GoogleCloudYoutubePromotedItemId?, promotedByContentOwner:Bool?, timing:GoogleCloudYoutubeInvideoTiming?) {
      self.customMessage = customMessage
      self.id = id
      self.promotedByContentOwner = promotedByContentOwner
      self.timing = timing
   }
}
public struct GoogleCloudYoutubePromotedItemId : GoogleCloudModel {
   /*If type is recentUpload, this field identifies the channel from which to take the recent upload. If missing, the channel is assumed to be the same channel for which the invideoPromotion is set. */
   public var recentlyUploadedBy: String?
   /*Describes the type of the promoted item. */
   public var type: String?
   /*If the promoted item represents a video, this field represents the unique YouTube ID identifying it. This field will be present only if type has the value video. */
   public var videoId: String?
   /*If the promoted item represents a website, this field represents the url pointing to the website. This field will be present only if type has the value website. */
   public var websiteUrl: String?
   public init(recentlyUploadedBy:String?, type:String?, videoId:String?, websiteUrl:String?) {
      self.recentlyUploadedBy = recentlyUploadedBy
      self.type = type
      self.videoId = videoId
      self.websiteUrl = websiteUrl
   }
}
public struct GoogleCloudYoutubePropertyValue : GoogleCloudModel {
   /*A property. */
   public var property: String?
   /*The property's value. */
   public var value: String?
   public init(property:String?, value:String?) {
      self.property = property
      self.value = value
   }
}
public struct GoogleCloudYoutubeResourceId : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the referred resource, if that resource is a channel. This property is only present if the resourceId.kind value is youtube#channel. */
   public var channelId: String?
   /*The type of the API resource. */
   public var kind: String?
   /*The ID that YouTube uses to uniquely identify the referred resource, if that resource is a playlist. This property is only present if the resourceId.kind value is youtube#playlist. */
   public var playlistId: String?
   /*The ID that YouTube uses to uniquely identify the referred resource, if that resource is a video. This property is only present if the resourceId.kind value is youtube#video. */
   public var videoId: String?
   public init(channelId:String?, kind:String?, playlistId:String?, videoId:String?) {
      self.channelId = channelId
      self.kind = kind
      self.playlistId = playlistId
      self.videoId = videoId
   }
}
public struct GoogleCloudYoutubeSearchListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of results that match the search criteria. */
   public var items: [GoogleCloudYoutubeSearchResult]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#searchListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var regionCode: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeSearchResult]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, regionCode:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.regionCode = regionCode
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeSearchResult : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The id object contains information that can be used to uniquely identify the resource that matches the search request. */
   public var id: GoogleCloudYoutubeResourceId?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#searchResult". */
   public var kind: String?
   /*The snippet object contains basic details about a search result, such as its title or description. For example, if the search result is a video, then the title will be the video's title and the description will be the video's description. */
   public var snippet: GoogleCloudYoutubeSearchResultSnippet?
   public init(etag:String?, id:GoogleCloudYoutubeResourceId?, kind:String?, snippet:GoogleCloudYoutubeSearchResultSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeSearchResultSnippet : GoogleCloudModel {
   /*The value that YouTube uses to uniquely identify the channel that published the resource that the search result identifies. */
   public var channelId: String?
   /*The title of the channel that published the resource that the search result identifies. */
   public var channelTitle: String?
   /*A description of the search result. */
   public var description: String?
   /*It indicates if the resource (video or channel) has upcoming/active live broadcast content. Or it's "none" if there is not any upcoming/active live broadcasts. */
   public var liveBroadcastContent: String?
   /*The creation date and time of the resource that the search result identifies. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*A map of thumbnail images associated with the search result. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The title of the search result. */
   public var title: String?
   public init(channelId:String?, channelTitle:String?, description:String?, liveBroadcastContent:String?, publishedAt:String?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.channelId = channelId
      self.channelTitle = channelTitle
      self.description = description
      self.liveBroadcastContent = liveBroadcastContent
      self.publishedAt = publishedAt
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubeSponsor : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#sponsor". */
   public var kind: String?
   /*The snippet object contains basic details about the sponsor. */
   public var snippet: GoogleCloudYoutubeSponsorSnippet?
   public init(etag:String?, kind:String?, snippet:GoogleCloudYoutubeSponsorSnippet?) {
      self.etag = etag
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeSponsorListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of sponsors that match the request criteria. */
   public var items: [GoogleCloudYoutubeSponsor]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#sponsorListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeSponsor]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeSponsorSnippet : GoogleCloudModel {
   /*The id of the channel being sponsored. */
   public var channelId: String?
   /*The cumulative time a user has been a sponsor in months. */
   @CodingUses<Coder> public var cumulativeDurationMonths: Int?
   /*Details about the sponsor. */
   public var sponsorDetails: GoogleCloudYoutubeChannelProfileDetails?
   /*The date and time when the user became a sponsor. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var sponsorSince: String?
   public init(channelId:String?, cumulativeDurationMonths:Int?, sponsorDetails:GoogleCloudYoutubeChannelProfileDetails?, sponsorSince:String?) {
      self.channelId = channelId
      self.cumulativeDurationMonths = cumulativeDurationMonths
      self.sponsorDetails = sponsorDetails
      self.sponsorSince = sponsorSince
   }
}
public struct GoogleCloudYoutubeSubscription : GoogleCloudModel {
   /*The contentDetails object contains basic statistics about the subscription. */
   public var contentDetails: GoogleCloudYoutubeSubscriptionContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the subscription. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#subscription". */
   public var kind: String?
   /*The snippet object contains basic details about the subscription, including its title and the channel that the user subscribed to. */
   public var snippet: GoogleCloudYoutubeSubscriptionSnippet?
   /*The subscriberSnippet object contains basic details about the sbuscriber. */
   public var subscriberSnippet: GoogleCloudYoutubeSubscriptionSubscriberSnippet?
   public init(contentDetails:GoogleCloudYoutubeSubscriptionContentDetails?, etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeSubscriptionSnippet?, subscriberSnippet:GoogleCloudYoutubeSubscriptionSubscriberSnippet?) {
      self.contentDetails = contentDetails
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
      self.subscriberSnippet = subscriberSnippet
   }
}
public struct GoogleCloudYoutubeSubscriptionContentDetails : GoogleCloudModel {
   /*The type of activity this subscription is for (only uploads, everything). */
   public var activityType: String?
   /*The number of new items in the subscription since its content was last read. */
   @CodingUses<Coder> public var newItemCount: UInt?
   /*The approximate number of items that the subscription points to. */
   @CodingUses<Coder> public var totalItemCount: UInt?
   public init(activityType:String?, newItemCount:UInt?, totalItemCount:UInt?) {
      self.activityType = activityType
      self.newItemCount = newItemCount
      self.totalItemCount = totalItemCount
   }
}
public struct GoogleCloudYoutubeSubscriptionListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of subscriptions that match the request criteria. */
   public var items: [GoogleCloudYoutubeSubscription]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#subscriptionListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeSubscription]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeSubscriptionSnippet : GoogleCloudModel {
   /*The ID that YouTube uses to uniquely identify the subscriber's channel. */
   public var channelId: String?
   /*Channel title for the channel that the subscription belongs to. */
   public var channelTitle: String?
   /*The subscription's details. */
   public var description: String?
   /*The date and time that the subscription was created. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*The id object contains information about the channel that the user subscribed to. */
   public var resourceId: GoogleCloudYoutubeResourceId?
   /*A map of thumbnail images associated with the video. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The subscription's title. */
   public var title: String?
   public init(channelId:String?, channelTitle:String?, description:String?, publishedAt:String?, resourceId:GoogleCloudYoutubeResourceId?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.channelId = channelId
      self.channelTitle = channelTitle
      self.description = description
      self.publishedAt = publishedAt
      self.resourceId = resourceId
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubeSubscriptionSubscriberSnippet : GoogleCloudModel {
   /*The channel ID of the subscriber. */
   public var channelId: String?
   /*The description of the subscriber. */
   public var description: String?
   /*Thumbnails for this subscriber. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The title of the subscriber. */
   public var title: String?
   public init(channelId:String?, description:String?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.channelId = channelId
      self.description = description
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubeSuperChatEvent : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube assigns to uniquely identify the Super Chat event. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#superChatEvent". */
   public var kind: String?
   /*The snippet object contains basic details about the Super Chat event. */
   public var snippet: GoogleCloudYoutubeSuperChatEventSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeSuperChatEventSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeSuperChatEventListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of Super Chat purchases that match the request criteria. */
   public var items: [GoogleCloudYoutubeSuperChatEvent]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#superChatEventListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeSuperChatEvent]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeSuperChatEventSnippet : GoogleCloudModel {
   /*The purchase amount, in micros of the purchase currency. e.g., 1 is represented as 1000000. */
   @CodingUses<Coder> public var amountMicros: UInt?
   /*Channel id where the event occurred. */
   public var channelId: String?
   /*The text contents of the comment left by the user. */
   public var commentText: String?
   /*The date and time when the event occurred. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var createdAt: String?
   /*The currency in which the purchase was made. ISO 4217. */
   public var currency: String?
   /*A rendered string that displays the purchase amount and currency (e.g., "$1.00"). The string is rendered for the given language. */
   public var displayString: String?
   /*True if this event is a Super Chat for Good purchase. */
   public var isSuperChatForGood: Bool?
   /*True if this event is a Super Sticker event. */
   public var isSuperStickerEvent: Bool?
   /*The tier for the paid message, which is based on the amount of money spent to purchase the message. */
   @CodingUses<Coder> public var messageType: UInt?
   /*If this event is a Super Chat for Good purchase, this field will contain information about the charity the purchase is donated to. */
   public var nonprofit: GoogleCloudYoutubeNonprofit?
   /*If this event is a Super Sticker event, this field will contain metadata about the Super Sticker. */
   public var superStickerMetadata: GoogleCloudYoutubeSuperStickerMetadata?
   /*Details about the supporter. */
   public var supporterDetails: GoogleCloudYoutubeChannelProfileDetails?
   public init(amountMicros:UInt?, channelId:String?, commentText:String?, createdAt:String?, currency:String?, displayString:String?, isSuperChatForGood:Bool?, isSuperStickerEvent:Bool?, messageType:UInt?, nonprofit:GoogleCloudYoutubeNonprofit?, superStickerMetadata:GoogleCloudYoutubeSuperStickerMetadata?, supporterDetails:GoogleCloudYoutubeChannelProfileDetails?) {
      self.amountMicros = amountMicros
      self.channelId = channelId
      self.commentText = commentText
      self.createdAt = createdAt
      self.currency = currency
      self.displayString = displayString
      self.isSuperChatForGood = isSuperChatForGood
      self.isSuperStickerEvent = isSuperStickerEvent
      self.messageType = messageType
      self.nonprofit = nonprofit
      self.superStickerMetadata = superStickerMetadata
      self.supporterDetails = supporterDetails
   }
}
public struct GoogleCloudYoutubeSuperStickerMetadata : GoogleCloudModel {
   /*Internationalized alt text that describes the sticker image and any animation associated with it. */
   public var altText: String?
   /*Specifies the localization language in which the alt text is returned. */
   public var altTextLanguage: String?
   /*Unique identifier of the Super Sticker. This is a shorter form of the alt_text that includes pack name and a recognizable characteristic of the sticker. */
   public var stickerId: String?
   public init(altText:String?, altTextLanguage:String?, stickerId:String?) {
      self.altText = altText
      self.altTextLanguage = altTextLanguage
      self.stickerId = stickerId
   }
}
public struct GoogleCloudYoutubeThumbnail : GoogleCloudModel {
   /*(Optional) Height of the thumbnail image. */
   @CodingUses<Coder> public var height: UInt?
   /*The thumbnail image's URL. */
   public var url: String?
   /*(Optional) Width of the thumbnail image. */
   @CodingUses<Coder> public var width: UInt?
   public init(height:UInt?, url:String?, width:UInt?) {
      self.height = height
      self.url = url
      self.width = width
   }
}
public struct GoogleCloudYoutubeThumbnailDetails : GoogleCloudModel {
   /*The default image for this resource. */
   public var `default`: GoogleCloudYoutubeThumbnail?
   /*The high quality image for this resource. */
   public var high: GoogleCloudYoutubeThumbnail?
   /*The maximum resolution quality image for this resource. */
   public var maxres: GoogleCloudYoutubeThumbnail?
   /*The medium quality image for this resource. */
   public var medium: GoogleCloudYoutubeThumbnail?
   /*The standard quality image for this resource. */
   public var standard: GoogleCloudYoutubeThumbnail?
   public init(`default`:GoogleCloudYoutubeThumbnail?, high:GoogleCloudYoutubeThumbnail?, maxres:GoogleCloudYoutubeThumbnail?, medium:GoogleCloudYoutubeThumbnail?, standard:GoogleCloudYoutubeThumbnail?) {
      self.`default` = `default`
      self.high = high
      self.maxres = maxres
      self.medium = medium
      self.standard = standard
   }
}
public struct GoogleCloudYoutubeThumbnailSetResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of thumbnails. */
   public var items: [GoogleCloudYoutubeThumbnailDetails]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#thumbnailSetResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeThumbnailDetails]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeTokenPagination : GoogleCloudModel {
}
public struct GoogleCloudYoutubeVideo : GoogleCloudModel {
   /*Age restriction details related to a video. This data can only be retrieved by the video owner. */
   public var ageGating: GoogleCloudYoutubeVideoAgeGating?
   /*The contentDetails object contains information about the video content, including the length of the video and its aspect ratio. */
   public var contentDetails: GoogleCloudYoutubeVideoContentDetails?
   /*Etag of this resource. */
   public var etag: String?
   /*The fileDetails object encapsulates information about the video file that was uploaded to YouTube, including the file's resolution, duration, audio and video codecs, stream bitrates, and more. This data can only be retrieved by the video owner. */
   public var fileDetails: GoogleCloudYoutubeVideoFileDetails?
   /*The ID that YouTube uses to uniquely identify the video. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#video". */
   public var kind: String?
   /*The liveStreamingDetails object contains metadata about a live video broadcast. The object will only be present in a video resource if the video is an upcoming, live, or completed live broadcast. */
   public var liveStreamingDetails: GoogleCloudYoutubeVideoLiveStreamingDetails?
   /*List with all localizations. */
   public var localizations: [String : GoogleCloudYoutubeVideoLocalization]?
   /*The monetizationDetails object encapsulates information about the monetization status of the video. */
   public var monetizationDetails: GoogleCloudYoutubeVideoMonetizationDetails?
   /*The player object contains information that you would use to play the video in an embedded player. */
   public var player: GoogleCloudYoutubeVideoPlayer?
   /*The processingDetails object encapsulates information about YouTube's progress in processing the uploaded video file. The properties in the object identify the current processing status and an estimate of the time remaining until YouTube finishes processing the video. This part also indicates whether different types of data or content, such as file details or thumbnail images, are available for the video.

The processingProgress object is designed to be polled so that the video uploaded can track the progress that YouTube has made in processing the uploaded video file. This data can only be retrieved by the video owner. */
   public var processingDetails: GoogleCloudYoutubeVideoProcessingDetails?
   /*The projectDetails object contains information about the project specific video metadata. */
   public var projectDetails: GoogleCloudYoutubeVideoProjectDetails?
   /*The recordingDetails object encapsulates information about the location, date and address where the video was recorded. */
   public var recordingDetails: GoogleCloudYoutubeVideoRecordingDetails?
   /*The snippet object contains basic details about the video, such as its title, description, and category. */
   public var snippet: GoogleCloudYoutubeVideoSnippet?
   /*The statistics object contains statistics about the video. */
   public var statistics: GoogleCloudYoutubeVideoStatistics?
   /*The status object contains information about the video's uploading, processing, and privacy statuses. */
   public var status: GoogleCloudYoutubeVideoStatus?
   /*The suggestions object encapsulates suggestions that identify opportunities to improve the video quality or the metadata for the uploaded video. This data can only be retrieved by the video owner. */
   public var suggestions: GoogleCloudYoutubeVideoSuggestions?
   /*The topicDetails object encapsulates information about Freebase topics associated with the video. */
   public var topicDetails: GoogleCloudYoutubeVideoTopicDetails?
   public init(ageGating:GoogleCloudYoutubeVideoAgeGating?, contentDetails:GoogleCloudYoutubeVideoContentDetails?, etag:String?, fileDetails:GoogleCloudYoutubeVideoFileDetails?, id:String?, kind:String?, liveStreamingDetails:GoogleCloudYoutubeVideoLiveStreamingDetails?, localizations:[String : GoogleCloudYoutubeVideoLocalization]?, monetizationDetails:GoogleCloudYoutubeVideoMonetizationDetails?, player:GoogleCloudYoutubeVideoPlayer?, processingDetails:GoogleCloudYoutubeVideoProcessingDetails?, projectDetails:GoogleCloudYoutubeVideoProjectDetails?, recordingDetails:GoogleCloudYoutubeVideoRecordingDetails?, snippet:GoogleCloudYoutubeVideoSnippet?, statistics:GoogleCloudYoutubeVideoStatistics?, status:GoogleCloudYoutubeVideoStatus?, suggestions:GoogleCloudYoutubeVideoSuggestions?, topicDetails:GoogleCloudYoutubeVideoTopicDetails?) {
      self.ageGating = ageGating
      self.contentDetails = contentDetails
      self.etag = etag
      self.fileDetails = fileDetails
      self.id = id
      self.kind = kind
      self.liveStreamingDetails = liveStreamingDetails
      self.localizations = localizations
      self.monetizationDetails = monetizationDetails
      self.player = player
      self.processingDetails = processingDetails
      self.projectDetails = projectDetails
      self.recordingDetails = recordingDetails
      self.snippet = snippet
      self.statistics = statistics
      self.status = status
      self.suggestions = suggestions
      self.topicDetails = topicDetails
   }
}
public struct GoogleCloudYoutubeVideoAbuseReport : GoogleCloudModel {
   /*Additional comments regarding the abuse report. */
   public var comments: String?
   /*The language that the content was viewed in. */
   public var language: String?
   /*The high-level, or primary, reason that the content is abusive. The value is an abuse report reason ID. */
   public var reasonId: String?
   /*The specific, or secondary, reason that this content is abusive (if available). The value is an abuse report reason ID that is a valid secondary reason for the primary reason. */
   public var secondaryReasonId: String?
   /*The ID that YouTube uses to uniquely identify the video. */
   public var videoId: String?
   public init(comments:String?, language:String?, reasonId:String?, secondaryReasonId:String?, videoId:String?) {
      self.comments = comments
      self.language = language
      self.reasonId = reasonId
      self.secondaryReasonId = secondaryReasonId
      self.videoId = videoId
   }
}
public struct GoogleCloudYoutubeVideoAbuseReportReason : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID of this abuse report reason. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#videoAbuseReportReason". */
   public var kind: String?
   /*The snippet object contains basic details about the abuse report reason. */
   public var snippet: GoogleCloudYoutubeVideoAbuseReportReasonSnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeVideoAbuseReportReasonSnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeVideoAbuseReportReasonListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of valid abuse reasons that are used with video.ReportAbuse. */
   public var items: [GoogleCloudYoutubeVideoAbuseReportReason]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#videoAbuseReportReasonListResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeVideoAbuseReportReason]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeVideoAbuseReportReasonSnippet : GoogleCloudModel {
   /*The localized label belonging to this abuse report reason. */
   public var label: String?
   /*The secondary reasons associated with this reason, if any are available. (There might be 0 or more.) */
   public var secondaryReasons: [GoogleCloudYoutubeVideoAbuseReportSecondaryReason]?
   public init(label:String?, secondaryReasons:[GoogleCloudYoutubeVideoAbuseReportSecondaryReason]?) {
      self.label = label
      self.secondaryReasons = secondaryReasons
   }
}
public struct GoogleCloudYoutubeVideoAbuseReportSecondaryReason : GoogleCloudModel {
   /*The ID of this abuse report secondary reason. */
   public var id: String?
   /*The localized label for this abuse report secondary reason. */
   public var label: String?
   public init(id:String?, label:String?) {
      self.id = id
      self.label = label
   }
}
public struct GoogleCloudYoutubeVideoAgeGating : GoogleCloudModel {
   /*Indicates whether or not the video has alcoholic beverage content. Only users of legal purchasing age in a particular country, as identified by ICAP, can view the content. */
   public var alcoholContent: Bool?
   /*Age-restricted trailers. For redband trailers and adult-rated video-games. Only users aged 18+ can view the content. The the field is true the content is restricted to viewers aged 18+. Otherwise The field won't be present. */
   public var restricted: Bool?
   /*Video game rating, if any. */
   public var videoGameRating: String?
   public init(alcoholContent:Bool?, restricted:Bool?, videoGameRating:String?) {
      self.alcoholContent = alcoholContent
      self.restricted = restricted
      self.videoGameRating = videoGameRating
   }
}
public struct GoogleCloudYoutubeVideoCategory : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*The ID that YouTube uses to uniquely identify the video category. */
   public var id: String?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#videoCategory". */
   public var kind: String?
   /*The snippet object contains basic details about the video category, including its title. */
   public var snippet: GoogleCloudYoutubeVideoCategorySnippet?
   public init(etag:String?, id:String?, kind:String?, snippet:GoogleCloudYoutubeVideoCategorySnippet?) {
      self.etag = etag
      self.id = id
      self.kind = kind
      self.snippet = snippet
   }
}
public struct GoogleCloudYoutubeVideoCategoryListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of video categories that can be associated with YouTube videos. In this map, the video category ID is the map key, and its value is the corresponding videoCategory resource. */
   public var items: [GoogleCloudYoutubeVideoCategory]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#videoCategoryListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeVideoCategory]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeVideoCategorySnippet : GoogleCloudModel {
   public var assignable: Bool?
   /*The YouTube channel that created the video category. */
   public var channelId: String?
   /*The video category's title. */
   public var title: String?
   public init(assignable:Bool?, channelId:String?, title:String?) {
      self.assignable = assignable
      self.channelId = channelId
      self.title = title
   }
}
public struct GoogleCloudYoutubeVideoContentDetails : GoogleCloudModel {
   /*The value of captions indicates whether the video has captions or not. */
   public var caption: String?
   /*Specifies the ratings that the video received under various rating schemes. */
   public var contentRating: GoogleCloudYoutubeContentRating?
   /*The countryRestriction object contains information about the countries where a video is (or is not) viewable. */
   public var countryRestriction: GoogleCloudYoutubeAccessPolicy?
   /*The value of definition indicates whether the video is available in high definition or only in standard definition. */
   public var definition: String?
   /*The value of dimension indicates whether the video is available in 3D or in 2D. */
   public var dimension: String?
   /*The length of the video. The tag value is an ISO 8601 duration in the format PT#M#S, in which the letters PT indicate that the value specifies a period of time, and the letters M and S refer to length in minutes and seconds, respectively. The # characters preceding the M and S letters are both integers that specify the number of minutes (or seconds) of the video. For example, a value of PT15M51S indicates that the video is 15 minutes and 51 seconds long. */
   public var duration: String?
   /*Indicates whether the video uploader has provided a custom thumbnail image for the video. This property is only visible to the video uploader. */
   public var hasCustomThumbnail: Bool?
   /*The value of is_license_content indicates whether the video is licensed content. */
   public var licensedContent: Bool?
   /*Specifies the projection format of the video. */
   public var projection: String?
   /*The regionRestriction object contains information about the countries where a video is (or is not) viewable. The object will contain either the contentDetails.regionRestriction.allowed property or the contentDetails.regionRestriction.blocked property. */
   public var regionRestriction: GoogleCloudYoutubeVideoContentDetailsRegionRestriction?
   public init(caption:String?, contentRating:GoogleCloudYoutubeContentRating?, countryRestriction:GoogleCloudYoutubeAccessPolicy?, definition:String?, dimension:String?, duration:String?, hasCustomThumbnail:Bool?, licensedContent:Bool?, projection:String?, regionRestriction:GoogleCloudYoutubeVideoContentDetailsRegionRestriction?) {
      self.caption = caption
      self.contentRating = contentRating
      self.countryRestriction = countryRestriction
      self.definition = definition
      self.dimension = dimension
      self.duration = duration
      self.hasCustomThumbnail = hasCustomThumbnail
      self.licensedContent = licensedContent
      self.projection = projection
      self.regionRestriction = regionRestriction
   }
}
public struct GoogleCloudYoutubeVideoContentDetailsRegionRestriction : GoogleCloudModel {
   /*A list of region codes that identify countries where the video is viewable. If this property is present and a country is not listed in its value, then the video is blocked from appearing in that country. If this property is present and contains an empty list, the video is blocked in all countries. */
   public var allowed: [String]?
   /*A list of region codes that identify countries where the video is blocked. If this property is present and a country is not listed in its value, then the video is viewable in that country. If this property is present and contains an empty list, the video is viewable in all countries. */
   public var blocked: [String]?
   public init(allowed:[String]?, blocked:[String]?) {
      self.allowed = allowed
      self.blocked = blocked
   }
}
public struct GoogleCloudYoutubeVideoFileDetails : GoogleCloudModel {
   /*A list of audio streams contained in the uploaded video file. Each item in the list contains detailed metadata about an audio stream. */
   public var audioStreams: [GoogleCloudYoutubeVideoFileDetailsAudioStream]?
   /*The uploaded video file's combined (video and audio) bitrate in bits per second. */
   @CodingUses<Coder> public var bitrateBps: UInt?
   /*The uploaded video file's container format. */
   public var container: String?
   /*The date and time when the uploaded video file was created. The value is specified in ISO 8601 format. Currently, the following ISO 8601 formats are supported:  
- Date only: YYYY-MM-DD 
- Naive time: YYYY-MM-DDTHH:MM:SS 
- Time with timezone: YYYY-MM-DDTHH:MM:SS+HH:MM */
   public var creationTime: String?
   /*The length of the uploaded video in milliseconds. */
   @CodingUses<Coder> public var durationMs: UInt?
   /*The uploaded file's name. This field is present whether a video file or another type of file was uploaded. */
   public var fileName: String?
   /*The uploaded file's size in bytes. This field is present whether a video file or another type of file was uploaded. */
   @CodingUses<Coder> public var fileSize: UInt?
   /*The uploaded file's type as detected by YouTube's video processing engine. Currently, YouTube only processes video files, but this field is present whether a video file or another type of file was uploaded. */
   public var fileType: String?
   /*A list of video streams contained in the uploaded video file. Each item in the list contains detailed metadata about a video stream. */
   public var videoStreams: [GoogleCloudYoutubeVideoFileDetailsVideoStream]?
   public init(audioStreams:[GoogleCloudYoutubeVideoFileDetailsAudioStream]?, bitrateBps:UInt?, container:String?, creationTime:String?, durationMs:UInt?, fileName:String?, fileSize:UInt?, fileType:String?, videoStreams:[GoogleCloudYoutubeVideoFileDetailsVideoStream]?) {
      self.audioStreams = audioStreams
      self.bitrateBps = bitrateBps
      self.container = container
      self.creationTime = creationTime
      self.durationMs = durationMs
      self.fileName = fileName
      self.fileSize = fileSize
      self.fileType = fileType
      self.videoStreams = videoStreams
   }
}
public struct GoogleCloudYoutubeVideoFileDetailsAudioStream : GoogleCloudModel {
   /*The audio stream's bitrate, in bits per second. */
   @CodingUses<Coder> public var bitrateBps: UInt?
   /*The number of audio channels that the stream contains. */
   @CodingUses<Coder> public var channelCount: UInt?
   /*The audio codec that the stream uses. */
   public var codec: String?
   /*A value that uniquely identifies a video vendor. Typically, the value is a four-letter vendor code. */
   public var vendor: String?
   public init(bitrateBps:UInt?, channelCount:UInt?, codec:String?, vendor:String?) {
      self.bitrateBps = bitrateBps
      self.channelCount = channelCount
      self.codec = codec
      self.vendor = vendor
   }
}
public struct GoogleCloudYoutubeVideoFileDetailsVideoStream : GoogleCloudModel {
   /*The video content's display aspect ratio, which specifies the aspect ratio in which the video should be displayed. */
   @CodingUses<Coder> public var aspectRatio: Double?
   /*The video stream's bitrate, in bits per second. */
   @CodingUses<Coder> public var bitrateBps: UInt?
   /*The video codec that the stream uses. */
   public var codec: String?
   /*The video stream's frame rate, in frames per second. */
   @CodingUses<Coder> public var frameRateFps: Double?
   /*The encoded video content's height in pixels. */
   @CodingUses<Coder> public var heightPixels: UInt?
   /*The amount that YouTube needs to rotate the original source content to properly display the video. */
   public var rotation: String?
   /*A value that uniquely identifies a video vendor. Typically, the value is a four-letter vendor code. */
   public var vendor: String?
   /*The encoded video content's width in pixels. You can calculate the video's encoding aspect ratio as width_pixels / height_pixels. */
   @CodingUses<Coder> public var widthPixels: UInt?
   public init(aspectRatio:Double?, bitrateBps:UInt?, codec:String?, frameRateFps:Double?, heightPixels:UInt?, rotation:String?, vendor:String?, widthPixels:UInt?) {
      self.aspectRatio = aspectRatio
      self.bitrateBps = bitrateBps
      self.codec = codec
      self.frameRateFps = frameRateFps
      self.heightPixels = heightPixels
      self.rotation = rotation
      self.vendor = vendor
      self.widthPixels = widthPixels
   }
}
public struct GoogleCloudYoutubeVideoGetRatingResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of ratings that match the request criteria. */
   public var items: [GoogleCloudYoutubeVideoRating]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#videoGetRatingResponse". */
   public var kind: String?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeVideoRating]?, kind:String?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeVideoListResponse : GoogleCloudModel {
   /*Etag of this resource. */
   public var etag: String?
   /*Serialized EventId of the request which produced this response. */
   public var eventId: String?
   /*A list of videos that match the request criteria. */
   public var items: [GoogleCloudYoutubeVideo]?
   /*Identifies what kind of resource this is. Value: the fixed string "youtube#videoListResponse". */
   public var kind: String?
   /*The token that can be used as the value of the pageToken parameter to retrieve the next page in the result set. */
   public var nextPageToken: String?
   public var pageInfo: GoogleCloudYoutubePageInfo?
   /*The token that can be used as the value of the pageToken parameter to retrieve the previous page in the result set. */
   public var prevPageToken: String?
   public var tokenPagination: GoogleCloudYoutubeTokenPagination?
   /*The visitorId identifies the visitor. */
   public var visitorId: String?
   public init(etag:String?, eventId:String?, items:[GoogleCloudYoutubeVideo]?, kind:String?, nextPageToken:String?, pageInfo:GoogleCloudYoutubePageInfo?, prevPageToken:String?, tokenPagination:GoogleCloudYoutubeTokenPagination?, visitorId:String?) {
      self.etag = etag
      self.eventId = eventId
      self.items = items
      self.kind = kind
      self.nextPageToken = nextPageToken
      self.pageInfo = pageInfo
      self.prevPageToken = prevPageToken
      self.tokenPagination = tokenPagination
      self.visitorId = visitorId
   }
}
public struct GoogleCloudYoutubeVideoLiveStreamingDetails : GoogleCloudModel {
   /*The ID of the currently active live chat attached to this video. This field is filled only if the video is a currently live broadcast that has live chat. Once the broadcast transitions to complete this field will be removed and the live chat closed down. For persistent broadcasts that live chat id will no longer be tied to this video but rather to the new video being displayed at the persistent page. */
   public var activeLiveChatId: String?
   /*The time that the broadcast actually ended. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. This value will not be available until the broadcast is over. */
   @CodingUses<Coder> public var actualEndTime: String?
   /*The time that the broadcast actually started. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. This value will not be available until the broadcast begins. */
   @CodingUses<Coder> public var actualStartTime: String?
   /*The number of viewers currently watching the broadcast. The property and its value will be present if the broadcast has current viewers and the broadcast owner has not hidden the viewcount for the video. Note that YouTube stops tracking the number of concurrent viewers for a broadcast when the broadcast ends. So, this property would not identify the number of viewers watching an archived video of a live broadcast that already ended. */
   @CodingUses<Coder> public var concurrentViewers: UInt?
   /*The time that the broadcast is scheduled to end. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. If the value is empty or the property is not present, then the broadcast is scheduled to continue indefinitely. */
   @CodingUses<Coder> public var scheduledEndTime: String?
   /*The time that the broadcast is scheduled to begin. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var scheduledStartTime: String?
   public init(activeLiveChatId:String?, actualEndTime:String?, actualStartTime:String?, concurrentViewers:UInt?, scheduledEndTime:String?, scheduledStartTime:String?) {
      self.activeLiveChatId = activeLiveChatId
      self.actualEndTime = actualEndTime
      self.actualStartTime = actualStartTime
      self.concurrentViewers = concurrentViewers
      self.scheduledEndTime = scheduledEndTime
      self.scheduledStartTime = scheduledStartTime
   }
}
public struct GoogleCloudYoutubeVideoLocalization : GoogleCloudModel {
   /*Localized version of the video's description. */
   public var description: String?
   /*Localized version of the video's title. */
   public var title: String?
   public init(description:String?, title:String?) {
      self.description = description
      self.title = title
   }
}
public struct GoogleCloudYoutubeVideoMonetizationDetails : GoogleCloudModel {
   /*The value of access indicates whether the video can be monetized or not. */
   public var access: GoogleCloudYoutubeAccessPolicy?
   public init(access:GoogleCloudYoutubeAccessPolicy?) {
      self.access = access
   }
}
public struct GoogleCloudYoutubeVideoPlayer : GoogleCloudModel {
   @CodingUses<Coder> public var embedHeight: Int?
   /*An <iframe> tag that embeds a player that will play the video. */
   public var embedHtml: String?
   /*The embed width */
   @CodingUses<Coder> public var embedWidth: Int?
   public init(embedHeight:Int?, embedHtml:String?, embedWidth:Int?) {
      self.embedHeight = embedHeight
      self.embedHtml = embedHtml
      self.embedWidth = embedWidth
   }
}
public struct GoogleCloudYoutubeVideoProcessingDetails : GoogleCloudModel {
   /*This value indicates whether video editing suggestions, which might improve video quality or the playback experience, are available for the video. You can retrieve these suggestions by requesting the suggestions part in your videos.list() request. */
   public var editorSuggestionsAvailability: String?
   /*This value indicates whether file details are available for the uploaded video. You can retrieve a video's file details by requesting the fileDetails part in your videos.list() request. */
   public var fileDetailsAvailability: String?
   /*The reason that YouTube failed to process the video. This property will only have a value if the processingStatus property's value is failed. */
   public var processingFailureReason: String?
   /*This value indicates whether the video processing engine has generated suggestions that might improve YouTube's ability to process the the video, warnings that explain video processing problems, or errors that cause video processing problems. You can retrieve these suggestions by requesting the suggestions part in your videos.list() request. */
   public var processingIssuesAvailability: String?
   /*The processingProgress object contains information about the progress YouTube has made in processing the video. The values are really only relevant if the video's processing status is processing. */
   public var processingProgress: GoogleCloudYoutubeVideoProcessingDetailsProcessingProgress?
   /*The video's processing status. This value indicates whether YouTube was able to process the video or if the video is still being processed. */
   public var processingStatus: String?
   /*This value indicates whether keyword (tag) suggestions are available for the video. Tags can be added to a video's metadata to make it easier for other users to find the video. You can retrieve these suggestions by requesting the suggestions part in your videos.list() request. */
   public var tagSuggestionsAvailability: String?
   /*This value indicates whether thumbnail images have been generated for the video. */
   public var thumbnailsAvailability: String?
   public init(editorSuggestionsAvailability:String?, fileDetailsAvailability:String?, processingFailureReason:String?, processingIssuesAvailability:String?, processingProgress:GoogleCloudYoutubeVideoProcessingDetailsProcessingProgress?, processingStatus:String?, tagSuggestionsAvailability:String?, thumbnailsAvailability:String?) {
      self.editorSuggestionsAvailability = editorSuggestionsAvailability
      self.fileDetailsAvailability = fileDetailsAvailability
      self.processingFailureReason = processingFailureReason
      self.processingIssuesAvailability = processingIssuesAvailability
      self.processingProgress = processingProgress
      self.processingStatus = processingStatus
      self.tagSuggestionsAvailability = tagSuggestionsAvailability
      self.thumbnailsAvailability = thumbnailsAvailability
   }
}
public struct GoogleCloudYoutubeVideoProcessingDetailsProcessingProgress : GoogleCloudModel {
   /*The number of parts of the video that YouTube has already processed. You can estimate the percentage of the video that YouTube has already processed by calculating:
100 * parts_processed / parts_total

Note that since the estimated number of parts could increase without a corresponding increase in the number of parts that have already been processed, it is possible that the calculated progress could periodically decrease while YouTube processes a video. */
   @CodingUses<Coder> public var partsProcessed: UInt?
   /*An estimate of the total number of parts that need to be processed for the video. The number may be updated with more precise estimates while YouTube processes the video. */
   @CodingUses<Coder> public var partsTotal: UInt?
   /*An estimate of the amount of time, in millseconds, that YouTube needs to finish processing the video. */
   @CodingUses<Coder> public var timeLeftMs: UInt?
   public init(partsProcessed:UInt?, partsTotal:UInt?, timeLeftMs:UInt?) {
      self.partsProcessed = partsProcessed
      self.partsTotal = partsTotal
      self.timeLeftMs = timeLeftMs
   }
}
public struct GoogleCloudYoutubeVideoProjectDetails : GoogleCloudModel {
   /*A list of project tags associated with the video during the upload. */
   public var tags: [String]?
   public init(tags:[String]?) {
      self.tags = tags
   }
}
public struct GoogleCloudYoutubeVideoRating : GoogleCloudModel {
   public var rating: String?
   public var videoId: String?
   public init(rating:String?, videoId:String?) {
      self.rating = rating
      self.videoId = videoId
   }
}
public struct GoogleCloudYoutubeVideoRecordingDetails : GoogleCloudModel {
   /*The geolocation information associated with the video. */
   public var location: GoogleCloudYoutubeGeoPoint?
   /*The text description of the location where the video was recorded. */
   public var locationDescription: String?
   /*The date and time when the video was recorded. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format. */
   @CodingUses<Coder> public var recordingDate: String?
   public init(location:GoogleCloudYoutubeGeoPoint?, locationDescription:String?, recordingDate:String?) {
      self.location = location
      self.locationDescription = locationDescription
      self.recordingDate = recordingDate
   }
}
public struct GoogleCloudYoutubeVideoSnippet : GoogleCloudModel {
   /*The YouTube video category associated with the video. */
   public var categoryId: String?
   /*The ID that YouTube uses to uniquely identify the channel that the video was uploaded to. */
   public var channelId: String?
   /*Channel title for the channel that the video belongs to. */
   public var channelTitle: String?
   /*The default_audio_language property specifies the language spoken in the video's default audio track. */
   public var defaultAudioLanguage: String?
   /*The language of the videos's default snippet. */
   public var defaultLanguage: String?
   /*The video's description. */
   public var description: String?
   /*Indicates if the video is an upcoming/active live broadcast. Or it's "none" if the video is not an upcoming/active live broadcast. */
   public var liveBroadcastContent: String?
   /*Localized snippet selected with the hl parameter. If no such localization exists, this field is populated with the default snippet. (Read-only) */
   public var localized: GoogleCloudYoutubeVideoLocalization?
   /*The date and time that the video was uploaded. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishedAt: String?
   /*A list of keyword tags associated with the video. Tags may contain spaces. */
   public var tags: [String]?
   /*A map of thumbnail images associated with the video. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail. */
   public var thumbnails: GoogleCloudYoutubeThumbnailDetails?
   /*The video's title. */
   public var title: String?
   public init(categoryId:String?, channelId:String?, channelTitle:String?, defaultAudioLanguage:String?, defaultLanguage:String?, description:String?, liveBroadcastContent:String?, localized:GoogleCloudYoutubeVideoLocalization?, publishedAt:String?, tags:[String]?, thumbnails:GoogleCloudYoutubeThumbnailDetails?, title:String?) {
      self.categoryId = categoryId
      self.channelId = channelId
      self.channelTitle = channelTitle
      self.defaultAudioLanguage = defaultAudioLanguage
      self.defaultLanguage = defaultLanguage
      self.description = description
      self.liveBroadcastContent = liveBroadcastContent
      self.localized = localized
      self.publishedAt = publishedAt
      self.tags = tags
      self.thumbnails = thumbnails
      self.title = title
   }
}
public struct GoogleCloudYoutubeVideoStatistics : GoogleCloudModel {
   /*The number of comments for the video. */
   @CodingUses<Coder> public var commentCount: UInt?
   /*The number of users who have indicated that they disliked the video by giving it a negative rating. */
   @CodingUses<Coder> public var dislikeCount: UInt?
   /*The number of users who currently have the video marked as a favorite video. */
   @CodingUses<Coder> public var favoriteCount: UInt?
   /*The number of users who have indicated that they liked the video by giving it a positive rating. */
   @CodingUses<Coder> public var likeCount: UInt?
   /*The number of times the video has been viewed. */
   @CodingUses<Coder> public var viewCount: UInt?
   public init(commentCount:UInt?, dislikeCount:UInt?, favoriteCount:UInt?, likeCount:UInt?, viewCount:UInt?) {
      self.commentCount = commentCount
      self.dislikeCount = dislikeCount
      self.favoriteCount = favoriteCount
      self.likeCount = likeCount
      self.viewCount = viewCount
   }
}
public struct GoogleCloudYoutubeVideoStatus : GoogleCloudModel {
   /*This value indicates if the video can be embedded on another website. */
   public var embeddable: Bool?
   /*This value explains why a video failed to upload. This property is only present if the uploadStatus property indicates that the upload failed. */
   public var failureReason: String?
   /*The video's license. */
   public var license: String?
   public var madeForKids: Bool?
   /*The video's privacy status. */
   public var privacyStatus: String?
   /*This value indicates if the extended video statistics on the watch page can be viewed by everyone. Note that the view count, likes, etc will still be visible if this is disabled. */
   public var publicStatsViewable: Bool?
   /*The date and time when the video is scheduled to publish. It can be set only if the privacy status of the video is private. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format. */
   @CodingUses<Coder> public var publishAt: String?
   /*This value explains why YouTube rejected an uploaded video. This property is only present if the uploadStatus property indicates that the upload was rejected. */
   public var rejectionReason: String?
   /*Allows clients to set the Crosswalk self_declared state for a Video. This maps to VAPI.Video.creator_flags.is_crosswalk_self_declared() and VAPI.Video.creator_flags.is_not_crosswalk_self_declared(). */
   public var selfDeclaredMadeForKids: Bool?
   /*The status of the uploaded video. */
   public var uploadStatus: String?
   public init(embeddable:Bool?, failureReason:String?, license:String?, madeForKids:Bool?, privacyStatus:String?, publicStatsViewable:Bool?, publishAt:String?, rejectionReason:String?, selfDeclaredMadeForKids:Bool?, uploadStatus:String?) {
      self.embeddable = embeddable
      self.failureReason = failureReason
      self.license = license
      self.madeForKids = madeForKids
      self.privacyStatus = privacyStatus
      self.publicStatsViewable = publicStatsViewable
      self.publishAt = publishAt
      self.rejectionReason = rejectionReason
      self.selfDeclaredMadeForKids = selfDeclaredMadeForKids
      self.uploadStatus = uploadStatus
   }
}
public struct GoogleCloudYoutubeVideoSuggestions : GoogleCloudModel {
   /*A list of video editing operations that might improve the video quality or playback experience of the uploaded video. */
   public var editorSuggestions: [String]?
   /*A list of errors that will prevent YouTube from successfully processing the uploaded video video. These errors indicate that, regardless of the video's current processing status, eventually, that status will almost certainly be failed. */
   public var processingErrors: [String]?
   /*A list of suggestions that may improve YouTube's ability to process the video. */
   public var processingHints: [String]?
   /*A list of reasons why YouTube may have difficulty transcoding the uploaded video or that might result in an erroneous transcoding. These warnings are generated before YouTube actually processes the uploaded video file. In addition, they identify issues that are unlikely to cause the video processing to fail but that might cause problems such as sync issues, video artifacts, or a missing audio track. */
   public var processingWarnings: [String]?
   /*A list of keyword tags that could be added to the video's metadata to increase the likelihood that users will locate your video when searching or browsing on YouTube. */
   public var tagSuggestions: [GoogleCloudYoutubeVideoSuggestionsTagSuggestion]?
   public init(editorSuggestions:[String]?, processingErrors:[String]?, processingHints:[String]?, processingWarnings:[String]?, tagSuggestions:[GoogleCloudYoutubeVideoSuggestionsTagSuggestion]?) {
      self.editorSuggestions = editorSuggestions
      self.processingErrors = processingErrors
      self.processingHints = processingHints
      self.processingWarnings = processingWarnings
      self.tagSuggestions = tagSuggestions
   }
}
public struct GoogleCloudYoutubeVideoSuggestionsTagSuggestion : GoogleCloudModel {
   /*A set of video categories for which the tag is relevant. You can use this information to display appropriate tag suggestions based on the video category that the video uploader associates with the video. By default, tag suggestions are relevant for all categories if there are no restricts defined for the keyword. */
   public var categoryRestricts: [String]?
   /*The keyword tag suggested for the video. */
   public var tag: String?
   public init(categoryRestricts:[String]?, tag:String?) {
      self.categoryRestricts = categoryRestricts
      self.tag = tag
   }
}
public struct GoogleCloudYoutubeVideoTopicDetails : GoogleCloudModel {
   /*Similar to topic_id, except that these topics are merely relevant to the video. These are topics that may be mentioned in, or appear in the video. You can retrieve information about each topic using Freebase Topic API. */
   public var relevantTopicIds: [String]?
   /*A list of Wikipedia URLs that provide a high-level description of the video's content. */
   public var topicCategories: [String]?
   /*A list of Freebase topic IDs that are centrally associated with the video. These are topics that are centrally featured in the video, and it can be said that the video is mainly about each of these. You can retrieve information about each topic using the Freebase Topic API. */
   public var topicIds: [String]?
   public init(relevantTopicIds:[String]?, topicCategories:[String]?, topicIds:[String]?) {
      self.relevantTopicIds = relevantTopicIds
      self.topicCategories = topicCategories
      self.topicIds = topicIds
   }
}
public struct GoogleCloudYoutubeWatchSettings : GoogleCloudModel {
   /*The text color for the video watch page's branded area. */
   public var backgroundColor: String?
   /*An ID that uniquely identifies a playlist that displays next to the video player. */
   public var featuredPlaylistId: String?
   /*The background color for the video watch page's branded area. */
   public var textColor: String?
   public init(backgroundColor:String?, featuredPlaylistId:String?, textColor:String?) {
      self.backgroundColor = backgroundColor
      self.featuredPlaylistId = featuredPlaylistId
      self.textColor = textColor
   }
}
public struct GoogleCloudYoutubeChannelContentDetailsRelatedPlaylists : GoogleCloudModel {
   /*The ID of the playlist that contains the channel"s favorite videos. Use the  playlistItems.insert and  playlistItems.delete to add or remove items from that list. */
   public var favorites: String?
   /*The ID of the playlist that contains the channel"s liked videos. Use the   playlistItems.insert and  playlistItems.delete to add or remove items from that list. */
   public var likes: String?
   /*The ID of the playlist that contains the channel"s uploaded videos. Use the  videos.insert method to upload new videos and the videos.delete method to delete previously uploaded videos. */
   public var uploads: String?
   /*The ID of the playlist that contains the channel"s watch history. Use the  playlistItems.insert and  playlistItems.delete to add or remove items from that list. */
   public var watchHistory: String?
   /*The ID of the playlist that contains the channel"s watch later playlist. Use the playlistItems.insert and  playlistItems.delete to add or remove items from that list. */
   public var watchLater: String?
}
public final class GoogleCloudYoutubeClient {
   public var activities : YoutubeActivitiesAPIProtocol
   public var captions : YoutubeCaptionsAPIProtocol
   public var channelBanners : YoutubeChannelBannersAPIProtocol
   public var channelSections : YoutubeChannelSectionsAPIProtocol
   public var channels : YoutubeChannelsAPIProtocol
   public var commentThreads : YoutubeCommentThreadsAPIProtocol
   public var comments : YoutubeCommentsAPIProtocol
   public var guideCategories : YoutubeGuideCategoriesAPIProtocol
   public var i18nLanguages : YoutubeI18nLanguagesAPIProtocol
   public var i18nRegions : YoutubeI18nRegionsAPIProtocol
   public var liveBroadcasts : YoutubeLiveBroadcastsAPIProtocol
   public var liveChatBans : YoutubeLiveChatBansAPIProtocol
   public var liveChatMessages : YoutubeLiveChatMessagesAPIProtocol
   public var liveChatModerators : YoutubeLiveChatModeratorsAPIProtocol
   public var liveStreams : YoutubeLiveStreamsAPIProtocol
   public var members : YoutubeMembersAPIProtocol
   public var membershipsLevels : YoutubeMembershipsLevelsAPIProtocol
   public var playlistItems : YoutubePlaylistItemsAPIProtocol
   public var playlists : YoutubePlaylistsAPIProtocol
   public var search : YoutubeSearchAPIProtocol
   public var sponsors : YoutubeSponsorsAPIProtocol
   public var subscriptions : YoutubeSubscriptionsAPIProtocol
   public var superChatEvents : YoutubeSuperChatEventsAPIProtocol
   public var thumbnails : YoutubeThumbnailsAPIProtocol
   public var videoAbuseReportReasons : YoutubeVideoAbuseReportReasonsAPIProtocol
   public var videoCategories : YoutubeVideoCategoriesAPIProtocol
   public var videos : YoutubeVideosAPIProtocol
   public var watermarks : YoutubeWatermarksAPIProtocol


   public init(credentials: GoogleCloudCredentialsConfiguration, youtubeConfig: GoogleCloudYoutubeConfiguration, httpClient: HTTPClient, eventLoop: EventLoop) throws {
      let refreshableToken = OAuthCredentialLoader.getRefreshableToken(credentials: credentials, withConfig: youtubeConfig, andClient: httpClient, eventLoop: eventLoop)
      guard let projectId = ProcessInfo.processInfo.environment["PROJECT_ID"] ??
               (refreshableToken as? OAuthServiceAccount)?.credentials.projectId ??
               youtubeConfig.project ?? credentials.project else {
         throw GoogleCloudInternalError.projectIdMissing
      }

      let request = GoogleCloudYoutubeRequest(httpClient: httpClient, eventLoop: eventLoop, oauth: refreshableToken, project: projectId)


      activities = GoogleCloudYoutubeActivitiesAPI(request: request)
      captions = GoogleCloudYoutubeCaptionsAPI(request: request)
      channelBanners = GoogleCloudYoutubeChannelBannersAPI(request: request)
      channelSections = GoogleCloudYoutubeChannelSectionsAPI(request: request)
      channels = GoogleCloudYoutubeChannelsAPI(request: request)
      commentThreads = GoogleCloudYoutubeCommentThreadsAPI(request: request)
      comments = GoogleCloudYoutubeCommentsAPI(request: request)
      guideCategories = GoogleCloudYoutubeGuideCategoriesAPI(request: request)
      i18nLanguages = GoogleCloudYoutubeI18nLanguagesAPI(request: request)
      i18nRegions = GoogleCloudYoutubeI18nRegionsAPI(request: request)
      liveBroadcasts = GoogleCloudYoutubeLiveBroadcastsAPI(request: request)
      liveChatBans = GoogleCloudYoutubeLiveChatBansAPI(request: request)
      liveChatMessages = GoogleCloudYoutubeLiveChatMessagesAPI(request: request)
      liveChatModerators = GoogleCloudYoutubeLiveChatModeratorsAPI(request: request)
      liveStreams = GoogleCloudYoutubeLiveStreamsAPI(request: request)
      members = GoogleCloudYoutubeMembersAPI(request: request)
      membershipsLevels = GoogleCloudYoutubeMembershipsLevelsAPI(request: request)
      playlistItems = GoogleCloudYoutubePlaylistItemsAPI(request: request)
      playlists = GoogleCloudYoutubePlaylistsAPI(request: request)
      search = GoogleCloudYoutubeSearchAPI(request: request)
      sponsors = GoogleCloudYoutubeSponsorsAPI(request: request)
      subscriptions = GoogleCloudYoutubeSubscriptionsAPI(request: request)
      superChatEvents = GoogleCloudYoutubeSuperChatEventsAPI(request: request)
      thumbnails = GoogleCloudYoutubeThumbnailsAPI(request: request)
      videoAbuseReportReasons = GoogleCloudYoutubeVideoAbuseReportReasonsAPI(request: request)
      videoCategories = GoogleCloudYoutubeVideoCategoriesAPI(request: request)
      videos = GoogleCloudYoutubeVideosAPI(request: request)
      watermarks = GoogleCloudYoutubeWatermarksAPI(request: request)
   }
}

