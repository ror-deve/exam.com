const StudentsController = () => {
  $(document).ready(function() {
    $("#search-student-input").on('input', function() {
      var query = $(this).val();
      $("#search-student-btn").click();
    });
  });
  
  $(document).on("click", ".studentDelete", function(e) {
    e.preventDefault();
    var accountId = $(this).data('account-id');
    var batchId = $(this).data('batch-id');
    var studentId = $(this).data('student-id');
    var deletePath = "/manage/accounts/" + accountId + "/batches/" + batchId + "/students/" + studentId;
    $("#DeleteConfirmationLink").attr("href", deletePath);
  });

  $("#SaveProfileButton").on("click", function () {
    var isValid = true;
    $("#UpdateForm .form-control").each(function () {
      if ($(this).val() === "") {
        isValid = false;
        return false;
      }
    });
    if (!isValid) {
      $("#EditUserProfileForm")[0].classList.add("was-validated");
    } else {
      $(".loading-overlay")[0].className = "loading-overlay is-active";
    }
  });

  // Start upload preview image - using croppie
  let fileInput = document.getElementById("profileImage");
  let uploadSubmitButton = document.getElementById("uploadImageButton");

  var $uploadCrop, tempFilename, rawImg, imageId;
  function readFile(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $(".upload-demo").addClass("ready");
        $("#cropImagePop").modal("show");
        rawImg = e.target.result;
      };
      reader.readAsDataURL(input.files[0]);
    } else {
      console.log("Sorry - you're browser doesn't support the FileReader API");
    }
  }

  $uploadCrop = $("#upload-demo").croppie({
    viewport: {
      width: 150,
      height: 200,
    },
    enforceBoundary: false,
    enableExif: true,
  });

  $("#cropImagePop").on("shown.bs.modal", function () {
    // alert('Shown pop');
    $uploadCrop
      .croppie("bind", {
        url: rawImg,
      })
      .then(function () {
        console.log("jQuery bind complete");
      });
  });

  $(".item-img").on("change", function () {
    imageId = $(this).data("id");
    tempFilename = $(this).val();
    $("#cancelCropBtn").data("id", imageId);
    readFile(this);
  });

  $("#cropImageBtn").on("click", function (ev) {
    $uploadCrop
      .croppie("result", {
        type: "base64",
        format: "jpeg",
        size: { width: 150, height: 200 },
      })
      .then(function (resp) {
        file = dataURLtoBlob(resp);
        fileObj = new File([file], Math.random().toString(36).substring(2, 15));
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(fileObj);
        fileInput.value = "";
        fileInput.files = dataTransfer.files;
        $("#cropImagePop").modal("hide");
        uploadSubmitButton.click();
      });
  });

  function dataURLtoBlob(dataurl) {
    var arr = dataurl.split(","),
      mime = arr[0].match(/:(.*?);/)[1],
      bstr = atob(arr[1]),
      n = bstr.length,
      u8arr = new Uint8Array(n);
    while (n--) {
      u8arr[n] = bstr.charCodeAt(n);
    }
    return new Blob([u8arr], { type: mime });
  }
  // End upload preview image

  $(document).on('submit', '#import-form', function(e) {
    e.preventDefault(); // Prevent normal form submission

    $.ajax({
      type: $(this).attr('method'),
      url: $(this).attr('action'),
      data: new FormData(this),
      dataType: 'script',
      contentType: false,
      processData: false,
    });
  });
};
export { StudentsController };
