<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>博客管理</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/static/images/favicon.ico" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">

	function openTab(url, title, icon){
		if($("#tab").tabs("exists",title))
			$("#tab").tabs("select",title);
		else{
			var content = "<iframe frameborder=0 scrolling='auto' src='" + url +".jsp' style='width:100%;height:100%'></iframe>";
			$("#tab").tabs("add",{
				content:content,
				iconCls:icon,
				closable:true,
				title:title
			});
		}
	}
	
	function modifyPassword(){
		$("#dlg").dialog("open");
	}
	
	function save(){
		$("#fm").form("submit",{
			url:'../user/modify',
			onSubmit:function(){
				/* if($('[name=old]').val() == ''){
					$.messager.alert("tip",'原密码不能为空','info');
					return false;
				} */
				if($('[name=password]').val() == ''){
					$.messager.alert("tip",'新密码不能为空','info');
					return false;
				}
				if($('[name=password2]').val() == ''){
					$.messager.alert("tip",'确认密码不能为空','info');
					return false;
				}
				if($('[name=password2]').val() != $('[name=password]').val()){
					$.messager.alert("tip",'确认密码与新密码不同，请重新填写','info');
					return false;
				}
			},
			success:function(r){
				var r = JSON.parse(r);
				if(r.success){
					$.messager.confirm("提示","密码已成功修改，请重新登录",function(r){
						$.get("../user/logout",function(r){
							location = '../login.jsp';
						});
					});
				}else
					$.messager.alert("提示","密码修改失败，请联系管理员");
			}
		});
	}
	
	function cancel(){
		$("#dlg").dialog("close");
	}
	
	function logout(){
		$.messager.confirm("提示","exit？",function(r){
			if(r){
				// $.get("../manage/admin/logout");
				$.get("../user/logout",function(r){
					window.location = '../login.jsp';
				});
			}
		});
	}
	
	function refresh(){
		$.messager.confirm("info","sure fresh?",function(r){
			if(r){
				$.ajax({
					url:'../blog/admin',
					async:false,
					success:function(r){
						if(r){
							$.messager.alert("info","refresh ok");
						}
					}
				});
			}
		});
	}
	
	function getCurrentDateTime(){
		 var date=new Date();
		 var year=date.getFullYear();
		 var month=date.getMonth()+1;
		 var day=date.getDate();
		 var hours=date.getHours();
		 var minutes=date.getMinutes();
		 var seconds=date.getSeconds();
		 return year+"-"+formatZero(month)+"-"+formatZero(day)+" "+formatZero(hours)+":"+formatZero(minutes)+":"+formatZero(seconds);
	 }

	function getCurrentDate(){
		 var date=new Date();
		 var year=date.getFullYear();
		 var month=date.getMonth()+1;
		 var day=date.getDate();
		 return year+"-"+formatZero(month)+"-"+formatZero(day);
	}


	function formatZero(n){
		if (n < 10)
			n = "0" + n;
		return n;
	}
	
	window.setInterval(show,1000);
	
	function show(){
		$("#time").text(getCurrentDateTime);
	}
</script>
</head>
<body class="easyui-layout">
	<div region="north" style="height:80px;background-color:  #e0edef">
		<table>
			<tr>
				<td><img style="width: 260px;height: 70px" src="../static/images/bg.jpg"></td>
				<td><span style="font-size: 20px">欢迎：『${currentUser.id }』${currentUser.firstName }--${group }</span></td>
				<td style="padding-left: 200px">现在时间：<span id="time"></span></td>
			</tr>
		</table>
	</div>
	<div region="center" >
		<div class="easyui-tabs" fit="true" border="false" id="tab">
			<div title="首页" data-options="iconCls:'icon-home'">
				<div align="center" style="padding-top: 100px;"><font color="red" size="10">欢迎使用</font></div>
			</div>
		</div>
	</div>
	<div region="west" style="width: 200px;" title="导航菜单" split="true">
		<div class="easyui-accordion"  data-options="fit:true,overflow:'auto',border:false">
			<shiro:hasRole name="管理员">
				<div title="基础数据管理" data-options="selected:true,iconCls:'icon-item'" style="padding: 10px">
					<a href="javascript:openTab('userManage','用户管理','icon-user')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-user'" style="width: 150px">用户管理</a>
				</div>
				<div title="流程管理"  data-options="iconCls:'icon-flow'" style="padding:10px;">
					<a href="javascript:openTab('deployManage','流程部署管理','icon-deploy')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-deploy'" style="width: 150px;">流程部署管理</a>
					<a href="javascript:openTab('defineManage','流程定义管理','icon-definition')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-definition'" style="width: 150px;">流程定义管理</a>
				</div>
			</shiro:hasRole>
			<shiro:hasAnyRoles name="班长,教师,主任,院长">
				<div title="任务管理" data-options="iconCls:'icon-task'" style="padding:10px">
					<a href="javascript:openTab('ready','待办任务管理','icon-daiban')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-daiban'" style="width: 150px;">待办任务管理</a>
					<a href="javascript:openTab('yibanManage','已办任务管理','icon-yiban')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-yiban'" style="width: 150px;">已办任务管理</a>
					<a href="javascript:openTab('lishiManage','历史任务管理','icon-lishi')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-lishi'" style="width: 150px;">历史任务管理</a>
				</div>
			</shiro:hasAnyRoles>
			<shiro:hasRole name="学生">
				<div title="业务管理"  data-options="iconCls:'icon-yewu'" style="padding:10px">
					<a href="javascript:openTab('leaveApply','请假申请','icon-apply')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-apply'" style="width: 150px">请假申请</a>
				</div>
			</shiro:hasRole>
			<div title="系统管理" data-options="iconCls:'icon-system'" style="padding:10px">
				<a href="javascript:modifyPassword()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-modifyPassword'" style="width: 150px;">修改密码</a>
				<a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-exit'" style="width: 150px;">安全退出</a>
			</div>
		</div>
	</div>
	<div region="south" align="center" >
		<a href="http://www.miitbeian.gov.cn">皖ICP备17026886号</a>
		Copyright © 2017-2017 thereisno.fun 版权所有
	</div>
	<div class="easyui-dialog" buttons="#bt" id="dlg" iconCls="icon-edit" title="修改密码" closed="true" closable="true" style="width:500px;height:300px">
		<form id="fm" method="post">
			<table>
				<tr>
					<td>用户名：</td>
					<td><input name="id" value="${currentUser.id }" readonly="readonly"></td>
				</tr>
				<tr>
					<td>新密码：</td>
					<td><input type="password" name="password"></td>
				</tr>
				<tr>
					<td>确认新密码：</td>
					<td><input type="password" name="password2"></td>
				</tr>
			</table>
        </form>
        <div id="bt">
			<a href="javascript:save()" class="easyui-linkbutton" iconCls="icon-ok" >保存</a>
			<a href="javascript:cancel()" class="easyui-linkbutton" iconCls="icon-cancel" >取消</a>
		</div>
    </div>
</body>
</html>