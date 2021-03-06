class QuizModel {
  String?title;
  String?date;
  String?time;
  bool ?isQuizGame;

  Map<String, dynamic> ?questionMap;


  QuizModel({this.title, this.date, this.time, this.isQuizGame, this.questionMap});
  QuizModel.fromJson({required Map<String,dynamic> json,}){

    title=json['title'];
    date=json['date'];
    time=json['time'];
    isQuizGame=json['isQuizGame'];
   questionMap=json['questionMap'];


  }
  Map<String,dynamic>toMap() {
    return {
      'title': title,

      'date': date,
      'time': time,
      'isQuizGame': isQuizGame,
      'questionMap': questionMap,


    };
  }
}