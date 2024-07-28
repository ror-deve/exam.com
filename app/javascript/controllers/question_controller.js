const QuestionController = () => {
  $(document).on("click", ".questionDelete", function(e) {
    e.preventDefault();
    var accountId = $(this).data('account-id');
    var examId = $(this).data('exam-id');
    var paperId = $(this).data('paper-id');
    var questionId = $(this).data('question-id');
    var deletePath = "/manage/accounts/" + accountId + "/exams/" + examId + "/papers/" + paperId + "/questions/" + questionId;
    $("#DeleteConfirmationLink").attr("href", deletePath);
  });
}

export { QuestionController };
