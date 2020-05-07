import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racher/models/review.dart';

class ReviewService {
  final reviewId;

  ReviewService({this.reviewId});
  
  // Collection Reviews
  final CollectionReference reviewCollection = Firestore.instance.collection("reviews");

  // Review Map
  // For Single Review
  Review _reviewDataFromSnapshot(DocumentSnapshot snapshot){
    return Review(
      documentId: snapshot.data["documentId"],
      rating: snapshot.data["rating"],
      review: snapshot.data["review"],
      teacherId: snapshot.data["teacherId"],
      userId: snapshot.data["userId"],
      updatedDate: snapshot.data["updatedDate"].toDate(),
      createdDate: snapshot.data["updatedDate"].toDate()
      );
  }

  // For a list of Reviews
  List<Review> _reviewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Review(
      documentId: doc.data["documentId"],
      rating: doc.data["rating"],
      review: doc.data["review"],
      teacherId: doc.data["teacherId"],
      userId: doc.data["userId"],
      updatedDate: doc.data["updatedDate"].toDate(),
      createdDate: doc.data["updatedDate"].toDate()
      );
    }).toList();
  }

  // Create or update Review
  Future updateReview(double rating, String review, String teacherId, String userId, bool isEditted) async {

    var data = {};
    var dataIsNew = {
      "rating" : rating,
        "review" : review,
        "teacherId" : teacherId,
        "userId": userId,
        "updatedDate": DateTime.now(),
        "createdDate" : DateTime.now()
    };
    var dataIsEditted = {
      "rating" : rating,
        "review" : review,
        "teacherId" : teacherId,
        "userId": userId,
        "updatedDate": DateTime.now()
    };

    if(isEditted){
      data = dataIsEditted;
    } else {
      data = dataIsNew;
    }
    
    // Setting custom document Id for Reviews to call for update later
    String reviewDocumentId = userId+teacherId;
    return await reviewCollection.document(reviewDocumentId).setData(
      data, merge: true
    );
  }

// get Review by Id
  Stream<Review> get reviewById{
    return  reviewCollection.document(reviewId).snapshots()
    .map(_reviewDataFromSnapshot);
  }

// Get reviews of a specific teacher
  Stream<List<Review>> get specificTeacherReviews{
    return reviewCollection.where("teacherId", isEqualTo: reviewId).orderBy("updatedDate", descending: true).snapshots()
    .map(_reviewListFromSnapshot);
  }

// Get all Reviews
  Stream<List<Review>> get allReviews{
    return reviewCollection.orderBy("updatedDate", descending: true).snapshots()
    .map(_reviewListFromSnapshot);
  }
}