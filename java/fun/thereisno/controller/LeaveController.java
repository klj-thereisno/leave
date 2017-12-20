package fun.thereisno.controller;

import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletResponse;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import fun.thereisno.entity.Leave;
import fun.thereisno.entity.PageBean;
import fun.thereisno.service.LeaveService;
import fun.thereisno.util.DateJsonUtil;
import fun.thereisno.util.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("leave")
public class LeaveController {

	@Resource
	private LeaveService leaveService;
	
	@Resource
	private RuntimeService runtimeService;
	
	@Resource
	private TaskService taskService;
	
	@GetMapping("list")
	public void list(PageBean pageBean, String userId, String state, ServletResponse resp){
		Map<String, Object> map = new HashMap<String, Object>();
		if(state != "")
			map.put("state", state);
		map.put("userId", userId);
		map.put("pageBean", pageBean);
		JSONObject o = new JSONObject();
		JsonConfig config = new JsonConfig();
		config.registerJsonValueProcessor(Date.class, new DateJsonUtil("yyyy-MM-dd HH:mm:ss"));
		o.put("rows", JSONArray.fromObject(leaveService.listLeave(map), config));
		// o.put("rows", leaveService.listLeave(map));
		o.put("total", leaveService.count(map));
		ResponseUtil.write(resp, o);
	}
	
	@PostMapping("apply")
	public void apply(Leave leave, PrintWriter out){
		ProcessInstance instance = runtimeService.startProcessInstanceByKey("leaveProcess");
		leave.setInstanceId(instance.getProcessInstanceId());
		leaveService.save(leave);
		Task task = taskService.createTaskQuery().processInstanceId(instance.getProcessInstanceId()).singleResult();
		taskService.setVariable(task.getId(), "leaveId", leave.getId());
		// 请假人设为变量
		taskService.setVariable(task.getId(), "userId", leave.getUser().getId());
		taskService.setVariable(task.getId(), "days", leave.getDays());
		taskService.complete(task.getId());
		out.print("{\"success\":true}");
	}
}
