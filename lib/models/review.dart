class Review {

  String documentId;
  String review;
  double rating;
  String teacherId;
  String userId;
  DateTime updatedDate;
  DateTime createdDate;

  Review({
    this.documentId,
    this.review,
    this.rating,
    this.teacherId,
    this.userId,
    this.updatedDate,
    this.createdDate
  });
}