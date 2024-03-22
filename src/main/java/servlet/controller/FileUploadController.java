package servlet.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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
  public String upload(@RequestParam(value = "file") MultipartFile file) {
    // System.out.println(file.getOriginalFilename());
    uploadService.deleteDb(); // DB 초기화
    int result = uploadService.insertDB(file);
    return "redirect:/fileUpload.do";
  }
}
