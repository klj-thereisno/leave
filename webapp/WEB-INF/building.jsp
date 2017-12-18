<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%response.setStatus(HttpServletResponse.SC_OK);  
  
      %>  
<%  
/** 
* 本页面是在客户查找的页面无法找到的情况下调用的 
*/  
response.setStatus(HttpServletResponse.SC_OK);  
 %>  
<body style="text-align: center;padding-top: 200px" >  
你可能走丢了...<span style="margin-left: 20px;"><a href="javascript:history.go(-1)">返回</a></span><br/>  
也可能页面连接更改了，请按 F5键刷新整个页面看看！  
  
</body>  