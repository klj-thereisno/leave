package fun.thereisno.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.ServletResponse;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.ProcessDefinition;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import fun.thereisno.entity.PageBean;
import fun.thereisno.util.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@RestController
@RequestMapping("define")
public class DefineController {

	@Resource
	private RepositoryService repositoryService;
	
	@GetMapping("list")
	public void listGroup(PageBean pageBean, @RequestParam(value="s_name", defaultValue = "")String s_name, ServletResponse resp){
		List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery()
												.processDefinitionNameLike("%" + s_name + "%")
												.orderByProcessDefinitionKey().desc()
												.orderByProcessDefinitionVersion().desc()
												.listPage(pageBean.getStart(), pageBean.getRows());
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"identityLinks", "processDefinition"});
		JSONObject o = new JSONObject();
		o.put("total", repositoryService.createProcessDefinitionQuery().processDefinitionNameLike("%" + s_name + "%").count());
		o.put("rows", JSONArray.fromObject(list, config));
		ResponseUtil.write(resp, o);
	}
	
	
	@GetMapping("view/{deployId}/{resource}")
	public void view(@PathVariable("deployId")String deploymentId, @PathVariable("resource")String resourceName, ServletResponse resp){
		InputStream in = repositoryService.getResourceAsStream(deploymentId, resourceName + ".png");
		byte[] b = new byte[1024];
		try {
			OutputStream out = resp.getOutputStream();
			while(in.read(b) != -1)
				out.write(b);
			in.close();
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
