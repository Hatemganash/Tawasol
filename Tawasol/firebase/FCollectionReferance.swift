
import Foundation
import Firebase


enum FCollectionReferance : String {
    case User
}

func FirestoreReferance ( _ collectionRef : FCollectionReferance) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRef.rawValue)
}


