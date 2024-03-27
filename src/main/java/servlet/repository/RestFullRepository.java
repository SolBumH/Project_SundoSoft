package servlet.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class RestFullRepository {

  @Autowired
  private SqlSession sqlSession;

  public List<Map<String, Object>> getSggCoordinate(String sggValue) {
    return sqlSession.selectList("db.getSggCoordinate", sggValue);
  }

  public List<Map<String, Object>> getSdCoordinate(String sdValue) {
    return sqlSession.selectList("db.getSdCoordinate", sdValue);
  }
}
