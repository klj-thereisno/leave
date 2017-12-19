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
			s_name:$("#s_name").val()
		});
	}
	
	function forAction(val, row){
		var deployId = row.deploymentId;
		var diagramResourceName = row.diagramResourceName;
		return "<a href='../define/view/" + deployId + "/" + diagramResourceName.split(".")[0] + "' target='_blank'>查看流程图</a>";
	}
	
</script>
</head>
<body style="margin: 1px;">
<table id="dg" title="用户列表" toolbar="#tb" fit="true" pagination="true" fitColumns="true" url="../define/list" data-options="method:'get'" rownumbers="true" class="easyui-datagrid">
	<thead>
		<tr>
			<th checkbox="true"></th>
			<th data-options="field:'id',width:10" align="center">实例Id</th>
			<th data-options="field:'name',width:6" align="center">实例名称</th>
			<th data-options="field:'key',width:6" align="center">实例key</th>
			<th data-options="field:'version',width:3" align="center">实例版本</th>
			<th data-options="field:'deploymentId',width:4" align="center">部署Id</th>
			<th data-options="field:'resourceName',width:5" align="center">资源名称</th>
			<th data-options="field:'diagramResourceName',width:5" align="center">流程图名称</th>
			<th field="x" width="3" formatter="forAction">操作</th>
		</tr>
	</thead>
</table>
<div id="tb">
	&nbsp;实例名称：<input id="s_name" onkeydown="if(event.keyCode == 13) search()">
	<a href="javascript:search()" class="easyui-linkbutton" plain="true" iconCls="icon-search">搜索</a>
</div>
</body>
</html>
