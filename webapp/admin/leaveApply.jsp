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
	
	var exist = false;
	
	function forState(val, row){
		if(val == '审核中')
			exist = true;
		return val;
	}
	
	function add(){
		$("#dlg").dialog("open");
	}
	
	function save(){
		$("form").form("submit",{
			onSubmit:function(){
				/* $.ajax({
					url:'../leave/list?userId=${currentUser.id }&state=审核中',
					async:false,
					data:{page:1,rows:10},
					dataType:'json',
					success:function(r){
						if(r.total > 0){
							$.messager.alert("提示","已有正在审核的申请，请耐心等待处理结果");
							return false;
						}
					}
				}); */
				if($("#days").val() == ''){
					$.messager.alert("提示","请填写请假天数");
					return false;
				}
				if($("#reason").val().trim() == ''){
					$.messager.alert("提示","请说明请假原因");
					return false;
				}
				if(exist){
					$.messager.alert("提示","已有正在审核的申请，请耐心等待处理结果");
					return false;
				}
			},
			success:function(r){
				var r = JSON.parse(r);
				if(r.success){
					$.messager.alert("提示","请假单已提交，正在审批中");
					$("#dg").datagrid("reload");
					cancel();
				}else
					$.messager.alert("提示","未知错误",'error');
			},
			onLoadError:function(){
				$.messager.alert("提示","未知错误",'error');
			}
		});
	}
	
	function cancel(){
		$("#dlg").dialog("close");
		$("form").form("clear");
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
			<th data-options="field:'state',width:2" align="center" formatter="forState">当前状态</th>
			<th field="x" width="3" >详情查看</th>
		</tr>
	</thead>
</table>
<div id="tb">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add()" plain="true" iconCls="icon-add">填写请假单</a>
	<div style="">
		&nbsp;状态：<select id="state" onChange="search()" editable="false">
						<option value="">请选择...</option>
					    <option value="审核中">审核中</option>
					    <option value="批准">批准</option>
					    <option value="未批准">未批准</option>
				  </select>
	</div>
</div>
<div id="dlg" buttons="#bt" class="easyui-dialog" closed="true" iconCls="icon-save" title="请假申请" style="width:360px;height: 200px">
	<form action="../leave/apply" method="post" >
		<table cellspacing="2px">
			<tr>
				<td>天数：</td>
				<td><input id="days" name="days" class="easyui-numberbox" style="width: 240px" data-options="suffix:'天',min:1"></td>
			</tr>
			<tr>
				<td valign="top">请假原因：</td>
				<td><textarea id="reason" style="height: 80px;width: 238px" resizable="false" name="reason"></textarea></td>
			</tr>
		</table>
		<input type="hidden" name="user.id" value="${currentUser.id }">
	</form>
</div>
<div id="bt">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()" iconCls="icon-ok">提交</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancel()" iconCls="icon-cancel">取消</a>
</div>
</body>
</html>