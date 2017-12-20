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
	
	function add(){
		$("#dlg").dialog("open");
	}
	
	function save(){
		var file = $("[name=deployName]");
		if(file.val() == ''){
			$.messager.alert("提示","请选择要部署的文件");
			return;
		}
		if(file.val().search(/zip$/i) == -1){
			$.messager.alert("提示","请选择zip文件");
			return;
		}
		$("#fm").form("submit",{
			success:function(r){
				var r = JSON.parse(r);
				if(r.success){
					$.messager.alert("提示","文件上传成功");
					$("#dg").datagrid("reload");
					$("#dlg").dialog("close");
				}
			},
			onLoadError:function(){
				$.messager.alert("提示","系统错误","error");
				$("#dlg").dialog("close");
			}
			
		});
	}
	
	function cancel(){
		$("#dlg").dialog("close");
		$("[name=deployName]").empty();
	}
	
	function deletes(){
		var rows = $("#dg").datagrid("getSelections");
		if(rows.length == 0){
			$.messager.alert("提示","请选择要删除的部署文件");
			return;
		}
		var ids = '';
		for(var row in rows)
			ids += rows[row].id + ",";
		$.messager.confirm("提示", "确定删除这" + rows.length + "个部署吗", function(r){
			if(r){
				$.ajax({
					url:'../deploy/delete',
					type:'post',
					data:{ids:ids},
					dataType:'json',
					success:function(r){
						if(r.success){
							$.messager.alert("提示","删除部署成功");
							$("#dg").datagrid("reload");
						}else
							$.messager.alert("提示","错误");
					}
				});
			}
		});
	}
	
</script>
</head>
<body style="margin: 1px;">
<table id="dg" title="用户列表" toolbar="#tb" fit="true" pagination="true" fitColumns="true" url="../deploy/list" data-options="method:'get'" rownumbers="true" class="easyui-datagrid">
	<thead>
		<tr>
			<th checkbox="true"></th>
			<th data-options="field:'name',width:3" align="center">部署名称</th>
			<th data-options="field:'deploymentTime',width:3" align="center">部署时间</th>
		</tr>
	</thead>
</table>
<div id="tb">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add()" plain="true" iconCls="icon-add">新增</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="deletes()" plain="true" iconCls="icon-remove">删除</a>
	<br/>
	&nbsp;部署名称：<input id="s_name" onkeydown="if(event.keyCode == 13) search()">
	<a href="javascript:search()" class="easyui-linkbutton" plain="true" iconCls="icon-search">搜索</a>
</div>
<div id="dlg" resizable="true" class="easyui-dialog" title="部署新增" buttons="#bt" iconCls="icon-save" style="width:300px;height:160px" closed="true">
	<form id="fm" method="post" action="../deploy/svae" enctype="multipart/form-data" >
		<div style="margin-bottom:20px;padding: 20px">
            <input id="file" name="deployName" type="file" style="width:100%">
        </div>
	</form>
</div>
<div id="bt">
	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" onclick="save()">保存</a>
	<a href="javascript:cancel()" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
</div>
</body>
</html>
