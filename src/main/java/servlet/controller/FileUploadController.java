package servlet.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import servlet.impl.FileUploadService;

@Controller
public class FileUploadController {
  
  @Autowired
  private FileUploadService uploadService;

  @RequestMapping(value = "/fileUpload.do", method = RequestMethod.GET)
  public String fileUpload() {
    return "fileUpload";
  }

  @RequestMapping(value = "/upload.do", method = RequestMethod.POST)
  public @ResponseBody String upload(@RequestParam(value = "file") MultipartFile file) {
    Long start = System.currentTimeMillis();
    uploadService.deleteDb(); // DB 초기화
    int result = 0;
    try {
      // result = uploadService.insertDBTest(file);
      result = uploadService.insertDB(file);
    } catch (Exception e) {
      e.printStackTrace();
    }
    uploadService.updateDB(); // Materialized View 갱신
    Long finish = System.currentTimeMillis();
    System.out.println("걸린 시간 : " + (finish - start) / 1000 + " 초");
    return String.valueOf(result);
  }
}
