package servlet.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.repository.ChartRepository;

@Service
public class ChartService {
  
  @Autowired
  private ChartRepository chartRepository;

  public List<Map<String, Object>> sdList() {
    return chartRepository.sdList();
  }

  public List<Map<String, Object>> sdUsage(String sd_cd) {
    if (sd_cd.equals("0")) {
      return chartRepository.sdUsage();
    } else {
      return chartRepository.sggUsage(sd_cd);
    }
  }
}