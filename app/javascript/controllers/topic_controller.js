const TopicController = () => {
  $(document).on("click", ".topicDelete", function(e) {
    e.preventDefault();
    var accountId = $(this).data('account-id');
    var subjectId = $(this).data('subject-id');
    var topicId = $(this).data('topic-id');
    var deletePath = "/manage/accounts/" + accountId + "/subjects/" + subjectId + "/topics/" + topicId;
    $("#DeleteConfirmationLink").attr("href", deletePath);
  });

  $(document).ready(function() {
    $("#search-topic-input").on('input', function() {
      $("#search-topic-btn").click();
    });
  });
}

export { TopicController };
