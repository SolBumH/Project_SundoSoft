<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>차트보기</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>	
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
	<%@ include file="menu.jsp" %>
	<div>
	  <select id="sdList">
		  <option value="0">--시, 도 선택--</option>
		  <c:forEach items="${sdList }" var="list">
			  <option class="" value="${list.sd_cd }">${list.sd_nm }</option>
		  </c:forEach>
	  </select>
  	<button id="sdUsageBtn" onclick="return sggUsage()">출력하기</button>
  	<button id="resetBtn" onclick="reset()">초기화</button>
	</div>
	<div id="chart_div"></div>
	<table>
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
				<td><fmt:formatNumber value="${usage.usage }" pattern="###,###"/></td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>