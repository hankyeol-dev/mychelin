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
