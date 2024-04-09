<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파일 업로드</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- Remix ICON CDN -->
<link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet"/>
<!-- 부트스트랩 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<!-- 제이쿼리 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/css/all.css"/>
<script type="text/javascript">
$(document).ready(function(){
  $('#uploadBtn').on('click', function(){
    let fileName = $('#file').val().slice(-3).toLowerCase();
		
    if (fileName === 'txt') {
      let file = new FormData($('#uploadForm')[0]);
      let toastLive = document.getElementById('uploadToast');
      let toast = new bootstrap.Toast(toastLive);
      toast.show();
      $.ajax({
        url : '/upload.do',
        type : 'post',
        enctype : 'multipart/form-data',
        data : file,
       	dataType : 'text',
        cache : false,
        contentType : false,
        processData : false,
        success : function(result) {
          alert(result + " 건 입력 완료");
          $('#file').val(""); // input 창 초기화
          toast.hide();
          toastLive = document.getElementById('finishToast');
          toast = new bootstrap.Toast(toastLive);
          toast.show();
        },
        error : function(error) {
          $('#file').val(""); // input 창 초기화
          toast.hide();
          toastLive = document.getElementById('failToast');
          toast = new bootstrap.Toast(toastLive);
          toast.show();
        }
      });
    } else {
      alert('txt 파일만 등록 가능합니다.');
      $('#file').val("");
    }
  });
  
  $('.btn-close').on('click', function() {
    $(this).parent().parent().hide();
  });
});
</script>
</head>
<body>
	<div id="linkbar" class="">
		<%@ include file="menu.jsp" %>
	</div>
	<div id="uploadToast" class="toast top-30 start-50 translate-middle-x" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
    <div class="toast-header">
      <strong id="toast-message" class="me-auto">파일 업로드 중..</strong>
    </div>
	</div>
	<div id="finishToast" class="toast top-30 start-50 translate-middle-x" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
    <div class="toast-header">
      <strong id="toast-message" class="me-auto">파일 업로드 완료</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
	</div>
	<div id="failToast" class="toast top-30 start-50 translate-middle-x" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
    <div class="toast-header">
      <strong id="toast-message" class="me-auto">파일 업로드 실패</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
	</div>
	<div id="main">
		<div class="pageName">파일 업로드</div>
		<h5>데이터는 최대 200만개 까지만 추가됩니다.</h5>
		<div class="">
			<form id="uploadForm" method="post" enctype="multipart/form-data">
				<input id="file" class="form-control" type="file" name="file"
					accept=".txt" />
			</form>
			<button id="uploadBtn" class="btn btn-outline-dark">업로드</button>
		</div><!-- 업로드 form div 끝 -->
  </div>
</body>
</html>