<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>브이월드 오픈API</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- OpenLayer 링크 -->
<script
	src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<!-- 제이쿼리 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?apiKey=${apiKey}&domain=${domain}"></script>
<script type="text/javascript" src="/resources/js/test.js"></script>
<style>
.map {
	height: 800px;
	width: 100%;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
  let source = new ol.source.XYZ({
	  url : 'http://api.vworld.kr/req/wmts/1.0.0/${apiKey}/Base/{z}/{y}/{x}.png'
	});
  
  let lineSource = new ol.source.TileWMS({
	  // url : 'http://api.vworld.kr/req/wmts/1.0.0/${apiKey}/Base/{z}/{y}/{x}.png',
	  url : 'https://api.vworld.kr/req/wms?key=${apiKey}&domain=${domain}',
	  params : {
	    'layers' : ['lt_c_upisuq173','lt_c_adsido'],
	    'request' : 'GetMap',
	    'CRS' : 'EPSG:3857',
	    'bbox' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5],
	    'width' : '256',
	    'height' : '256',
	    },
    // crossOrigin : 'use-credentials'
	});
  
  let lineLayer = new ol.layer.Tile({
    source : lineSource,
    properties : {name : 'lineLayer'},
    opacity: 0.5
  });
	
	let mapLayer = new ol.layer.Tile({
	  source : source,
	  properties : {name : 'mapLayer'}
	});
	
	let view = new ol.View({ 
		center : ol.proj.fromLonLat([ 127.8, 36.2 ]),
		zoom : 8,
		enableRotation : false // alt+shift+드래그 남북 고정되지 않는 회전 막기
	});
	
	const map = new ol.Map({ 
		target : 'map',
		layers : [ mapLayer, lineLayer ],
	  view : view
		});
		
		$("#sdList").on("change", function() {
			let admCode = $(this).val();
			if (admCode != 0) {
				let data = {};
				data.key = "${apiKey}"; /* key */
				data.domain = "${domain}"; /* domain */
				data.admCode = admCode;
				data.format = "json"; /* 응답결과 형식(json) */
				data.numOfRows = "100"; /* 검색건수 (최대 1000) */
				data.pageNo = "1"; /* 페이지 번호 */

			$.ajax({
				type : "get",
				dataType : "jsonp",
				url : "http://api.vworld.kr/ned/data/admSiList",
				data : data,
				async : false,
				success : function(data) {
					$('.sggOption').remove();
					$('.bjdOption').remove();
					$('#sggList').append($('<option class="sggOption" value="0">--시, 군, 구 선택--</option>'));
					$('#bjdList').append($('<option class="bjdOption" value="0">--읍, 면, 동 선택--</option>'));
					let adm = data.admVOList.admVOList;
					//console.log(adm[0].lowestAdmCodeNm);
					for (let i = 0; i < adm.length; i++) {
						let sggHtml = $("<option></option>");
						sggHtml.attr('value', adm[i].admCode);
						sggHtml.attr('class', 'sggOption');
						sggHtml.append(adm[i].lowestAdmCodeNm);
						$('#sggList').append(sggHtml);
					}
				},
				error : function(xhr, stat, err) {
				}
			});
			} else {
				$('.sggOption').remove();
				$('.bjdOption').remove();
				$('#sggList').append($('<option class="sggOption" value="0">--시, 군, 구 선택--</option>'));
				$('#bjdList').append($('<option class="bjdOption" value="0">--읍, 면, 동 선택--</option>'));
			}
		});

		$("#sggList").on("change",function() {
			let sggAdmCode = $(this).val();
			if (sggAdmCode != 0) {
				let data = {};
				data.key = "${apiKey}"; /* key */
				data.domain = "${domain}"; /* domain */
				data.admCode = sggAdmCode;
				data.format = "json"; /* 응답결과 형식(json) */
				data.numOfRows = "200"; /* 검색건수 (최대 1000) */
				data.pageNo = "1"; /* 페이지 번호 */

				$.ajax({
					type : "get",
					dataType : "jsonp",
					url : "http://api.vworld.kr/ned/data/admDongList",
					data : data,
					async : false,
					success : function(data) {
						$('.bjdOption').remove();
						$('#bjdList').append($('<option class="bjdOption" value="0">--읍, 면, 동 선택--</option>'));
						let sggAdm = data.admVOList.admVOList;
						//console.log(adm[0].lowestAdmCodeNm);
						for (let i = 0; i < sggAdm.length; i++) {
							let bjdHtml = $("<option></option>");
							bjdHtml.attr('value', sggAdm[i].admCode);
							bjdHtml.attr('class', 'bjdOption');
							bjdHtml.append(sggAdm[i].lowestAdmCodeNm);
							$('#bjdList').append(bjdHtml);
						}
					},
					error : function(xhr, stat, err) {
					}
				});
			} else {
				$('.bjdOption').remove();
				$('#bjdList').append($('<option class="bjdOption" value="0">--읍, 면, 동 선택--</option>'));
			}
		});
		
		$("#layerBtn").on('click', function() {
		  map.getAllLayers().forEach(layer => {
		  	if (layer.get('name') != 'mapLayer' && layer.get('name') != 'lineLayer') {
		  		map.removeLayer(layer);
		  	}
		  });
		  let sdValue = document.getElementById('sdList').options[document.getElementById('sdList').selectedIndex].value;
		  let sggValue = document.getElementById('sggList').options[document.getElementById('sggList').selectedIndex].value;
		  // let bjdValue = document.getElementById('bjdList').options[document.getElementById('bjdList').selectedIndex].value;
		  //map.removeLayer(sggLayer);
		  //map.removeLayer(bjdLayer);
		  // alert(bjdOption.options[bjdOption.selectedIndex].value);
		  // alert("sd : " + sdValue + "\nsgg : " + sggValue + "\nbjd : " + bjdValue);
		  // if (bjdValue == 0) { // 법정동이 선택이 안됐으면
		    if (sggValue == 0) { // 시군구 선택이 안됐으면
		      if (sdValue == 0) { // 시도 선택을 안했으면
		        alert("조회 할 구역을 선택 해 주세요.");
		      } else {
		      // 시도 else
		        let sdLayer = new ol.layer.Tile({
							source : new ol.source.TileWMS({
								url : 'http://localhost/geoserver/solbum/wms?service=WMS', // 1. 레이어 URL
								params : {
									'VERSION' : '1.1.0', // 2. 버전
									'LAYERS' : 'solbum:tl_sgg', // 3. 작업공간:레이어 명
									'BBOX' : [ 1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5 ],
									'SRS' : 'EPSG:3857', // SRID
									'FORMAT' : 'image/png', // 포맷
									'CQL_FILTER' : "sgg_cd like '" + sdValue + "___'",
								},
								serverType : 'geoserver',
								}),
								properties : {name : 'sdLayer'},
		            opacity: 0.4
							});
		        map.addLayer(sdLayer);
		        console.log(sdLayer);
		      // end 시도 else
		      }
		    } else {
		      // 시군구 else
		      let sggLayer = new ol.layer.Tile({
						source : new ol.source.TileWMS({
							url : 'http://localhost/geoserver/solbum/wms?service=WMS', // 1. 레이어 URL
							params : {
								'VERSION' : '1.1.0', // 2. 버전
								'LAYERS' : 'solbum:tl_bjd_view', // 3. 작업공간:레이어 명
								'BBOX' : [1.387148932991382E7,3910407.083927817,1.46800091844669E7,4666488.829376992],
								'SRS' : 'EPSG:3857', // SRID
								'FORMAT' : 'image/png', // 포맷
								'CQL_FILTER' : "bjd_cd like '" + sggValue + "___'",
							},
						serverType : 'geoserver'
						}),
						properties : {name : 'sggLayer'},
						opacity: 0.6
					});
		      console.log(sggLayer);
		    	map.addLayer(sggLayer);
		      // end 시군구 else
		    }
		  /* } else {
		    // 법정동 else
		    let bjdLayer = new ol.layer.Tile({
					source : new ol.source.TileWMS({
					url : 'http://localhost/geoserver/solbum/wms?service=WMS', // 1. 레이어 URL
					params : {
						'VERSION' : '1.1.0', // 2. 버전
						'LAYERS' : 'solbum:tl_bjd_view', // 3. 작업공간:레이어 명
						'BBOX' : [1.387148932991382E7,3910407.083927817,1.46800091844669E7,4666488.829376992],
						'SRS' : 'EPSG:3857', // SRID
						'FORMAT' : 'image/png', // 포맷
						'CQL_FILTER' : 'bjd_cd=' + bjdValue
					},
					serverType : 'geoserver',
					}),
					properties : {name : 'bjdLayer'},
					opacity: 0.8
				});
		    map.addLayer(bjdLayer);
		    // end 법정동 else
		  } */
		});
		
		$('#ajaxBtn').on('click', function() {
		  $.ajax({
		    type : 'post',
		    dataType : 'json',
		    url : '/ajaxTest.do',
		    ContentType : "application/json",
		    success : function(result) {
		      alert(result);
		      console.log(result);
		    },
		    error : function(error) {
		      console.log(error);
		    }
		  });
		});
		
		map.on('singleclick', function (evt) {
	    document.getElementById('info').innerHTML = '';
	    let viewResolution = view.getResolution();
	    // console.log(viewResolution);
	    // console.log(sdLayer);
	    let info = lineSource.getFeatureInfoUrl(
	        evt.coordinate,
	        viewResolution,
	        'EPSG:3857',
	        {'INFO_FORMAT': 'text/html'},
	      );
	    console.log(info);
	    if (info) {
	        document.getElementById('info').innerHTML =
	          '<iframe width="100%" seamless="" src="' + info + '"></iframe>';
	    }
	});
});
</script>
</head>
<body>
	<div style="width: 1000px;">
		<div>
			<div id="map" class="map"></div>
			<div id="info" class="info"></div>
		</div>
		<div>
			<div id="listDiv">
				<select id="sdList">
					<option value="0">--시, 도 선택--</option>
					<c:forEach items="${sdList }" var="sd">
						<option value="${sd.admCode }">${sd.admCodeNm }</option>
					</c:forEach>
				</select>
				<select id="sggList">
					<option class="sggOption" value="0">--시, 군, 구 선택--</option>
				</select>
				<!-- <select id="bjdList"><option class="bjdOption" value="0">--읍, 면, 동 선택--</option></select> -->
				<button id="layerBtn">출력하기</button>
				<button id="ajaxBtn">하기</button>
			</div>
		</div>
	</div>
</body>
</html>