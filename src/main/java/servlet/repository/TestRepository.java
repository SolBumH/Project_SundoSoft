package servlet.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class TestRepository {
  
  @Autowired
  private SqlSession sqlSession;

  public void dbTest(List<Map<String, Object>> list) {
    sqlSession.insert("dbTest.dbTest3", list);
  }
}
