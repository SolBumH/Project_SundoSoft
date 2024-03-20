package servlet.impl;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.repository.TestRepository;
import servlet.util.Util;

@Service
public class TestService {
  
  @Autowired
  private TestRepository testRepository;
  
  @Autowired
  private Util util;

  public void dbTest() {
    List<Map<String, Object>> list = new ArrayList<>();
    try {
      BufferedReader br = new BufferedReader(
          new InputStreamReader(new FileInputStream("C:\\Users\\ppj21\\OneDrive\\Desktop\\프로젝트\\선도소프트\\MART_KEY_01\\mart_key_01_YYYY.txt"), "UTF-8"));
      String line;
      int i = 0;
      while ((line = br.readLine()) != null) {
        if (i == 4500) {
          testRepository.dbTest(list);
          list = new ArrayList<>();
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
      }
      br.close();
    } catch (IOException e) {
      e.printStackTrace();
    } 
    testRepository.dbTest(list);
  }
}
