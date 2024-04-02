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
          error: function(err) {
            console.log(err);
          }
        });
			});
    });
  </script>
</body>
</html>