package servlet.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ErrorController {
  
  @RequestMapping(value = "/error.do", method = RequestMethod.GET)
  public String error() {
    return "error/error";
  }
}
