// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholars_guide/features/quiz_upload/presentation/state_management/quiz_input/quiz_input_cubit.dart';
import 'package:scholars_guide/features/quiz_upload/presentation/state_management/quiz_input_page/quiz_input_page_bloc.dart';

// The question input card
class QuestionInputCard extends StatefulWidget {
  const QuestionInputCard({super.key, required this.questionCubit});

  final QuizInputCubit questionCubit;

  @override
  State<QuestionInputCard> createState() => _QuestionInputCardState();
}

class _QuestionInputCardState extends State<QuestionInputCard> {
  @override
  Widget build(BuildContext context) {
    QuizInputPageBloc quizInputPageBloc = context.read<QuizInputPageBloc>();

    TextEditingController questionController =
        TextEditingController(text: widget.questionCubit.state.question);

    questionController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: questionController.text.length,
      ),
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      height: 430,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange[100], // ! Panget UI
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                height: 200,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      borderSide: BorderSide(
                          color: quizInputPageBloc.revealBlanks
                              ? widget.questionCubit.state.questionNonEmpty
                                  ? Colors.black
                                  : Colors.red
                              : Colors.black,
                          width: 2),
                    ),
                    hintText: "Enter the question here",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: null,
                  expands: true,
                  controller: questionController,
                  onChanged: (questionInput) {
                    widget.questionCubit
                        .questionChanged(question: questionInput);
                  },
                ),
              ),
              QuestionInputOptions(
                questionCubit: widget.questionCubit,
                optionIndex: 0,
                revealBlank: quizInputPageBloc.revealBlanks &&
                    !widget.questionCubit.state.optionsNonEmpty[0],
              ),
              QuestionInputOptions(
                  questionCubit: widget.questionCubit,
                  optionIndex: 1,
                  revealBlank: quizInputPageBloc.revealBlanks &&
                      !widget.questionCubit.state.optionsNonEmpty[1]),
              QuestionInputOptions(
                  questionCubit: widget.questionCubit,
                  optionIndex: 2,
                  revealBlank: quizInputPageBloc.revealBlanks &&
                      !widget.questionCubit.state.optionsNonEmpty[2]),
              QuestionInputOptions(
                  questionCubit: widget.questionCubit,
                  optionIndex: 3,
                  revealBlank: quizInputPageBloc.revealBlanks &&
                      !widget.questionCubit.state.optionsNonEmpty[3]),
            ],
          )),
    );
  }
}

class QuestionInputOptions extends StatefulWidget {
  const QuestionInputOptions(
      {super.key,
      required this.optionIndex,
      required this.questionCubit,
      required this.revealBlank});

  final QuizInputCubit questionCubit;
  final int optionIndex;
  final bool revealBlank;

  @override
  State<QuestionInputOptions> createState() => _QuestionInputOptionsState();
}

class _QuestionInputOptionsState extends State<QuestionInputOptions> {
  bool correctAnswer = true;
  @override
  Widget build(BuildContext context) {
    TextEditingController optionController = TextEditingController(
        text: widget.questionCubit.state.options[widget.optionIndex]);

    optionController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: optionController.text.length,
      ),
    );

    return Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 30.0),
        width: MediaQuery.of(context).size.width * 0.70,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                        color: widget.revealBlank ? Colors.red : Colors.black,
                        width: 2),
                  ),
                  hintText: "Enter one of the options here",
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: optionController,
                onChanged: (optionInput) {
                  List<String> options =
                      List.from(widget.questionCubit.state.options);
                  options[widget.optionIndex] = optionInput;

                  List<bool> optionsNonEmpty =
                      List.from(widget.questionCubit.state.optionsNonEmpty);
                  optionsNonEmpty[widget.optionIndex] =
                      options[widget.optionIndex].isNotEmpty;

                  widget.questionCubit.optionChanged(
                      options: options, optionsNonEmpty: optionsNonEmpty);
                },
              ),
            ),
            IconButton(
              icon: Icon(correctAnswer
                  ? Icons.check_circle
                  : Icons.check_circle_outline_rounded),
              color: widget.optionIndex.toString() ==
                      widget.questionCubit.state.answerIndex
                  ? Colors.green
                  : Colors.black,
              onPressed: () {
                if (widget.optionIndex.toString() !=
                    widget.questionCubit.state.answerIndex) {
                  widget.questionCubit.answerChanged(
                      answerIndex: widget.optionIndex.toString());
                }
              },
            ),
          ],
        ));
  }
}
