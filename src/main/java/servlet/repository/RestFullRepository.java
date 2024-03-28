package servlet.repository;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class RestFullRepository {

  @Autowired
  private SqlSession sqlSession;

  public Map<String, Object> getSdCoordinate(String sdValue) {
    return sqlSession.selectOne("db.getSdCoordinate", sdValue);
  }

  public Map<String, Object> getSggCoordinate(String sggValue) {
    return sqlSession.selectOne("db.getSggCoordinate", sggValue);
  }
}
