<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>차트 보기</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- Remix ICON CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css"
	rel="stylesheet" />
<!-- 부트스트랩 CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="/resources/css/all.css" />
<!-- 제이쿼리 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 구글차트 -->
<script type="text/javascript"
	src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
//Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart']});

// Set a callback to run when the Google Visualization API is loaded.
google.charts.setOnLoadCallback(drawChart);

// Callback that creates and populates a data table,
// instantiates the pie chart, passes in the data and
// draws it.
function drawChart() {

  // Create the data table.
  let data = new google.visualization.DataTable();
  data.addColumn('string', '도시명');
  data.addColumn('number', 'KWh');
  data.addRows([ <c:forEach items="${usageList}" var="usage">
      ['${usage.cityNm}', ${usage.usage}],
    </c:forEach> ]);

  // Set chart options
  let options = {'title':'에너지 사용량',
                 'width':1000,
                 'height': 800};

  // Instantiate and draw our chart, passing in some options.
  let chart = new google.visualization.BarChart(document.getElementById('chart_div'));
  chart.draw(data, options);
}

function sggUsage() {
  sdValue = document.getElementById('sdList').options[document.getElementById('sdList').selectedIndex].value;
  if (sdValue != 0) {
    location.href="/chart.do?sdCode=" + sdValue;
  } else {
    alert("시도명을 선택하세요");
    return false;
  }
}

function reset() {
  location.href="/chart.do";
}
</script>
</head>
<body>
	<div id="linkbar">
		<%@ include file="menu.jsp"%>
	</div>
	<div id="main">
		<div class="pageName">차트</div>
		<div id="listDiv">
			<label for="sdList">시, 도 선택</label> <select id="sdList"
				class="form-select">
				<option value="0">--시, 도 선택--</option>
				<c:forEach items="${sdList }" var="list">
					<option class="" value="${list.sd_cd }">${list.sd_nm }</option>
				</c:forEach>
			</select>
			<button class="btn btn-outline-dark" id="sdUsageBtn"
				onclick="return sggUsage()">출력하기</button>
			<button class="btn btn-outline-dark" id="resetBtn" onclick="reset()">초기화</button>
		</div>
		<div class="chart">
			<div id="chart_div"></div>
			<div id="chart_table">
				<div class="text-end">단위 : KWh</div>
				<div class="chart_table">
					<table class="table">
						<thead>
							<tr>
								<th>도시명</th>
								<th>에너지 사용량</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${usageList }" var="usage">
								<tr>
									<td>${usage.cityNm }</td>
									<td><fmt:formatNumber value="${usage.usage }"
											pattern="###,###" /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>