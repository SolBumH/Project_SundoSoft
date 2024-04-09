<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>테스트용</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<button id="testBtn">테스트</button>
	<form id="uploadForm">
	<input type="file" name="file" accept=".txt"/>
	</form>
	<button id="fileBtn">파일보내기</button>

	<script type="text/javascript">
    $(function() {
      $('#testBtn').on('click', function() {
        $.ajax({
          url : '/cdbTest.do',
          type : 'post',
          success : function(result) {
            console.log(result);
            console.log("성공");
          },
          error : function(err) {
            console.log(err);
          }
        });
      });

      $('#fileBtn').on('click', function() {
        let file = new FormData($('#uploadForm')[0]);
        console.log("시작");
        $.ajax({
          url : '/testUpload.do',
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
      });
    });
  </script>
</body>
</html>