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
			userId:$("#s_id").val(),
			after:$("#after").datebox("getValue"),
			before:$("#before").datebox("getValue")
		});
	}
	
	function forUser(val, row){
		return val.id;
	}
	
	function forState(val, row){
		if(val == '批准')
			val = '已' + val;
		return val;
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
<table id="dg" title="历史申请" pageSize=3 pageList="[3,10]" toolbar="#tb" fit="true" singleSelect="true" pagination="true" fitColumns="true" url="../history/list" rownumbers="true" class="easyui-datagrid">
	<thead>
		<tr>
			<th checkbox="true"></th>
			<th data-options="field:'user',width:1" align="center" formatter="forUser">申请人</th>
			<th data-options="field:'date',width:3" align="center">申请日期</th>
			<th data-options="field:'days',width:1" align="center">请假天数</th>
			<th data-options="field:'reason',width:8" align="center">请假原因</th>
			<th data-options="field:'state',width:1" align="center" formatter="forState">审批结果</th>
		</tr>
	</thead>
</table>
<div id="tb">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="show()" plain="true" iconCls="icon-chakan">详情</a><br/>
	用户Id：<input id="s_id" onkeydown="if(event.keyCode == 13) search()">
	&nbsp;申请时间：&nbsp;<input type="text" id="after" class="easyui-datebox" size="20"/>
	&nbsp;到：&nbsp;<input type="text" id="before" class="easyui-datebox" size="20" />
	<a href="javascript:search()" class="easyui-linkbutton" plain="true" iconCls="icon-search">搜索</a>
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