<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<title>map8</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- Remix ICON CDN -->
<link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet"/>
<!-- 부트스트랩 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<!-- OpenLayer 링크 -->
<script
	src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<!-- 제이쿼리 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?apiKey=${apiKey}&domain=${domain}"></script>
<script type="text/javascript" src="/resources/js/test.js"></script>
<link rel="stylesheet" href="/resources/css/all.css"/>
<script type="text/javascript">
let sdLayer; // 시도 레이어
let sggLayer; // 시군구 레이어
let sdLayerSource = new ol.source.TileWMS({}); // 시도 레이어의 소스 값
let sggLayerSource = new ol.source.TileWMS({}); // 시군구 레이어의 소스 값
let sdValue = 0; // 시도 선택 값
let sggValue = 0; // 시군구 선택 값
let overlayBjdnm; // 오버레이에 사용할 법정동 이름
let overlayUsage; // 오버레이에 사용할 사용량
let bumValue;

$(document).ready(function() {
  let source = new ol.source.XYZ({
	  url : 'http://api.vworld.kr/req/wmts/1.0.0/${apiKey}/Base/{z}/{y}/{x}.png'
	});
  
  let lineSource = new ol.source.TileWMS({
	  url : 'https://api.vworld.kr/req/wms?key=${apiKey}&domain=${domain}',
	  params : {
	    'layers' : ['lt_c_upisuq173','lt_c_adsido'],
	    'request' : 'GetMap',
	    'CRS' : 'EPSG:3857',
	    'bbox' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5],
	    'width' : '256',
	    'height' : '256',
	    },
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
		overlays : [],
	  view : view
		});
		
		$("#sdList").on("change", function() {
		  sdValue = document.getElementById('sdList').options[document.getElementById('sdList').selectedIndex].value;
		  sggValue = document.getElementById('sggList').options[document.getElementById('sggList').selectedIndex].value;
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
					$('#sggList').append($('<option class="sggOption" value="0">-- 시, 군, 구 선택 --</option>'));
					$('#bjdList').append($('<option class="bjdOption" value="0">-- 읍, 면, 동 선택 --</option>'));
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
				$('#sggList').append($('<option class="sggOption" value="0">-- 시, 군, 구 선택 --</option>'));
				$('#bjdList').append($('<option class="bjdOption" value="0">-- 읍, 면, 동 선택 --</option>'));
			}
		});

		$("#sggList").on("change",function() {
		  sggValue = document.getElementById('sggList').options[document.getElementById('sggList').selectedIndex].value;
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
						$('#bjdList').append($('<option class="bjdOption" value="0">-- 읍, 면, 동 선택 --</option>'));
						let sggAdm = data.admVOList.admVOList;
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
				$('#bjdList').append($('<option class="bjdOption" value="0">-- 읍, 면, 동 선택 --</option>'));
			}
		});
		
		$("#layerBtn").on('click', function() {
		  map.getAllLayers().forEach(layer => {
		  	if (layer.get('name') != 'mapLayer' && layer.get('name') != 'lineLayer') {
		  		map.removeLayer(layer);
		  	}
		  });
		  bumValue = $('#bumList option:selected').val();
		  let style;
		  if (bumValue == 1) {
		    style = 'natural';
		  } else if (bumValue == 2) {
		    style = 'dgg';
		  }
		    if (sggValue == 0) { // 시군구 선택이 안됐으면
		      sggLayerSource = new ol.source.TileWMS();
		      if (sdValue == 0) { // 시도 선택을 안했으면
		        alert("조회 할 구역을 선택 해 주세요.");
		      } else {
		      // 시도 else
		        sdLayerSource = new ol.source.TileWMS({
							url : 'http://localhost/geoserver/solbum/wms?service=WMS', // 1. 레이어 URL
							params : {
								'VERSION' : '1.1.0', // 2. 버전
								'LAYERS' : 'solbum:b5_sgg_mview', // 3. 작업공간:레이어 명
								'BBOX' : [ 1.3867446E7,3906626.5,1.4684053E7,4670269.5 ],
								'SRS' : 'EPSG:3857', // SRID
								'FORMAT' : 'image/png', // 포맷
								'CQL_FILTER' : "sgg_cd like '" + sdValue + "___'",
								'STYLES' : 'sgg_' + style
							},
							serverType : 'geoserver',
							});
		        
		        sdLayer = new ol.layer.Tile({
							source : sdLayerSource,
							properties : {name : 'sdLayer'},
		          opacity: 0.5
							});
		        map.addLayer(sdLayer);
		      // end 시도 else
		      }
		    } else {
		      // 시군구 else
		      sggLayerSource = new ol.source.TileWMS({
						url : 'http://localhost/geoserver/solbum/wms?service=WMS', // 1. 레이어 URL
						params : {
							'VERSION' : '1.1.0', // 2. 버전
							'LAYERS' : 'solbum:b5_bjd_mview', // 3. 작업공간:레이어 명
							'BBOX' : [ 1.386872E7,3906626.5,1.4428071E7,4670269.5 ],
							'SRS' : 'EPSG:3857', // SRID
							'FORMAT' : 'image/png', // 포맷
							'CQL_FILTER' : "bjd_cd like '" + sggValue + "___'",
							'STYLES' : 'bjd_' + style
						},
					serverType : 'geoserver'
					}); 
		        
		      sggLayer = new ol.layer.Tile({
						source : sggLayerSource, 
						properties : {name : 'sggLayer'},
						opacity: 0.7
					});
		    	map.addLayer(sggLayer);
		      // end 시군구 else
		    }
		});
		
		$('#delOverlayBtn').on('click', function() {
		  map.getOverlays().forEach(overlay => {
	  		map.removeOverlay(overlay);
	    });
		});
		
		map.on('singleclick', function (evt) {
		  map.getOverlays().forEach(overlay => {
		  		map.removeOverlay(overlay);
		  });
		  if (sggLayerSource.urls == null) {
		    alert("시, 군, 구를 출력 후 눌러주세요.");
		  } else {
	      let viewResolution = view.getResolution();
	      let coordinate = evt.coordinate;
	      let info = sggLayerSource.getFeatureInfoUrl(
	          coordinate, 
	          viewResolution, 
	          'EPSG:3857',
	          {'INFO_FORMAT': 'application/json'}
	        );
	      if (info) {
	        fetch(info).then(result => result.json())
	          .then(function(res) {
	            //console.log(res.features[0].properties);
	            if (res.features[0] == null) {
	              alert("정확한 위치를 클릭해주세요.");
	            } else {
	              overlayBjdnm = res.features[0].properties.bjd_nm
	              overlayUsage = res.features[0].properties.usage.toLocaleString('ko-KR');
	            }
	          });
      	  console.log(overlayBjdnm + " : " + overlayUsage);
	      }
	      
	      let mapOverlay = document.createElement('div');
	      mapOverlay.setAttribute('class', 'mapOverlay');
	      let bjd_nm = document.createElement('div');
	      bjd_nm.setAttribute('class', 'bjd_nm');
	      mapOverlay.appendChild(bjd_nm);
	      let bjd_usage = document.createElement('div');
	      bjd_usage.setAttribute('class', 'bjd_usage');
	      mapOverlay.appendChild(bjd_usage);
	      document.body.appendChild(mapOverlay);
	      bjd_nm.innerHTML = '<div>지역 : ' + overlayBjdnm + '</div>';
	      bjd_usage.innerHTML = '<div>사용량 : ' + overlayUsage + ' KWh</div>';
	      
	      let overlay = new ol.Overlay({
	          element: mapOverlay,
	        });
	      map.addOverlay(overlay);
	      overlay.setPosition(coordinate);
		  }
	});
});
</script>
</head>
<body>
	<div id="linkbar">
	<%@ include file="menu.jsp" %>
	</div>
	<div class="main">
		<div class="pageName">지도</div>
		<div>
			<div id="listDiv">
				<div class="sdDiv">
					<label for="sdList">시, 도 선택</label>
				  <select id="sdList" class="form-select">
				  	<option value="0">-- 시, 도 선택 --</option>
				  	<c:forEach items="${sdList }" var="sd">
				  		<option value="${sd.admCode }">${sd.admCodeNm }</option>
			  		</c:forEach>
			  	</select>
				</div>
				<div class="sggDiv">
					<label for="sggList">시, 군, 구 선택</label>
				  <select id="sggList" class="form-select">
					  <option class="sggOption" value="0">-- 시, 군, 구 선택 --</option>
				  </select>
				</div>
				<div class="bumDiv">
					<label for="bumList">범례 선택</label>
					<select id="bumList" class="form-select">
						<option class="bumOption" value="1">Natural Break</option>
						<option class="bumOption" value="2">등간격</option>
					</select>
				</div>
				<!-- <select id="bjdList"><option class="bjdOption" value="0">--읍, 면, 동 선택--</option></select> -->
				<button id="layerBtn" class="btn btn-outline-dark">출력하기</button>
				<button id="delOverlayBtn" class="btn btn-outline-dark">오버레이 삭제하기</button>
			</div>
		</div>
		<div class="mapDiv">
			<div id="map" class="map"></div>
			<div id="info" class="info"></div>
		</div>
	</div>
</body>
</html>