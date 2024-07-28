const BatchController = () => {
  $(document).on("click", ".batchDelete", function(e) {
    e.preventDefault();
    var accountId = $(this).data('account-id');
    var batchId = $(this).data('batch-id');
    var deletePath = "/manage/accounts/" + accountId + "/batches/" + batchId;
    $("#DeleteConfirmationLink").attr("href", deletePath);
  });
}

export { BatchController };
