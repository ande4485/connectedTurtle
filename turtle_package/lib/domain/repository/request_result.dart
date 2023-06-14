enum  AnswerRequest{
  ok,
  userNotFound,
  userAlreadyExist,
  error
}
class ResultRequest{
 final List<dynamic>? values;
 final AnswerRequest answer;

 ResultRequest({required this.answer, this.values});

}
