package servlet.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.util.APIUtil;

@Controller
public class MapController {

	@Autowired
	private APIUtil util;
	
	@RequestMapping(value = "/map.do", method = RequestMethod.GET)
	public String map(Model model) {
		model.addAttribute("apiKey", util.getApiKey());
		model.addAttribute("domain", util.getApiDomain());
		try {
      model.addAttribute("sdList", util.sdAPI());
    } catch (Exception e) {
      e.printStackTrace();
    }
		return "map";
	}
	
	@RequestMapping(value = "/mapTest.do", method = RequestMethod.GET)
  public String mapTest(Model model) {
    model.addAttribute("apiKey", util.getApiKey());
    model.addAttribute("domain", util.getApiDomain());
    try {
      model.addAttribute("sdList", util.sdAPI());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "mapTest7";
  }
}
