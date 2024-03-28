package servlet.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.repository.RestFullRepository;

@Service
public class RestFullService {
  
  @Autowired
  private RestFullRepository restRepository;

  public Map<String, Object> getSdCoordinate(String sdValue) {
    return restRepository.getSdCoordinate(sdValue);
  }

  public Map<String, Object> getSggCoordinate(String sggValue) {
    return restRepository.getSggCoordinate(sggValue);
  }
}
