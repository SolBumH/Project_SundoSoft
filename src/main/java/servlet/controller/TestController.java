package servlet.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import servlet.util.APIUtil;

@Controller
public class TestController {

	@Autowired
	private APIUtil util;
	
	@RequestMapping(value = "/test.do", method = RequestMethod.GET)
	public String test(Model model) {
		model.addAttribute("apiKey", util.getApiKey());
		model.addAttribute("domain", util.getApiDomain());
		try {
      model.addAttribute("sdList", util.sdAPI());
    } catch (Exception e) {
      e.printStackTrace();
    }
		return "test";
	}
}
