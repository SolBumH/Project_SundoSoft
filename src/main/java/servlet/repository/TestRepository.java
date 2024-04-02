package servlet.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class TestRepository {
  
  @Autowired
  private SqlSession session;

  public List<Object> cdbTest() {
    return session.selectList("test.getCDBFunction");
  }
}
