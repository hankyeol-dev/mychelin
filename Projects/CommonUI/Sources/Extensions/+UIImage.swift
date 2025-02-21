// hankyeol-dev. CommonUI

import UIKit

public extension UIImage {
   static let chat = UIImage(resource: .chat)
   static let posts = UIImage(resource: .posts)
   static let photoGallery = UIImage(resource: .gallery)
   static let like = UIImage(resource: .like)
   static let unLike = UIImage(resource: .unlike)
   static let dotMenu = UIImage(resource: .menu)
   static let follow = UIImage(resource: .follow)
   static let following = UIImage(resource: .following)
   static let id = UIImage(resource: .id)
   static let xMark = UIImage(resource: .xMark)
   static let pin = UIImage(resource: .pin)
   static let writePost = UIImage(resource: .pencil)
   static let profile = UIImage(resource: .profile)
   static let xmarkOutline = UIImage(resource: .xmarkOutline)
   static let leftOutline = UIImage(resource: .left)
   static let userLocation = UIImage(resource: .userLocation)
   static let starUnFill = UIImage(resource: .starUnFill)
   static let starFill = UIImage(resource: .starFill)
   static let rate1 = UIImage(resource: .rate1)
   static let rate2 = UIImage(resource: .rate2)
   static let rate3 = UIImage(resource: .rate3)
   static let rate4 = UIImage(resource: .rate4)
   static let rate5 = UIImage(resource: .rate5)
   
   func downscaleTOjpegData(maxBytes: UInt) -> Data? {
      var quality = 1.0
      while quality > 0 {
         guard let jpeg = jpegData(compressionQuality: quality)
         else { return nil }
         if jpeg.count <= maxBytes {
            return jpeg
         }
         quality -= 0.1
      }
      return nil
   }
}
