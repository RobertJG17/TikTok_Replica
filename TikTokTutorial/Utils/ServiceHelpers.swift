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

func setupUploadTasks(
    uploadTask: StorageUploadTask
) {
    // Listen for state changes, errors, and completion of the upload.
    uploadTask.observe(.resume) { snapshot in
        // !!!: Also fires when the upload starts!
        print("Upload resumed")
    }
    
    uploadTask.observe(.pause) { snapshot in
        print("Upload paused")
    }

    uploadTask.observe(.progress) { snapshot in
        // Upload reported progress
        let _ = 100.0 * Double(snapshot.progress!.completedUnitCount)
        / Double(snapshot.progress!.totalUnitCount)
    }

    uploadTask.observe(.success) { snapshot in
        // Upload completed successfully
        print("Upload succeeded \(snapshot.status)!")
    }

    uploadTask.observe(.failure) { snapshot in
        if let error = getStorageUploadErrorHandler(snapshot: snapshot) {
            print("in .failure closure, ERROR: \(error)")
        } else {
            print("UNHANDLED ERROR FROM .FAILURE CLOSURE")
        }
    }
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

func downloadFile(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    print("about to enter download file function")
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
            completion(.failure(error))
            return
        }
        completion(.success(data))
    }.resume()
}
