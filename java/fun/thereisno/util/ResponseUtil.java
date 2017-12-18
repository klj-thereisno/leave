package fun.thereisno.util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletResponse;

import org.apache.shiro.crypto.hash.Md5Hash;

public class ResponseUtil {

	public static void write(ServletResponse resp, Object o){
		resp.setContentType("text/html;charset=utf-8");
		PrintWriter out = null;
		try {
			out = resp.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		out.print(o);
		out.flush();
		out.close();
	}
	
	public static void main(String[] args) {
		System.out.println(new Md5Hash("t", "a").toString());
		System.out.println(new Md5Hash("T", "a").toString());
	}
	
}
