package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
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
  public String upload(@RequestParam(value = "file") MultipartFile file) throws IOException {
    // System.out.println(file.getOriginalFilename());
    uploadService.deleteDb(); // DB 초기화
    int result = uploadService.insertDB(file);
    return "redirect:/fileUpload.do";
  }
}
