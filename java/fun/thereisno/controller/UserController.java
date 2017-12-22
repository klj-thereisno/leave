package fun.thereisno.controller;

import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import fun.thereisno.entity.PageBean;
import fun.thereisno.entity.User;
import fun.thereisno.service.MyService;
import fun.thereisno.service.UserService;
import fun.thereisno.util.PropertiesUtil;
import fun.thereisno.util.ResponseUtil;
import net.sf.json.JSONArray;

@Controller
@RequestMapping("user")
public class UserController {

	@Resource
	private IdentityService identityService;
	
	@Resource
	private MyService myService;
	
	@Resource
	private UserService userService;
	
	@RequestMapping(value = "login", params = "group")
	public synchronized void login(String group, UserEntity user, ServletResponse resp){ 
		org.activiti.engine.identity.User result = null;
		
		/**
		 * 0 student
		 * 1 monitor
		 * 2 teacher
		 * 3 principal
		 * 4(default) administrator
		 *//*
		switch (group) {
		case 0:
			type = "学生";
			break;
		case 1:
			type = "班长";
			break;
		case 2:
			type = "教师";
			break;
		case 3:
			type = "主任";
			break;
		default:
			type = "管理员";
			break;
		}*/
		JSONObject o = new JSONObject();
		result = identityService.createUserQuery().memberOfGroup(group).userId(user.getId()).singleResult();
		try{
			if(result.getId().equals(user.getId())){ // nullpoint catch
				Md5Hash hash = new Md5Hash(user.getPassword(), PropertiesUtil.getKey("salt"));
				Subject subject = SecurityUtils.getSubject();
				AuthenticationToken token = new UsernamePasswordToken(user.getId() + "|" + group, hash.toString());
				subject.login(token);
				Session session = subject.getSession();
				session.setAttribute("currentUser", result);
				session.setAttribute("group", group);
				o.put("success", true);
			}else
				o.put("errMsg", "用户名或密码错误，请重试");
		}catch(Exception e){
			o.put("errMsg", "用户名或密码错误，请重试");
		}
		ResponseUtil.write(resp, o);
	}
	
	@PostMapping("modify")
	public void modify(UserEntity user, PrintWriter out){
		user.setPassword(new Md5Hash(user.getPassword(),PropertiesUtil.getKey("salt")).toString());
		myService.updatePassword(user.getId(), user.getPassword());
		out.print("{\"success\":true}");
	}
	
	@GetMapping("logout")
	public void logout(ServletRequest req, PrintWriter out){
		SecurityUtils.getSubject().logout(); // getSession().removeAttribute("currentUser");// logout();
		// ((HttpServletRequest)req).getSession().invalidate();
		out.print("{\"success\":true}");
	}
	
	@PostMapping("list")
	public void list(User user, String group, PageBean pageBean, ServletResponse resp){
		net.sf.json.JSONObject o = new net.sf.json.JSONObject();
		Map<String, Object> map = new LinkedHashMap<String, Object>();
		map.put("pageBean",pageBean);
		map.put("user", user);
		o.put("total", userService.count(map));
		o.put("rows", JSONArray.fromObject(userService.list(map)));
		ResponseUtil.write(resp, o);
		/*StringBuffer sb = new StringBuffer("select * from act_id_user u, act_id_membership m");
		
		identityService.createNativeUserQuery().listPage(pageBean.getStart(), pageBean.getRows());*/
	}
	
	@GetMapping(value = "check", params = "id")
	public void check(String id, PrintWriter out){
		org.activiti.engine.identity.User user = identityService.createUserQuery().userId(id).singleResult();
		String msg = "{\"success\":false}";
		if(user != null)
			msg = "{\"success\":true}";
		out.print(msg);
	}
	
	
	@PostMapping("svae")
	public void save(UserEntity user, boolean flag, ServletResponse resp){
		String msg = "{\"success\":\"修改用户成功\"}";
		user.setPassword(new Md5Hash(user.getPassword(),PropertiesUtil.getKey("salt")).toString());
		if(flag){
			identityService.saveUser(user);
			identityService.createMembership(user.getId(), "学生");
			msg = "{\"success\":\"新增用户成功\"}";
		}else{
			/*User myUser = new User();
			myUser.setId(user.getId());
			myUser.setEmail(user.getEmail());
			myUser.setName(user.getFirstName());
			myUser.setPassword(user.getPassword());
			userService.update(myUser);*/
			userService.update(user);
		}
		ResponseUtil.write(resp, msg);
	}
	
	@PostMapping("delete")
	public void delete(String ids, PrintWriter out){
		Map<String, Object> map = new LinkedHashMap<String, Object>();
		String msg = "{\"success\":true}";
		String[] idArr = ids.split(",");
		map.put("ids", idArr);
		try{
			for (String id : idArr) {
				List<Group> groups = identityService.createGroupQuery().groupMember(id).list();
				for (Group group : groups) {
					identityService.deleteMembership(id, group.getId());
				}
			}
			userService.delete(map);
		}catch(Exception e){
			msg = "{\"success\":false}";
		}
		out.print(msg);
	}
	
	@PostMapping("author")
	public void author(String roles, String id, PrintWriter out){
		List<Group> groups = identityService.createGroupQuery().groupMember(id).list();
		for (Group group : groups) 
			identityService.deleteMembership(id, group.getId());
		for(String role : roles.split(","))
			identityService.createMembership(id, role);
		out.print("{\"success\":true}");
	}
}
