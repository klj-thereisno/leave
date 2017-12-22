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
	
	$("#dg").datagrid({
		onDblClickRow:function(a,b){
			id = b.id;
			$("#dlg").dialog("open").dialog("setTitle","友情链接修改");
			$("#fm").form("load",b);
		}
	});
	
	$(function(){
		$("#dlg").dialog({
			onClose:function(){
				$("#dg").datagrid("reload");
			}
		})
	});
	
	function forUser(val, row){
		return val.id;
	}
	
	function forDetail(val, row){
		return "<a href='../task/show/" + row.instanceId +"' target='_blank'>查看流程图</a>&nbsp;&nbsp;&nbsp;&nbsp;";
	}
	
	var leaveId = '';
	
	function deal(){
		var row = $("#dg").datagrid("getSelected");
		if(!row){
			$.messager.alert("提示","请选择一条要审批的请假单");
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
			          {field:'userId',title:'审核人',width:100,align:'center'},
			          {field:'message',title:'批注',width:100,align:'center'},
			          {field:'time',title:'审核日期',width:100,align:'center'}
			      ]]
		});
	}
	
	var instanceId = '';
	
	function disagree(row){
		$.messager.confirm("提示","确定不通过这位同学的请假申请吗",function(r){
			if(r){
				$.messager.prompt("提示","请填写不同意注释",function(r){
					if(r){ // trim != ''
						$.ajax({
							url:'../task/deal',
							type:'post',
							data:{agree:false,processId:row.instanceId,comment:r},
							dataType:'json',
							success:function(r){
								if(r.success){
									$.messager.alert("提示","处理成功");
									$("#dlg").dialog("close");
									$("#dg").datagrid("reload");
								}
							}
						});
					}
				});
			}
		});
	}
	
	function search(){
		$("#dg").datagrid("load",{
			id:$("#s_id").val()
		});
	}
	
	function save(){
		$("form").form("submit",{
			url:'../task/deal?processId=' + instanceId + '&leaveId=' + leaveId,
			onSubmit:function(){
				if($("[name=comment]").val().trim() == ''){
					$.messager.alert("提示","请填写批注");
					return false;
				}
				/* return $(this).form("validate"); */
			},
			success:function(r){
				var r = JSON.parse(r);
				if(r.success){
					$.messager.alert("提示","审批成功");
					$("[name=dis]").css("display","none");
					$("#dg2").datagrid("reload");
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
<table id="dg" title="申请列表" toolbar="#tb" fit="true" singleSelect="true" pagination="true" fitColumns="true" url="../task/list?userId=${currentUser.id }" data-options="method:'get'" rownumbers="true" class="easyui-datagrid">
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
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="deal()" plain="true" iconCls="icon-check">审批</a><br/>
	用户Id：<input id="s_id" onkeydown="if(event.keyCode == 13) search()"><a href="javascript:search()" class="easyui-linkbutton" plain="true" iconCls="icon-search">搜索</a>
</div>
<div id="dlg" class="easyui-dialog" modal="true" closed="true" iconCls="icon-chakan" title="请假详情" style="width:420px;height: 410px;padding: 6px">
	<table cellspacing="2px">
		<form id="fm" method="post">
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
			<tr name="dis">
				<td>处理结果：</td>
				<td>
					<input type="radio" value="true" name="agree" checked="checked">同意
					<input type="radio" value="false" name="agree" >不同意
				</td>
			</tr>
			<tr name="dis">
				<td>注语：</td>
				<td><textarea style="height: 45px;width: 238px" name="comment"></textarea>
				</td>
			</tr>
			<tr name="dis">
				<td></td>
				<td>
					<a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()" iconCls="icon-ok">提交</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancel()" iconCls="icon-cancel">取消</a>
				</td>
			</tr>
		</form>
	</table>
	<table id="dg2" style="width: 390px;" title="历史批注" fitColumns="true" rownumbers="true" class="easyui-datagrid">
	</table>
</div>
</body>
</html>