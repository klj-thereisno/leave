package fun.thereisno.util;

import java.text.SimpleDateFormat;

import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

/**
 * json-lib 日期处理类
 * @author Administrator
 *
 */
public class DateJsonUtil implements JsonValueProcessor{

	private String format;  
	
    public DateJsonUtil(String format){  
        this.format = format;  
    }  
    
	public Object processArrayValue(Object value, JsonConfig jsonConfig) {
		// TODO Auto-generated method stub
		return null;
	}

	public Object processObjectValue(String key, Object value, JsonConfig jsonConfig) {
		if(value == null)  
        {  
            return "";  
        }  
        if(value instanceof java.sql.Timestamp)  
        {  
            String str = new SimpleDateFormat(format).format((java.sql.Timestamp)value);  
            return str;  
        }  
        if (value instanceof java.sql.Date)  
        {  
            String str = new SimpleDateFormat(format).format((java.sql.Date) value);  
            return str;  
        }
        if (value instanceof java.util.Date)  
        {  
            String str = new SimpleDateFormat(format).format((java.util.Date) value);  
            return str;  
        }  
          
        return value.toString(); 
	}

}
