package servlet.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import servlet.impl.TestService;

@Controller
public class TestController {
  @Autowired
  private TestService testService;
  
  @RequestMapping(value = "/test.do")
  public String test() {
    return "test";
  }
  
  @RequestMapping(value = "/cdbTest.do", method = RequestMethod.POST)
  public void cdbTest() {
    List<Object> bb = testService.cdbTest();
    System.out.println(bb.get(0));
    System.out.println(bb.get(1));
    System.out.println(bb.get(2));
    System.out.println(bb.get(3));
    System.out.println(bb.get(4));
  }
  
  @RequestMapping(value = "/testUpload.do", method = RequestMethod.POST)
  @ResponseBody
  public String upload(@RequestParam(value = "file") MultipartFile file) {
    System.out.println(file.getOriginalFilename());
    int result = testService.insertDB(file);
    return String.valueOf(result);
  }
}
