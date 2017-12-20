package fun.thereisno.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletResponse;

import org.activiti.engine.HistoryService;
import org.activiti.engine.TaskService;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import fun.thereisno.entity.Leave;
import fun.thereisno.entity.PageBean;
import fun.thereisno.service.LeaveService;
import fun.thereisno.util.DateJsonUtil;
import fun.thereisno.util.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("task")
public class TaskController {

	@Resource
	private TaskService taskService;
	
	@Resource
	private HistoryService historyService;
	
	@Resource
	private LeaveService leaveService;
	
	@RequestMapping("list")
	public void list(String userId, @RequestParam(value="id", defaultValue = "")String id, PageBean pageBean, ServletResponse resp){
		TaskQuery query = taskService.createTaskQuery()
									.taskCandidateUser(userId)
									.processVariableValueLikeIgnoreCase("userId", "%" + id + "%");
		List<Task> list = query.orderByTaskCreateTime()
									.desc()
									.listPage(pageBean.getStart(), pageBean.getRows());
		List<Leave> leaves = new ArrayList<Leave>();
		for (Task task : list) {
			Integer leaveId = (Integer) taskService.getVariable(task.getId(), "leaveId");
			leaves.add(leaveService.findById(leaveId));
		}
		JSONObject o = new JSONObject();
		JsonConfig config = new JsonConfig();
		config.registerJsonValueProcessor(Date.class, new DateJsonUtil("yyyy-MM-dd HH:mm:ss"));
		o.put("total", query.count());
		o.put("rows", JSONArray.fromObject(leaves, config));
		ResponseUtil.write(resp, o);
	}
	
	@PostMapping("deal")
	public void deal(boolean agree, String processId, String comment){
		Task task = taskService.createTaskQuery().processInstanceId(processId).singleResult();
		Map<String, Object> variables = new HashMap<String, Object>();
		variables.put("agree", agree);
		variables.put("comment", comment);
		taskService.complete(task.getId(), variables );
	}
	
}
