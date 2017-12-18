package fun.thereisno.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PropertiesUtil {

	public static String getKey(String key){
		Properties p = new Properties();
		InputStream in = PropertiesUtil.class.getResourceAsStream("/leave.properties");
		try {
			p.load(in);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return p.getProperty(key);
	}
}
