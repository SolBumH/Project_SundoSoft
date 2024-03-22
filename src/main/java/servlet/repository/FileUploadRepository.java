package servlet.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FileUploadRepository {
  
  @Autowired
  private SqlSession sqlSession;

  public int insertDB(List<Map<String, Object>> list) {
    return sqlSession.insert("db.dbTest4", list);
  }

  public void deleteDb() {
    sqlSession.delete("db.deleteAll");
  }
}
