package servlet.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Arrays;
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
        if (result == 2000000) {
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

  public void updateDB() {
    fileUploadRepository.updateDB();
  }
  
  public int insertDBTest(MultipartFile file) throws Exception {
    Class.forName("org.postgresql.Driver");
    // Class.forName("net.sf.log4jdbc.DriverSpy"); // Log 남는 class
    Connection conn = DriverManager.getConnection(url, id, pw);
    PreparedStatement pstmt = null;
    String sql = "insert into \"TB_CARBON_B5\" (\"sggCode\", \"bjdCode\", \"usage\")" + 
        " values (?, ?, ?)";
    
    pstmt = conn.prepareStatement(sql);
    
    int i = 0;
    try {
      BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream()));
      String line;
      while ((line = br.readLine()) != null) {
        if (i == 2000000) {
          pstmt.executeBatch();
          pstmt.clearBatch();
          // conn.commit(); 
          break;
        }
        if (i % 10000 == 0) {
          pstmt.executeBatch();
          pstmt.clearBatch();
          // conn.commit(); auto 커밋 실행 중
        }
        String[] str = line.split("\\|");
        // System.out.println(Arrays.deepToString(str));
        pstmt.setString(1, str[3]);
        pstmt.setString(2, str[4]); 
        pstmt.setInt(3, util.str2int(str[13]));
        pstmt.addBatch();
        pstmt.clearParameters();
        i++;
      }
      br.close();
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      if (pstmt != null) {
        pstmt.close();
      }
      if (conn != null) {
        conn.close();
      }
    }
    return i;
  }
}
