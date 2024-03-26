<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>파일업로드</title>
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
	<div id="linkbar" class="">
		<%@ include file="menu.jsp" %>
	</div>
	<div id="main" class="px-2">
		<h2 class="pageName">파일 업로드</h2>
		<h5>데이터는 최대 200만개 까지만 추가됩니다.</h5>
		<div class="">
			<form id="uploadForm" method="post" enctype="multipart/form-data">
				<input id="file" class="form-control" type="file" name="file"
					accept=".txt" />
			</form>
			<button id="uploadBtn" class="btn btn-outline-dark">업로드</button>
		</div>
	</div>
</body>
</html>