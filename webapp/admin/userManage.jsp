<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
	
	function forShip(val, row, index){
		var str = '';		
		for(var id in val)
			str += ',' + val[id]['id'];
		return str.substring(1,str.length);
	}
	
	function search(){
		$("#dg").datagrid("load",{
			id:$("#s_id").val(),
			name:$("#s_name").val()
		});
	}
	
	var exist = false;
	
	function check(id){
		if($("#flag").val() == 'true'){
			console.log("新增前：" + exist);
			exist = false;
			console.log("置空：" + exist);
			$.get("../user/check",{id:id},function(r){
				var r = JSON.parse(r);
				if(r.success){
					exist = true;
					console.log("存在？" + exist);
					$("#tip").text("该用户名已存在，换个试试");
					$("[name=id]").focus();
				}else
					$("#tip").text("");
			});
		}
	}
	
	function sleep(d){
		for(var t = Date.now();Date.now() - t <= d;);
	}
	
	function add(){
		$("#dlg").dialog("open").dialog("setTitle","用户新增");
		$("#id").prop("readonly",false);
		$("#flag").val(true);
	}
	
	function edit(){
		$("#flag").val(false);
		var row = $("#dg").datagrid("getSelected");
		if(!row){
			$.messager.alert("提示","请选择一条要修改的数据");
			return;
		}
		$("#dlg").dialog("open").dialog("setTitle","编辑用户");
		$("#id").prop("readonly",true); // jsdianji
		$("#fm").form("load",row);
		$("[name=firstName]").val(row.name);
	}
	
	function save(){
		$("#fm").form("submit",{
			onSubmit:function(){
				/* if($("#flag").val() == 'true' && exist){
					console.log($("#flag").val());
					console.log(exist);
					$.messager.alert("提示","用户名已存在，换个试试");
					return false;
				} */
				if($("#flag").val() == 'true' && $("[name=password]").val() == ''){
					$.messager.alert("提示","请填写密码");
					return false;
				}
				return $(this).form("validate");
			},
			success:function(r){
				var r = JSON.parse(r);
				if(r.success){
					$.messager.alert("提示",r.success,'info');
					cancel();
					$("#dg").datagrid("reload");
				}else
					$.messager.alert("提示","错误，请联系管理员","error");
			}
		});
	}
	
	function cancel(){
		$("#dlg").dialog("close");
		$("#fm").form("clear");
	}
	
	function deletes(){
		var rows = $("#dg").datagrid("getSelections");
		if(rows.length == 0){
			$.messager.alert("提示","请选择要删除的用户");
			return;
		}
		var ids = [];
		for(id in rows){
			ids.push(rows[id]['id']);
		}
		$.messager.confirm("提示","确定删除这" + ids.length + "个用户？",function(r){
			if(r){
				$.ajax({
					url:'../user/delete',
					type:'post',
					data:{ids:ids.join()},
					dataType:'json',
					success:function(r){
						if(r.success){
							$.messager.alert("提示","删除成功");
							$("#dg").datagrid("reload");
						}else
							$.messager.alert("提示","删除失败，请联系管理员");
					}
				});
			}
		});
	}
	
	function author(){
		var rows = $("#dg").datagrid("getSelections");
		if(rows.length == 0){
			$.messager.alert("提示","请选择要授权的用户");
			return;
		}
		$("#dlg2").dialog("open");
		$("#groupList").empty();
		$.ajax({
			url:'../index/listGroup2',
			type:'post',
			dataType:'json',
			success:function(r){
				for(var group in r){
					$("#groupList").append("<input type='checkbox' name='groups' value='" + r[group].id + "'/><span>" + r[group]['id'] + "</span>");
				}
			}
		});
		setRoles(rows[0]);
	}
	
	function setRoles(row){
		var roles = row.ships;
		for(var id in roles){
			console.log(roles[id].id);
			var role = roles[id]['id'];
			console.log(role);
			// $("[value=" + role + "]:checkbox").attr("checked",true);
			$("[value="+role+"]:checkbox").attr("checked",true);
		}
	}
	
	function saveAuthor(){
		var groupArr = $("[name=groups]");
		var roles = '';
		for(var group in groupArr){
			if(groupArr[group].checked){
				roles += groupArr[group].value + ',';
			}
		}
		$.ajax({
			url:'../user/author',
			type:'post',
			data:{roles:roles},
			dataType:'json',
			beforeSend:function(){
				if(roles.length == 0){
					$.messager.alert("提示","请至少选择一种角色");
					return false;
				}
			},
			success:function(r){
				if(r.success){
					$("#dlg2").dialog("close");
					$("#dg2").datagrid("reload");
				}else
					$.messager.alert("提示","授权出错，请重试");
			}
		});
	}
	
</script>
</head>
<body style="margin: 1px;">
<table id="dg" title="用户列表" toolbar="#tb" fit="true" pagination="true" fitColumns="true" url="../user/list" rownumbers="true" class="easyui-datagrid">
	<thead>
		<tr>
			<th checkbox="true"></th>
			<th data-options="field:'id',width:30" align="center">用户名</th>
			<th data-options="field:'name',width:30" align="center">姓名</th>
			<th data-options="field:'email',width:30" align="center">邮箱</th>
			<th data-options="field:'ships',width:30" align="center" formatter="forShip">角色</th>
		</tr>
	</thead>
</table>
<div id="tb">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add()" plain="true" iconCls="icon-add">新增</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit()" plain="true" iconCls="icon-edit">编辑</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="deletes()" plain="true" iconCls="icon-remove">删除</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="author()" plain="true" iconCls="icon-power">授权</a>
	<br/>
	&nbsp;用户名：<input id="s_id" onkeydown="if(event.keyCode == 13) search()">
	&nbsp;&nbsp;&nbsp;姓名：<input id="s_name" onkeydown="if(event.keyCode == 13) search()">
	<a href="javascript:search()" class="easyui-linkbutton" plain="true" iconCls="icon-search">搜索</a>
</div>
<div id="dlg" resizable="true" class="easyui-dialog" title="用户新增" buttons="#bt" iconCls="icon-save" style="width:600px;height:230px" closed="true">
	<form id="fm" method="post" action="../user/svae">
		<table>
			<tr>
				<td>用户名:</td>
				<td><input id="id" name="id" class="easyui-validatebox" required="true" onblur="check(this.value)" ><span id="tip" style="color:red"></span></td>
				<input id="flag" name="flag" value="false">
			</tr>
			<tr>
				<td>姓名:</td>
				<td><input name="firstName" class="easyui-validatebox" required="true"></td>
			</tr>
			<tr>
				<td>邮箱:</td>
				<td><input name="email" class="easyui-validatebox" required="true" ></td>
			</tr>
			<tr>
				<td>密码:</td>
				<td><input type="password" name="password"></td>
			</tr>
			<tr style="color: red">
				<td>注:</td>
				<td>密码选项在新增用户时为设置密码，在修改用户时若填写则为修改密码，不填则不作改动</td>
			</tr>
		</table>
	</form>
</div>
<div id="bt">
	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" onclick="save()">保存</a>
	<a href="javascript:cancel()" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
</div>

<div id="dlg2" resizable="true" class="easyui-dialog" title="授权管理" buttons="#bt2" iconCls="icon-save" style="width:300px;height:155px" closed="true">
	<div id="groupList" style="padding: 25px"></div>
</div>
<div id="bt2">
	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" onclick="saveAuthor()">保存</a>
	<a href="javascript:$('#dlg2').dialog('close')" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
</div>
</body>
</html>