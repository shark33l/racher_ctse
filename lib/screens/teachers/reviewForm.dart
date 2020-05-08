import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:racher/models/review.dart';
import 'package:racher/models/teacher.dart';
import 'package:racher/models/user.dart';
import 'package:racher/services/reviewService.dart';
import 'package:racher/services/teacherService.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/shared/loading.dart';
import 'package:racher/shared/textStyles.dart';

class ReviewForm extends StatefulWidget {
  final TeacherData teacher;

  ReviewForm({Key key, @required this.teacher}) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();

  Review reviewData;
  // Form Values
  double rating = 0.0;
  String review;
  DateTime updatedDate;

  // Error Text
  String error = '';

  // Loading
  bool loading = false;
  bool loadingForDelete = false;

  @override
  Widget build(BuildContext context) {
    // Get Logged in User Id
    final user = Provider.of<User>(context);

    return StreamBuilder<Review>(
        stream: ReviewService(reviewId: user.uid + widget.teacher.documentId)
            .reviewById,
        builder: (context, snapshot) {
          updatedDate = null;
          if (snapshot.hasData) {
            reviewData = snapshot.data;
            updatedDate = snapshot.data.updatedDate;
          }
          return Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rate and Review',
                    style: Style.titleTextStyle,
                  ),
                  SizedBox(height: 5),
                  snapshot.hasData ? Text(
                    'Already Reviewed. Submit to update review or delete to remove review.',
                    style: Style.smallTextStyle,
                  ) : Container(),
                  snapshot.hasData ?
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      color: Colors.redAccent[400],
                      onPressed: () async {
                        setState(() {
                          loadingForDelete = true;
                          error = "";
                        });
                        num currentUserCount = widget.teacher.ratedUserCount;
                        double currentTeacherRating = widget.teacher.rating * currentUserCount;
                        if (updatedDate != null){
                          currentTeacherRating =
                                currentTeacherRating - snapshot.data.rating;
                          currentUserCount = currentUserCount -1;
                        }
                        double avgTeacherRating;
                        if(currentUserCount != 0){
                          avgTeacherRating =
                                currentTeacherRating /
                                    currentUserCount; 
                        } else {
                          avgTeacherRating = 0;
                        }
                        var data = {
                            "ratedUserCount": currentUserCount,
                            "rating": avgTeacherRating
                          };
                        await TeacherService().updateTeacherData(
                              widget.teacher.documentId, data);
                        Future result = await ReviewService().deleteReviewByID(user.uid, widget.teacher.documentId);

                        if(result == null){
                          setState(() {
                              loadingForDelete = false;
                              updatedDate = null;
                              review = null;
                            });
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            error= "Error when trying to delete";
                            loadingForDelete= false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      label: loadingForDelete
                          ? Loading()
                          : Text(
                              'Delete existing review',
                              style: TextStyle(color: Colors.white),
                            ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ) : Container(),
                  SizedBox(height: 20),
                  RatingBar(
                    initialRating: snapshot.hasData ? reviewData.rating : rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                    ),
                    onRatingUpdate: (value) {
                      setState(() {
                        rating = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      minLines: 3,
                      maxLines: 10,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Type your review about this teacher',
                          labelText: "Review"),
                      validator: (val) =>
                          val.isEmpty ? 'Please enInter a review' : null,
                      onChanged: (val) => setState(() => review = val)),
                  SizedBox(height: 20),
                  Expanded(child: Container()),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                  SizedBox(height: 12.0),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      color: Colors.deepPurple[700],
                      onPressed: () async {
                        setState(() {
                          loading = true;
                          error = "";
                        });
                        if (_formKey.currentState.validate() && rating != 0.0) {
                          bool isEditted = false;
                          num currentUserCount = widget.teacher.ratedUserCount;
                          double currentTeacherRating = widget.teacher.rating * currentUserCount;
                          if (updatedDate == null) {
                            currentUserCount++;
                          } else {
                            isEditted = true;
                            currentTeacherRating =
                                currentTeacherRating - snapshot.data.rating;
                          }
                          double avgTeacherRating =
                              (currentTeacherRating + rating) /
                                  currentUserCount;
                          var data = {
                            "ratedUserCount": currentUserCount,
                            "rating": avgTeacherRating
                          };
                          await TeacherService().updateTeacherData(
                              widget.teacher.documentId, data);
                          await ReviewService().updateReview(rating, review,
                              widget.teacher.documentId, user.uid, isEditted);
                          setState(() {
                            loading = false;
                            updatedDate = null;
                          });
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            error= "Please fill all required fields (Rating & Review)";
                            loading= false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      label: loading
                          ? Loading()
                          : Text(
                              'Submit Review',
                              style: TextStyle(color: Colors.white),
                            ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  )
                ]),
          );
        });
  }
}
