const PaperController = () => {
  $(document).on("click", ".paperDelete", function(e) {
    e.preventDefault();
    var accountId = $(this).data('account-id');
    var examId = $(this).data('exam-id');
    var paperId = $(this).data('paper-id');
    var deletePath = "/manage/accounts/" + accountId + "/exams/" + examId + "/papers/" + paperId;
    $("#DeleteConfirmationLink").attr("href", deletePath);
  });
}

export { PaperController };
