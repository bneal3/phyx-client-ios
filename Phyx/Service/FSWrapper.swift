//
//  FSWrapper.swift
//  stat
//
//  Created by Benjamin Neal on 2/8/17.
//  Copyright © 2017 Benjamin Neal. All rights reserved.
//

import Foundation
import FirebaseStorage
import Alamofire
import SDWebImage

let STORAGE_REF = Storage.storage().reference()

// Firestore wrapper
class FSWrapper {
    
    private init() {}
    static let wrapper = FSWrapper()
    
    // Storage references
    private var _avatars = STORAGE_REF.child(FS_STORAGE_PATH + "/avatars")
    private var _media = STORAGE_REF.child(FS_STORAGE_PATH + "/media")
    
    var AVATAR_REF: StorageReference {
        return _avatars
    }
    
    var MEDIA_REF: StorageReference {
        return _media
    }
    
    // FUNCTION: Loads stored images from the Image Cache
    func loadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        // FLOW: Instantiate downloader
        let downloader = SDWebImageDownloader.shared()
        
        if let stored = SDImageCache.shared().imageFromCache(forKey: url.absoluteString) {
            DispatchQueue.main.async {
                completion(stored, nil)
            }
        } else {
            // FLOW: Try downloading image with SDWebImage-conforming url
            downloader.downloadImage(with: url, options: [], progress: { (received, expected, url) in
                if received < expected {
                    print(String(received) + " : " + String(expected))
                }
            }, completed: { (image, data, error, finished) in
                // FLOW: Check for error
                if let error = error {
                    print(error)
                } else if let image = image {
                    // FLOW: If successful save to SDImageCache
                    SDImageCache.shared().store(image, imageData: nil, forKey: url.absoluteString, toDisk: true, completion: {
                        DispatchQueue.main.async {
                            completion(image, nil)
                        }
                    })
                }
            })
        }
    }
    
    private func getSaveFileUrl() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filName = "video_" + String.randomString(length: 6) + ".mov"
        let fileURL = documentsURL.appendingPathComponent("videos/\(filName)")
        return fileURL;
    }
    
    func download(url: URL, _ completion: @escaping (Bool, URL?) -> ()) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (self.getSaveFileUrl(), [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(url, to: destination)
            .response { (response) in

                if let destinationUrl = response.destinationURL {
                    print("destinationUrl \(destinationUrl.absoluteURL)")
                    
                    completion(true, destinationUrl)
                } else {
                    completion(false, nil)
                }
        }
    }
}
