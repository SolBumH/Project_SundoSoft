package servlet.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import servlet.repository.FileUploadRepository;
import servlet.util.Util;

@Service
public class FileUploadService {
  
  @Autowired
  private FileUploadRepository fileUploadRepository;
  
  @Autowired
  private Util util;

  public int insertDB(MultipartFile file) {
    List<Map<String, Object>> list = new ArrayList<>();
    int result = 0;
    try {
      BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream()));
      String line;
      int i = 0;
      while ((line = br.readLine()) != null) {
        if (i == 21000) {
          fileUploadRepository.insertDB(list);
          list.clear();
          i = 0;
        }
        if (result == 1500000) {
          break;
        }
        Map<String, Object> map = new HashMap<>();
        String[] str = line.split("\\|");
//        map.put("yearMonthUse" ,str[0]);
//        map.put("landLocation" ,str[1]);
//        map.put("roadLandLocation" ,str[2]);
        map.put("sggCode" ,str[3]);
        map.put("bjdCode" ,str[4]);
//        map.put("landCode" ,str[5]);
//        map.put("bun" ,str[6]);
//        map.put("ji" ,str[7]);
//        map.put("newAddNumber" ,str[8]);
//        map.put("newRoadCode" ,str[9]);
//        map.put("newLandCode" ,str[10]);
//        map.put("newbonbeon" , util.str2int(str[11]));
//        map.put("newbubeon" , util.str2int(str[12]));
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

  public void deleteDb() {
    fileUploadRepository.deleteDb();
  }
}
