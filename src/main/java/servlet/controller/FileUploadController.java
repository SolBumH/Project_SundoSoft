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
    return "fileUpload2";
  }

  @RequestMapping(value = "/upload.do", method = RequestMethod.POST)
  public @ResponseBody String upload(@RequestParam(value = "file") MultipartFile file) {
    uploadService.deleteDb(); // DB 초기화
    int result = uploadService.insertDB(file);
    return String.valueOf(result);
  }
}
