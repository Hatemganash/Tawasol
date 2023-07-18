
import Foundation
import Firebase


enum FCollectionReferance : String {
    case User
    case Chat
}

func FirestoreReferance ( _ collectionRef : FCollectionReferance) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRef.rawValue)
}


