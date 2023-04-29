import Foundation
import UIKit
import ProgressHUD
import FirebaseStorage


let storage = Storage.storage()

class FileStorage {
    
    // MARK: - Images
    
    class func uploadImage (_ image : UIImage , directory : String , completion : @escaping (_ documentLink : String?) -> Void) {
        
        let storageREf = storage.reference(forURL: KFILEREFERANCE).child(directory)
        
        
        let imageData  = image.jpegData(compressionQuality: 0.5)
        
        var task : StorageUploadTask!
        task = storageREf.putData(imageData! , completion: { metaData , error in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("Error uploading image \(error!.localizedDescription)")
                return
            }
            storageREf.downloadURL { url, error in
                guard let dowenloadUrl = url else {
                    completion (nil)
                    return
                }
                completion(dowenloadUrl.absoluteString)
            }
        })
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
            
            
        }
        
    }
    
    class func saveFileLocally (fileData : NSData , fileName : String ) {
        let docUrl = getDocumentURL().appendingPathComponent(fileName , isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }
    
    
    
    
    
    // MARK: - Vedios
    
    
    
    
    
}

func getDocumentURL () -> URL {
    return FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).last!
}

func fileInDocumentDirectory(fileName : String) -> String {
    return getDocumentURL().appendingPathComponent(fileName).path
    
}

func fileExistsAtPsth(path : String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentDirectory(fileName: path))
}
