// hankyeol-dev. Data

import Foundation

public struct PostInputType: Encodable {
   let category: String
   let title: String
   let price: Int
   let content: String
   let content1: String?
   let content2: String?
   let content3: String?
   let content4: String?
   let content5: String?
   let files: [String]?
   let logitude: Float?
   let latitude: Float?
   
   public init(
      category: String,
      title: String,
      price: Int,
      content: String, 
      content1: String?,
      content2: String?,
      content3: String?, 
      content4: String?,
      content5: String?,
      files: [String]?,
      logitude: Float?,
      latitude: Float?) {
      self.category = category
      self.title = title
      self.price = price
      self.content = content
      self.content1 = content1
      self.content2 = content2
      self.content3 = content3
      self.content4 = content4
      self.content5 = content5
      self.files = files
      self.logitude = logitude
      self.latitude = latitude
   }
}

public struct UploadFileInputType: Encodable {
   let files: [Data]
   
   public init(files: [Data]) {
      self.files = files
   }
}

public struct GetPostQueryType {
   public let next: String
   public let limit: Int = 5
   public let category: String
}
