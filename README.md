# 한솔범\_선도 프로젝트 : 에너지 사용량 조회 페이지

## 개요

- VWorld OpenAPI, GeoServer, Openlayers를 사용한 에너지 사용량에 따른 법정구역 별 지도 레이어 표출
- 개방 데이터를 활용, 수백만건의 에너지 데이터 DB 삽입 및 DB 테이블 설계
- 법정구역 별 사용량을 그래프와 표로 시각화

## 만든 목적

- 공간 데이터를 활용, 법정구역 별 에너지 사용량 시각화

## 일정

- 24.03.14 ~ 24.04.11
- 참여도 : 100% (팀 프로젝트이나 회사 요청으로 개인 개발 진행)

## 사용 기술 및 개발 환경

- OS : Windows 11
- Server : Apache Tomcat 8.5.99, Geoserver 2.22.5
- DB : PostgreSQL 14.4
- Framework/Language : eGovFrame 3.10, Mybatis, Openlayers, jQuery, JDK 1.8, JSP
- Tool : Eclipse, Git, GitHub

## 내용

### 파일 업로드

- 수백만 ~ 많게는 2천만이 넘는 데이터를 오류 없이 삽입하기
- 개방 데이터로 제공되는 txt 파일만 업로드 되도록 설계
- 파일 업로드 시 toast 창 출력, 완료 or 실패 시 결과 toast 창 출력

#### txt 파일 필터링

html `accept=".txt"` 코드로 1차 필터링
JS에서 다른 확장자 파일이 업로드 될 경우 2차 필터링 진행

```javascript
let fileName = $('#file').val().slice(-3).toLowerCase();

if (fileName === 'txt') { // 파일 확장자 체크
// 이후 ajax를 통해 파일 업로드 진행
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
```

#### 파일 업로드에서 겪은 시행착오

1. 메모리 오류 \
   파일 내용 한 줄 마다 DB 삽입 메소드를 한번씩 실행하였더니 OutOfMemory 오류 발생

![스크린샷 2024-04-03 113019](https://github.com/SolBumH/Project_SundoSoft/assets/148349713/4f407038-7af7-4840-86f9-a75ddd266e96)

해결방안 \
 **List에 Map으로 값을 담아 한번에 DB로 삽입**

2. Mybatis에서 한번에 삽입할 수 있는 파라미터 제한 오류\
   많은 데이터를 한번에 삽입하려 보니 Mybatis에서 한번에 삽입할 수 있는 데이터의 한계로 인해 삽입할 수 있는 데이터의 개수 제한이 있음

![스크린샷 2024-04-03 110629](https://github.com/SolBumH/Project_SundoSoft/assets/148349713/fec143f8-3817-4afc-9d9c-9cc35d9bdada)

해결방안\
List에 담는 Map의 개수를 제한하여 여러 번 실행

```java
BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream()));
String line;
int i = 0;
while ((line = br.readLine()) != null) {
  if (i == 4500) {
    fileUploadRepository.insertDB(list);
    list.clear();
    i = 0;
  }
  Map<String, Object> map = new HashMap<>();
  String[] str = line.split("\\|");
  map.put("yearMonthUse" ,str[0]);
  map.put("landLocation" ,str[1]);
    map.put("roadLandLocation" ,str[2]);
  map.put("sggCode" ,str[3]);
  map.put("bjdCode" ,str[4]);
  map.put("landCode" ,str[5]);
  map.put("bun" ,str[6]);
  map.put("ji" ,str[7]);
  map.put("newAddNumber" ,str[8]);
  map.put("newRoadCode" ,str[9]);
  map.put("newLandCode" ,str[10]);
  map.put("newbonbeon" , util.str2int(str[11]));
  map.put("newbubeon" , util.str2int(str[12]));
  map.put("usage" , util.str2int(str[13]));
  list.add(map);
  i++;
  result++;
}
br.close();
} catch (IOException e) {
  e.printStackTrace();
} finally {
  if (list.size() != 0) {
    fileUploadRepository.insertDB(list);
  }
}
return result;
}
```

파라미터 제한이 걸리지 않게 약 4500개의 객체를 List에 담아 Mybatis에서 반복문으로 삽입 실행

```html
<insert id="insertData" parameterType="list">
  insert into "TB_CARBON_B5" ("sggCode", "bjdCode", "usage") values
  <foreach collection="list" item="list" index="index" separator=",">
    (#{list.sggCode}, #{list.bjdCode}, #{list.usage})
  </foreach>
</insert>
```

#### 추가 고민

많은 데이터를 4500개씩 나누어 삽입하니 삽입 완료까지 많은 시간을 필요로 함

> 어떤 데이터가 실제로 필요한 지 고민

필요한 데이터를 3개로 압축시켜 한번에 넣을 수 있는 데이터가 4500개 -> 21000개로 상승

```java
Map<String, Object> map = new HashMap<>();
String[] str = line.split("\\|");
map.put("sggCode" ,str[3]);
map.put("bjdCode" ,str[4]);
map.put("usage" , util.str2int(str[13]));
list.add(map);
```

데이터 삽입 속도가 약 4 ~ 5배 상승됨을 확인 완료

#### AddBatch 사용해보기

파일 업로드의 더 빠른 방법을 찾기 위해 AddBatch 기능도 테스트 진행

```java
while ((line = br.readLine()) != null) {
  if (i == 2000000) {
    pstmt.executeBatch();
    pstmt.clearBatch();
    break;
  }
  if (i % 20000 == 0) {
    pstmt.executeBatch();
    pstmt.clearBatch();
  }
  String[] str = line.split("\\|");
  pstmt.setString(1, str[3]);
  pstmt.setString(2, str[4]);
  pstmt.setInt(3, util.str2int(str[13]));
  pstmt.addBatch();
  pstmt.clearParameters();
  i++;
}
```

속도 테스트를 위해 최대 200만 건으로 테스트해보았으나 기존보다 느린 성능으로 인해 Mybatis를 사용하는 것으로 최종 결정

![스크린샷 2024-04-12 145330](https://github.com/SolBumH/Project_SundoSoft/assets/148349713/cd92dfb0-ba34-4e95-9b9e-2f2d2d16ea86)
![스크린샷 2024-04-12 145709](https://github.com/SolBumH/Project_SundoSoft/assets/148349713/e9970032-5c24-4d9a-a7bc-3faa9b8e4545)

파일 업로드 Toast 구현

![파일업로드움짤](https://github.com/SolBumH/Project_SundoSoft/assets/148349713/4515b15f-c3b6-40ca-bb57-b3b0759e882f)

### Map 레이어 출력하기

배경지도 레이어와 법정구역 라인 레이어에 name을 추가하여 레이어 삭제를 직접 하드코딩으로 구현하지 않고 다른 레이어가 추가되어도 수정하지 않도록 기능 구현

```
let mapLayer = new ol.layer.Tile({
	  source : source,
	  properties : {name : 'mapLayer'}
});

let lineLayer = new ol.layer.Tile({
    source : lineSource,
    properties : {name : 'lineLayer'},
});

map.getOverlays().forEach(overlay => {
	map.removeOverlay(overlay);
});

```

Java와 ajax를 사용하여 페이지 로딩, Select 선택 시 option 내용 변경

```java
StringBuilder sb = new StringBuilder("https://api.vworld.kr/ned/data/admCodeList");
    sb.append("?format=json");
    sb.append("&numOfRows=17");
    sb.append("&key=" + getApiKey());
    sb.append("&domain=" + getApiDomain());

    URL url = new URL(sb.toString());
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Content-type", "application/json");

    JSONParser parser = new JSONParser();
    JSONObject jsonObj = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));

VWorld에서는 CORS 오류 우회를 위해 jsonp 방식을 사용

let data = {};
data.key = "${apiKey}";
data.domain = "${domain}";
data.admCode = sggAdmCode;
data.format = "json";
data.numOfRows = "200";
data.pageNo = "1";

$.ajax({
  type : "get",
  dataType : "jsonp",
  url : "http://api.vworld.kr/ned/data/admDongList",
  data : data,
  async : false,
  success : function(data) {
    $('.sggOption').remove();
    $('.bjdOption').remove();
    $('#sggList').append($('<option class="sggOption" value="0">-- 시, 군, 구 선택 --</option>'));
    $('#bjdList').append($('<option class="bjdOption" value="0">-- 읍, 면, 동 선택 --</option>'));
    let adm = data.admVOList.admVOList;
    for (let i = 0; i < adm.length; i++) {
      let sggHtml = $("<option></option>");
      sggHtml.attr('value', adm[i].admCode);
      sggHtml.attr('class', 'sggOption');
      sggHtml.append(adm[i].lowestAdmCodeNm);
      $('#sggList').append(sggHtml);
    }
  },
  error : function(xhr, stat, err) {}
});

```

시, 도 선택 시 시, 군, 구 목록이 변경되는 모습

![녹화_2024_04_03_15_39_58_613](https://github.com/SolBumH/Project_SundoSoft/assets/148349713/3b423d12-418d-4b7a-82bd-4bd6c149132b)

시, 군, 구 레이어와 오버레이 출력하는 모습

![녹화_2024_04_03_14_54_15_514](https://github.com/SolBumH/Project_SundoSoft/assets/148349713/e2269a96-40e6-4a64-bcf9-dae8602c7880)

# 감사합니다

<!--

# 해야할 일

---

# 기능 구현은 했으나 수정하고 싶은 것

- DB 입력 최적화하기 -> 최소한의 칼럼만 집어넣기

  - AddBatch 도 사용해봤는데, Mybatis에서 직접 ForEach하는 것이 조금 더 빠름
  - 200만 건 입력 시 20초 정도 차이

- 시군구, 법정동, 사용량만 넣고 이후 정보 조회는 ajax 로 조회하기

  - 예전 PreStatement 사용하는 것처럼 해보기
  - Mybatis 보다 빠른지 테스트

- GeoServer 레이어가 많이 느림, 어떻게 할 수 있을까

  - 캐시 레이어로 처리하려 하였으나, 다른 사용량이 들어오면 무용지물이 됨
  - 아직 처리하는 방법을 잘 모름
  - SQL 문을 수정하여 조금 더 빠르게 처리
  - Materialized View 를 사용하여 속도 개선, 인덱스는 파일 업로드 시 좀 느릴 듯

---

# 처리한 것

- ~~Map 레이어 출력~~

- ~~부족하지만 DB 입력~~

- ~~법정동 뷰 생성~~

  - DB 에 뷰 생성하기
  - GeoServer 에 Join 을 걸고 레이어 생성하기
  - 둘 중 뭐가 좋을 지 고민, 둘 다 새로운 데이터 업뎃 시 레이어 갱신됨

- ~~레이어 삭제 기능 구현~~

  - map 레이어에 name 을 넣고, name 이 map 레이어가 아닌 모든 레이어를 삭제 후 추가하는 방법

- ~~파일 업로드 기능 구현, 웬만한 방법 다 오류나는데 어떻게 처리할 수 있을까~~

  - pom dependency 기능 추가, bean 설정으로 해결, 이제 덜 까먹을 듯

- 시도, 시군구 뷰 만들기

  - ~~데이터가 많은지 저장이 안됨~~
    - ~~GeoServer 레이어 생성 시 오류나면서 생성시 안됨, SQL문은 확인해보았음~~
  - SQL 문을 수정하여 처리 완료
    - 기존에는 테이블끼리 조인 후 GroupBy 를 진행하였음
    - 지금은 Group By 를 먼저 진행한 테이블을 기준으로 join 하여 Group By 가 한번만 진행하도록 처리

- ~~레이어 클릭 시 사용량 출력~~

  - ~~값 받아오는 것 까지는 완료, 오버레이 띄우기~~

- ~~범례 기능 구현하기~~

  - QGIS 로 Natural Break 와 등간격 만들기
  - 추가적인 다른 좋은 것 생각해보기

- ~~홈페이지 CSS 하기~~

- ~~명령어 정리하기~~

- ~~우측 하단 범례 구분창 만들기~~
- ~~CDB_JENKSBINS 함수를 사용하여 범례를 만들어보기~~
- ~~NTILE 명령어를 이용하여 등간격 해보기~~
  - NTILE 은 등분위라서 곱셈을 이용하여 등간격 생성 완료

-->
