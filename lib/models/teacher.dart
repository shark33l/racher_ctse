class TeacherData {

  final String documentId;
  final String name;
  final String description;
  final List subjects;
  final List institutes;
  final String currentInstitute;
  final List academicInitials;
  num rating;
  final String displayPicture;
  final String coverPicture;
  int color;

  TeacherData({
    this.documentId,
    this.name,
    this.description,
    this.subjects,
    this.institutes,
    this.currentInstitute,
    this.academicInitials,
    this.rating,
    this.displayPicture,
    this.coverPicture,
    this.color
  });
  
}