<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일업로드</title>
</head>
<body>
	<form action="./upload.do" method="post" enctype="multipart/form-data">
		<input type="file" name="file" accept=".txt" />
		<button>업로드</button>
	</form>

	<form action="read-file.do" method="post" accept="multipart/form-data">
		<input type="file" name="file">
		<button>읽기</button>
	</form>
</body>
</html>