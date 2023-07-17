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
     
    class func dowenloadImg(imgUrl : String , completion : @escaping(_ image : UIImage?) -> Void) {
        let imageFileName = fileNameFrom(fileUrl: imgUrl)
        if fileExistsAtPsth(path: imageFileName){
            
            if let contentsOfFile =  UIImage(contentsOfFile: fileInDocumentDirectory(fileName: imageFileName)) {
                completion (contentsOfFile)
                
            } else {
                print("Couldnt convert local image ")
                completion (UIImage(named: "Avatar")!)
            }
        } else {
            
            if imgUrl != "" {
                let documentUrl = URL(string: imgUrl)
                let dowenloadQueue = DispatchQueue (label: "imageDowenloadQueue")
                
                dowenloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil {
                        
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    }else {
                        print("no document found in database")
                        completion(nil)
                    }
                }
            }
            
            
        }
        
    }
    
    
    // MARK: - Save file Locally
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
