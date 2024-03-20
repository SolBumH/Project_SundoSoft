package servlet.controller;

import javax.servlet.annotation.MultipartConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import servlet.impl.TestService;

@Controller
public class Test {
  
  @Autowired
  private TestService testService;

  @RequestMapping(value = "/uploadTest.do")
  public String uploadTest() {
    testService.dbTest();
    String asd = "1234567";
    return "testUpload";
  }
}
