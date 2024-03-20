package servlet.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.impl.TestService;

@Controller
public class Test {
  
  @Autowired
  private TestService testService;

  @RequestMapping(value = "/uploadTest.do")
  public String uploadTest() {
    String asd = "1234567";
    return "testUpload";
  }
  
  @RequestMapping(value = "/uploadTest.do", method = RequestMethod.POST)
  public @ResponseBody String dbUpload() {
    int result = testService.dbTest();
    return "";
  }
}
