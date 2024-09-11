//
//  ServiceHelpers.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/11/24.
//

import Firebase
import FirebaseStorage


// MARK: (Method) Parse content type for media
func parseContentType(forFileExtension fileExtension: String) -> String {
    switch fileExtension.lowercased() {
    // Image MIME types
    case "jpg", "jpeg":
        return "image/jpeg"
    case "png":
        return "image/png"
    case "gif":
        return "image/gif"
    case "bmp":
        return "image/bmp"
    case "webp":
        return "image/webp"
    
    // Video MIME types
    case "mp4":
        return "video/mp4"
    case "mov":
        return "video/quicktime"
    case "avi":
        return "video/x-msvideo"
    case "mkv":
        return "video/x-matroska"
    
    // Default MIME type for unknown file types
    default:
        return "application/octet-stream"
    }
}

func getStorageUploadErrorHandler(snapshot: StorageTaskSnapshot) -> NSError? {
    if let error = snapshot.error as? NSError {
        switch (StorageErrorCode(rawValue: error.code)!) {
        case .objectNotFound:
            print("File doesn't exist \(error)")
            break
        case .unauthorized:
            print("User doesn't have permission to access file \(error)")
            break
        case .cancelled:
            print("User canceled the upload \(error)")
            break
            
        // TODO: Figure out any other cases to handle to make this exhaustive
        /* ... */

        case .unknown:
            print("Unknown error occurred, inspect the server response\(error)")
            break
        default:
            // TODO: Implement retry
            print("A separate error occurred: \(error)")
            break
        }
        
        return error
    }
    
    return nil
}

func buildFileAndMetaData(
    fileURLString: String
) -> (StorageReference, URL, StorageMetadata) {
    let file = URL(string: fileURLString)!
    let fileName = file.lastPathComponent
    
    // Initialize Firebase Storage Client
    let storage = Storage.storage()
    // Initialize Firebase reference
    let reference = storage.reference()

    // Create the file metadata
    let metadata = StorageMetadata()
    
    // Create Storage Reference
    let storageRef = reference.child("TikTokTutorialMedia/\(fileName)")
    
    // Get the file extension and determine the content type
    let fileExtension = file.pathExtension
    metadata.contentType = parseContentType(forFileExtension: fileExtension)
    
    return (storageRef, file, metadata)
}
