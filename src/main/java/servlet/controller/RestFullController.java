package servlet.controller;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import servlet.util.APIUtil;

@RestController
public class RestFullController {

	@Autowired
	private APIUtil apiUtil;

	@RequestMapping(value = "/sdAPI.do", method = RequestMethod.GET)
	public JSONArray sdAPI(Model model) throws Exception {
		System.out.println("sdAPI 시작");
		// 시도 API 요청 주소
		StringBuilder sb = new StringBuilder("https://api.vworld.kr/ned/data/admCodeList");
		// API return 타입
		sb.append("?format=json");
		// API 검색건수
		sb.append("&numOfRows=17");
		// API 발급 키
		sb.append("&key=" + apiUtil.getApiKey());
		// API 발급 도메인
		sb.append("&domain=" + apiUtil.getApiDomain());

		URL url = new URL(sb.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	  conn.setRequestMethod("GET");
	  conn.setRequestProperty("Content-type", "application/json");

	  // json -> 자바 형태로 코드 변경하여 출력하기
    JSONParser parser = new JSONParser();
    JSONObject jsonObj = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));
    
    Map<String, Object> map = (Map<String, Object>) jsonObj.get("admVOList");
    JSONArray list =  (JSONArray) map.get("admVOList");
    //model.addAttribute("list", list);
    
    return list;
	}
	
	@RequestMapping(value = "/file.do", method = RequestMethod.POST)
	public String file(@RequestParam("file") MultipartFile file) {
	  System.out.println(file.getOriginalFilename());
	  return "123";
	}
}
