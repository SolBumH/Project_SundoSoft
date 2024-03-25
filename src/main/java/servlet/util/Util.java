package servlet.util;

import org.springframework.stereotype.Component;

@Component
public class Util {

  public int str2int(String str) {
    try {
      return Integer.valueOf(str);
    } catch (Exception e) {
      return 0;
    }
  }
  
  public boolean intCheck(String str) {
    try {
      Integer.valueOf(str);
      return true;
    } catch (Exception e) {
      return false;
    }
  }
}
