package servlet.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.repository.TestRepository;

@Service
public class TestService {
  @Autowired
  private TestRepository testRepository;

  public List<Object> cdbTest() {
    return testRepository.cdbTest();
  }
}
