const ExamController = () => {
  $(document).on("click", ".examDelete", function(e) {
    e.preventDefault();
    var accountId = $(this).data('account-id');
    var examId = $(this).data('exam-id');
    var deletePath = "/manage/accounts/" + accountId + "/exams/" + examId;
    $("#DeleteConfirmationLink").attr("href", deletePath);
  });

  $(document).ready(function() {
    $("#search-exam-input").on('input', function() {
      $("#search-exam-btn").click();
    });
  });
}

export { ExamController };
