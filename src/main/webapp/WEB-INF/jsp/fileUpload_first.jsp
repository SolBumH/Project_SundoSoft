<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파일업로드</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 부트스트랩 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- 제이쿼리 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
  $('#uploadBtn').on('click', function(){
    let fileName = $('#file').val().slice(-3).toLowerCase();
		
    if (fileName === 'txt') {
      let file = new FormData($('#uploadForm')[0]);
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
        },
        error : function(error) {
          alert('에러');
        }
      });
    } else {
      alert('txt 파일만 등록 가능합니다.');
    }
  });
});
</script>
</head>
<body>
	<%@ include file="menu.jsp" %>
	<form id="uploadForm" method="post" enctype="multipart/form-data">
		<input id="file" type="file" name="file" accept=".txt" />
	</form>
	<button id="uploadBtn">업로드</button>
</body>
</html>