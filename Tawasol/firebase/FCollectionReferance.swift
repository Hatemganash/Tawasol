
import Foundation
import Firebase


enum FCollectionReferance : String {
    case User
    case Chat
    case Message
}

func FirestoreReferance ( _ collectionRef : FCollectionReferance) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRef.rawValue)
}


