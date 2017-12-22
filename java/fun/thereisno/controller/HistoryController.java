package fun.thereisno.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.ServletResponse;

import org.activiti.engine.HistoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.history.HistoricTaskInstanceQuery;
import org.activiti.engine.runtime.Execution;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
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
@RequestMapping("history")
public class HistoryController {

	@Resource
	private HistoryService historyService;
	
	@Resource
	private LeaveService leaveService;
	
	@Resource
	private RuntimeService runtimeService;
	
	@Resource
	private TaskService taskService;
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sdf.setLenient(true);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
	}
	
	@PostMapping("list")
	public void history(PageBean pageBean, @RequestParam(value = "userId", defaultValue = "")String userId, 
						Date after, Date before, 
						ServletResponse resp){
		HistoricTaskInstanceQuery query = historyService.createHistoricTaskInstanceQuery()
														.processDefinitionKey("leaveProcess")
														.processVariableValueLikeIgnoreCase("userId", "%" + userId + "%")
														.taskCreatedAfter(after);
		if(before != null){
			query.taskCreatedBefore(new Date(before.getTime() + 3600 * 24 * 1000));
		}
		query.orderByTaskCreateTime();
		List<HistoricTaskInstance> list = query.desc().list();
		List<Leave> leaves = new ArrayList<Leave>();
		Set<Integer> ids = new LinkedHashSet<Integer>();
		/*
		 * 从历史记录表中查询出所有的流程实例Id
		 */
		for(HistoricTaskInstance stance : list)
			ids.add(Integer.parseInt(stance.getProcessInstanceId()));
		
		/*
		 * 从执行表中查询出所有的正在执行的流程实例Id
		 * 删除
		 */
		List<Execution> exes = runtimeService.createExecutionQuery().list();
		for (Execution execution : exes)
			ids.remove(Integer.parseInt(execution.getProcessInstanceId()));
		
		int from = pageBean.getStart();
		int to = pageBean.getStart() + pageBean.getRows() > ids.size() ? ids.size() : pageBean.getStart() + pageBean.getRows();
		Iterator<Integer> it = ids.iterator();
		int index = 0;
		int count = 0;
		while(it.hasNext()){
			Integer id = it.next();
			if(index >= from && index < to){
				leaves.add(leaveService.findByInstanceId(id));
				if(count++ == pageBean.getRows())
					break;
			}
			index++;
		}
		JsonConfig config = new JsonConfig();
		config.registerJsonValueProcessor(Date.class, new DateJsonUtil("yyyy-MM-dd HH:mm:ss"));
		JSONObject o = new JSONObject();
		o.put("total", ids.size());
		o.put("rows", JSONArray.fromObject(leaves, config));
		ResponseUtil.write(resp, o);
	}
	
}
