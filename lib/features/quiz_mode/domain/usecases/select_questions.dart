import 'dart:math';

import '../../../../core/models/question_model.dart';
import '../../data/repositories/quiz_mode_repository_impl.dart';

class ChooseQuestions {
  ChooseQuestions({required this.subj, required this.numQuestions});

  final SUBJ subj;
  final int numQuestions;

  Future<List<Question>> choose() async {
    List<Question> totalQuestions =
        await const QuizModeRepositoryImpl().collectQuestions(subj: subj);
    totalQuestions.shuffle(Random());
    // TODO: randomize the choices as well for each question

    return totalQuestions.sublist(
        0,
        numQuestions < totalQuestions.length
            ? numQuestions
            : totalQuestions.length);
  }

  Future<Map<SUBJ, List<Question>>> chooseAll() async {
    Map<SUBJ, List<Question>> allQuestions = {};
    for (var subj in SUBJ.values) {
      allQuestions[subj] = await choose();
    }
    return allQuestions;
  }
}
