package servlet.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import servlet.impl.ChartService;
import servlet.util.APIUtil;
import servlet.util.Util;

@Controller
public class ChartController {
  @Autowired
  private APIUtil util;
  
  @Autowired
  private Util util2;
  
  @Autowired
  private ChartService chartService;
  
  @RequestMapping(value = "/chart.do", method = RequestMethod.GET)
  public String mapTest(@RequestParam(name = "sdCode", defaultValue = "0") String sd_cd, Model model) {
    model.addAttribute("apiKey", util.getApiKey());
    model.addAttribute("domain", util.getApiDomain());
    model.addAttribute("sdList", chartService.sdList());
    if (util2.intCheck(sd_cd)) {
      List<Map<String, Object>> list = chartService.sdUsage(sd_cd);
      //System.out.println(list);
      model.addAttribute("usageList", list);
    } else {
      return "redirect:/error.do";
    }
    return "chart";
  }
}
