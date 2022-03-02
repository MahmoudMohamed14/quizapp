import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/cubit_app/cubit_app.dart';
import 'package:quizapp/layout/cubit/cubit_layout.dart';
import 'package:quizapp/layout/cubit/states_layout.dart';
import 'package:quizapp/models/answer_student_model.dart';
import 'package:quizapp/shared/componant/componant.dart';
import 'package:quizapp/shared/constant/constant.dart';
import 'package:quizapp/shared/network/local/cache_helper.dart';

class QuizScreen extends StatelessWidget {
  List answerList=[];
  List questionList=[];
  List correctAnswer=[];
  int myAnswer=0;
  String ?QuizId;




  QuizScreen({required this.answerList, required this.questionList, required this.correctAnswer,this.QuizId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        List  bodyList=[
          quizBody(context),
          answerStudentWidget(context: context)

        ];
        return  Scaffold(
          appBar: AppBar(),
          body: CubitApp.get(context).currentUser.isTeacher!?bodyList[cubit.indexForQuiz]:quizBody(context),
          bottomNavigationBar:CubitApp.get(context).currentUser.isTeacher!?
          BottomNavigationBar(
            currentIndex:cubit.indexForQuiz ,
            onTap: (index){
             cubit. changeBottomNavForQuiz(index: index);

            },
            items:  const  [
              BottomNavigationBarItem(icon:Icon(Icons.quiz_outlined),label: 'Quiz'),
              BottomNavigationBarItem(icon:Icon(Icons.question_answer_outlined),label: 'StudentAnswer'),

            ],
          ):SizedBox(),
        );
      } ,

    );
  }
  Widget quizBody(context)=> SingleChildScrollView(

    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
              itemBuilder: (context,index)=>buildQuestionItem(
                  context: context,
                  counter: CubitLayout.get(context).counterList[index],
                  correctAnswer: correctAnswer[index],
                  question: questionList[index]
                  ,answerList: answerList[index],
                  index: index
              ),
              separatorBuilder: (context,index)=>const SizedBox(height: 20,),
              itemCount: questionList.length),
        const  SizedBox(height: 20,),
          defaultButton(onPress: (){

              print('myAnswer = '+myAnswer.toString());
              CubitLayout.get(context).upLoadingStudentAnswer(context: context,quizId:QuizId.toString() , myAnswer: '$myAnswer/${questionList.length}');
              CacheHelper.putData(key: QuizId!+globalUserModel!.email!, value:true);




          }, name: 'submit')
        ],
      ),
    ),
  );
  Widget answerStudentWidget({context})=>ConditionalBuilder(
      condition: CubitLayout.get(context).listAnswerStudentModel.isNotEmpty,
      builder: (context)=>Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context,index)=>answerStudentBuildItem(context: context,answerModel: CubitLayout.get(context).listAnswerStudentModel[index]),
            separatorBuilder: (context,index)=>const SizedBox(height: 20,),
            itemCount:CubitLayout.get(context).listAnswerStudentModel.length),
      ),
      fallback: (context)=> const Center(
        child: CircularProgressIndicator(),
      ));
  Widget answerStudentBuildItem({context,required AnswerStudentModel answerModel}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(top: 10,bottom: 10,end: 20 ),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all()


          ),

          child: Row(

            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${answerModel.name}',maxLines:1,style: Theme.of(context).textTheme.bodyText1!,),
                    Text('${answerModel.email}',maxLines:1,style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16,color: Colors.black54),)
                  ],
                ),
              )),
              Text('${answerModel.myAnswer}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: mainColor),)



            ],
          ),
        )
      ],
    );
  }
  Widget buildQuestionItem({
    context,
    required String question,
    required List answerList,
    required String correctAnswer,
    required int counter,
    required int index,

  }){



    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Q${index+1}:',style: Theme.of(context).textTheme.headline1,
            ),
            const  SizedBox(width: 5,),
            Expanded(child: Text(
              ' $question'
              ,style: Theme.of(context).textTheme.headline1
              ,textAlign: TextAlign.start,
            ),

            ),

          ],
        ),
        const SizedBox(height: 20,),
      if(answerList[0]!='null')

        Column(
          children: [
            InkWell(
              onTap: (){
                if(CubitLayout.get(context).counterList[index]==0) {
                  CubitLayout.get(context).selectOption(option: answerList[0], index: index);
                 if(CubitLayout.get(context).optionSelectList[index]==answerList[0]&&CubitLayout.get(context).optionSelectList[index]==correctAnswer)  {
                   myAnswer+=1;
                 }


                }
                  print('myAnswer = '+myAnswer.toString());

                CubitLayout.get(context).counterList[index]=1;



              },
              splashColor: mainColor,

              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,


                decoration: BoxDecoration(
                  color:   CubitLayout.get(context).optionSelectList[index]==answerList[0]? CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                    border: Border.all(color: mainColor),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Text('${answerList[0]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),

        if(answerList[1]!='null')
          Column(
            children: [
              InkWell(
                onTap: (){
                  if(CubitLayout.get(context).counterList[index]==0) {
                    CubitLayout.get(context).selectOption(option: answerList[1], index: index);
                    if(CubitLayout.get(context).optionSelectList[index]==answerList[1]&&CubitLayout.get(context).optionSelectList[index]==correctAnswer)  {
                      myAnswer+=1;
                    }

                  }
                print('myAnswer = '+myAnswer.toString());
                  CubitLayout.get(context).counterList[index]=1;


                },
              splashColor: mainColor,

              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color:CubitLayout.get(context).optionSelectList[index]==answerList[1]?CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                    border: Border.all(color: mainColor),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Text('${answerList[1]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
              ),
        ),
              const SizedBox(height: 20,),
            ],
          ),

        if(answerList[2]!='null')
          Column(
            children: [
              InkWell(
                onTap: (){
                  if(CubitLayout.get(context).counterList[index]==0) {
                    CubitLayout.get(context).selectOption(option: answerList[2], index: index);
                    if(CubitLayout.get(context).optionSelectList[index]==answerList[2]&&CubitLayout.get(context).optionSelectList[index]==correctAnswer)  {
                      myAnswer+=1;
                    }


                  }
                  print('myAnswer = '+myAnswer.toString());
                  CubitLayout.get(context).counterList[index]=1;
                },
              splashColor: mainColor,

              child: Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color:CubitLayout.get(context).optionSelectList[index]==answerList[2]?CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                    border: Border.all(color: mainColor),
                    borderRadius: BorderRadius.circular(20)

                ),
                child: Text('${answerList[2]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
              ),
        ),
              const SizedBox(height: 20,),
            ],
          ),

        if(answerList[3]!='null')
          InkWell(
            onTap: (){
              if(CubitLayout.get(context).counterList[index]==0) {
                CubitLayout.get(context).selectOption(option: answerList[3], index: index);
                if(CubitLayout.get(context).optionSelectList[index]==answerList[3]&&CubitLayout.get(context).optionSelectList[index]==correctAnswer)  {
                  myAnswer+=1;
                }

              }

              print('myAnswer = '+myAnswer.toString());
              CubitLayout.get(context).counterList[index]=1;

            },
          splashColor: mainColor,

          child: Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: CubitLayout.get(context).optionSelectList[index]==answerList[3]?CubitLayout.get(context).optionSelectList[index]==correctAnswer?Colors.green:Colors.red:Colors.white,
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(20)

            ),
            child: Text('${answerList[3]}',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54),),
          ),
        ),


      ],

    );
  }
}