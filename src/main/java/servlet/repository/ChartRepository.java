package servlet.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChartRepository {
  
  @Autowired
  private SqlSession sqlSession;

  public List<Map<String, Object>> sdList() {
    return sqlSession.selectList("db.sdList");
  }

  public List<Map<String, Object>> sdUsage() {
    return sqlSession.selectList("db.sdUsage");
  }
  
  public List<Map<String, Object>> sggUsage(String sd_cd) {
    return sqlSession.selectList("db.sggUsage", sd_cd);
  }
}
