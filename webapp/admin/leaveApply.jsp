<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/demo/demo.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
	
	function search(){
		$("#dg").datagrid("load",{
			state:$("#state").val()
		});
	}
	
</script>
</head>
<body style="margin: 1px;">
<table id="dg" title="请假列表" toolbar="#tb" fit="true" pagination="true" fitColumns="true" url="../leave/list?userId=${currentUser.id }" data-options="method:'get'" rownumbers="true" class="easyui-datagrid">
	<thead>
		<tr>
			<th checkbox="true"></th>
			<th data-options="field:'date',width:3" align="center">申请日期</th>
			<th data-options="field:'days',width:1" align="center">请假天数</th>
			<th data-options="field:'reason',width:8" align="center">请假原因</th>
			<th data-options="field:'state',width:2" align="center">当前状态</th>
			<th field="x" width="3" >详情查看</th>
		</tr>
	</thead>
</table>
<div id="tb">
	&nbsp;状态：<select id="state" onChange="search()">
					<option value="">请选择...</option>
				    <option value="审核中">审核中</option>
				    <option value="成功">成功</option>
				    <option value="失败">失败</option>
			  </select>
</div>
</body>
</html>
