package fun.thereisno.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletResponse;

import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.impl.persistence.entity.GroupEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import fun.thereisno.util.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;

@RestController
@RequestMapping("index")
public class IndexController {

	@Resource
	private IdentityService identityService;
	
	@RequestMapping("listGroup")
	public void listGroup(ServletResponse resp){
		List<Group> list = new ArrayList<Group>();
		GroupEntity group = new GroupEntity("ÇëÑ¡Ôñ½ÇÉ«...");
		list.add(group);
		list.addAll(identityService.createGroupQuery().orderByGroupType().asc().list());
		// out.print(JSONArray.fromObject(list));
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"name", "persistentState", "revisionNext", "revision"});
		JSONArray o = JSONArray.fromObject(list, config);
		ResponseUtil.write(resp, o);
	}
	
	@RequestMapping("listGroup2")
	public void listGroup2(ServletResponse resp){
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"name", "persistentState", "revisionNext", "revision"});
		ResponseUtil.write(resp, JSONArray.fromObject(identityService.createGroupQuery().orderByGroupType().asc().list(), config));
	}
	
}
