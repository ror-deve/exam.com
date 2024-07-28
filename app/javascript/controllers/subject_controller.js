const SubjectController = () => {
  $(document).on("click", ".subjectDelete", function(e) {
    e.preventDefault();
    var accountId = $(this).data('account-id');
    var subjectId = $(this).data('subject-id');
    var deletePath = "/manage/accounts/" + accountId + "/subjects/" + subjectId;
    $("#DeleteConfirmationLink").attr("href", deletePath);
  });

  $(document).ready(function() {
    $("#search-subject-input").on('input', function() {
      $("#search-subject-btn").click();
    });
  });
}
export { SubjectController };
