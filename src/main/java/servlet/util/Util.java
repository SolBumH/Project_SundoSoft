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
}
