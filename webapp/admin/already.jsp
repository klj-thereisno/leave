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
	
	function forUser(val, row){
		return val.id;
	}
	
	function forDetail(val, row){
		return "<a href='../task/show/" + row.instanceId +"' target='_blank'>查看流程图</a>&nbsp;&nbsp;&nbsp;&nbsp;";
	}
	
	function show(){
		var row = $("#dg").datagrid("getSelected");
		if(!row){
			$.messager.alert("提示","请选择一条要查看的记录");
			return;
		}
		leaveId = row.id;
		$("#dlg").dialog("open");
		$("#id").val(row.user.id);
		$("#date").val(row.date);
		$("#days").val(row.days + "天");
		$("#reason").val(row.reason);
		$("[id]").attr("readonly",true);
		instanceId = row.instanceId;
		$("#dg2").datagrid({
			url:'../task/comment/list?instanceId=' + instanceId,
			columns:[[
			          {field:'userId',title:'审核人',width:80,align:'center'},
			          {field:'message',title:'批注',width:120,align:'center'},
			          {field:'time',title:'审核日期',width:100,align:'center'}
			      ]]
		});
	}
</script>
</head>
<body style="margin: 1px;">
<table id="dg" title="等待结果" toolbar="#tb" fit="true" singleSelect="true" pageList="[3,10]" pagination="true" fitColumns="true" url="../task/complete" rownumbers="true" class="easyui-datagrid">
	<thead>
		<tr>
			<th checkbox="true"></th>
			<th data-options="field:'user',width:1" align="center" formatter="forUser">申请人</th>
			<th data-options="field:'date',width:3" align="center">申请日期</th>
			<th data-options="field:'days',width:1" align="center">请假天数</th>
			<th data-options="field:'reason',width:8" align="center">请假原因</th>
			<th field="xx" width="1" formatter="forDetail" align="center">详情</th>
		</tr>
	</thead>
</table>
<div id="tb">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="show()" plain="true" iconCls="icon-chakan">详情</a><br/>
	用户Id：<input id="s_id" onkeydown="if(event.keyCode == 13) search()"><a href="javascript:search()" class="easyui-linkbutton" plain="true" iconCls="icon-search">搜索</a>
</div>
<div id="dlg" class="easyui-dialog" modal="true" closed="true" iconCls="icon-chakan" title="请假详情" style="width:420px;height: 410px;padding: 6px">
	<table cellspacing="2px">
		<tr>
			<td>申请人：</td>
			<td><input id="id" style="width: 240px" ></td>
		</tr>
		<tr>
			<td>申请时间：</td>
			<td><input id="date" style="width: 240px" ></td>
		</tr>
		<tr>
			<td>申请天数：</td>
			<td><input id="days" style="width: 240px" ></td>
		</tr>
		<tr>
			<td valign="top">请假原因：</td>
			<td><textarea id="reason" style="height: 55px;width: 238px" resizable="false" ></textarea></td>
		</tr>
	</table>
	<table id="dg2" style="width: 390px;" title="历史批注" fitColumns="true" rownumbers="true" class="easyui-datagrid">
	</table>
</div>
</body>
</html>