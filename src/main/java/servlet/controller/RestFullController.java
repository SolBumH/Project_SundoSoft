package servlet.controller;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import servlet.util.APIUtil;

@RestController
public class RestFullController {

	@Autowired
	private APIUtil apiUtil;

	@GetMapping("/sdAPI")
	public void sdAPI() throws IOException {
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
		System.out.println("ResponseCode : " + conn.getResponseCode());

		// JSON -> 자바
		
	}
}
