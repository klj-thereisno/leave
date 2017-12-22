package fun.thereisno.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpSession;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.impl.identity.Authentication;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.runtime.Execution;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Comment;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

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
	private LeaveService leaveService;
	
	@Resource
	private RuntimeService runtimeService;
	
	@Resource
	private RepositoryService repositoryService;
	
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
	
	@GetMapping("show/{instanceId}")
	public ModelAndView show(@PathVariable String instanceId){
		/*Execution execution = runtimeService.createExecutionQuery().processInstanceId(instanceId).singleResult();
		String activityId = runtimeService.getActiveActivityIds(execution.getId()).get(0);*/
		ModelAndView mv = new ModelAndView("admin/view");
		ProcessInstance instance = runtimeService.createProcessInstanceQuery().processInstanceId(instanceId).singleResult();
		String activityId = instance.getActivityId();
		String definitionId = instance.getProcessDefinitionId();
		String deployId = instance.getDeploymentId();
		String resourceName = repositoryService.createProcessDefinitionQuery().deploymentId(deployId).singleResult().getDiagramResourceName();
		mv.addObject("deployId", deployId);
		mv.addObject("resourceName", resourceName.split("\\.")[0]);
		
		ActivityImpl impl = ((ProcessDefinitionEntity)repositoryService.getProcessDefinition(definitionId)).findActivity(activityId);
		Integer x = impl.getX();
		Integer y = impl.getY();
		Integer width = impl.getWidth();
		Integer height = impl.getHeight();
		mv.addObject("left", (x - 2) + "px");
		mv.addObject("top", (y - 2) + "px");
		mv.addObject("width", width + "px");
		mv.addObject("height", height + "px");
		return mv;
	}
	
	@PostMapping("comment/list")
	public void listComment(String instanceId, ServletResponse resp){
		List<Comment> list = taskService.getProcessInstanceComments(instanceId);
		// List<Comment> list = taskService.getTaskComments("15014");
		Collections.reverse(list);
		JsonConfig config = new JsonConfig();
		JSONObject o = new JSONObject();
		config.registerJsonValueProcessor(Date.class, new DateJsonUtil("yyyy-MM-dd HH:mm:ss"));
		o.put("rows", JSONArray.fromObject(list, config));
		o.put("total", list.size());
		ResponseUtil.write(resp, o);
	}
	
	@PostMapping("deal")
	public void deal(boolean agree, String processId, Integer leaveId, String comment, PrintWriter out, HttpSession session){
		Task task = taskService.createTaskQuery().processInstanceId(processId).singleResult();
		Map<String, Object> variables = new HashMap<String, Object>();
		variables.put("agree", agree);
		org.activiti.engine.identity.User user = (org.activiti.engine.identity.User) session.getAttribute("currentUser");
		String name = user.getFirstName();
		String group = (String) session.getAttribute("group");
		Authentication.setAuthenticatedUserId(name + "『" + group + "』");
		taskService.addComment(task.getId(), processId, comment);
		taskService.complete(task.getId(), variables );
		Leave leave = new Leave();
		leave.setId(leaveId);
		/*
		 * 如果同意了，但不是班长同意的，则批准、更新
		 * 如果不同意，(则不存在二次批准，流程结束)
		 */
		if(agree){
			if(!group.equals("班长")){
				leave.setState("批准");
				leaveService.update(leave);
			}
		}else{
			leave.setState("未批准");
			leaveService.update(leave);
		}
		out.print("{\"success\":true}");
	}
	
	/**
	 * 班长调用已办任务，查询正在执行的非班长任务
	 * @param pageBean
	 * @param resp
	 */
	@RequiresRoles("班长")
	@PostMapping("complete")
	public void complete(PageBean pageBean, ServletResponse resp){
		String sql = "select * from `act_ru_execution` where act_id_ != 'usertask2'";
		String sql2 = "select count(*) from `act_ru_execution` where act_id_ != 'usertask2'";
		List<Execution> list = runtimeService.createNativeExecutionQuery().sql(sql).listPage(pageBean.getStart(), pageBean.getRows());
		List<Leave> leaves = new ArrayList<Leave>();
		for (Execution execution : list) {
			Integer leaveId = (Integer)runtimeService.getVariable(execution.getId(), "leaveId");
			leaves.add(leaveService.findById(leaveId));
		}
		JSONObject o = new JSONObject();
		JsonConfig config = new JsonConfig();
		config.registerJsonValueProcessor(Date.class, new DateJsonUtil("yyyy-MM-dd HH:mm:ss"));
		o.put("total", runtimeService.createNativeExecutionQuery().sql(sql2).count());
		o.put("rows", JSONArray.fromObject(leaves, config));
		ResponseUtil.write(resp, o);
	}
}
