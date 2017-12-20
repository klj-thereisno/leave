package fun.thereisno.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;
import java.util.zip.ZipInputStream;

import javax.annotation.Resource;
import javax.servlet.ServletResponse;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.Deployment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import fun.thereisno.entity.PageBean;
import fun.thereisno.util.DateJsonUtil;
import fun.thereisno.util.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("deploy")
public class DeployController {

	@Resource
	private RepositoryService repositoryService;
	
	@GetMapping("list")
	public void listGroup(PageBean pageBean, @RequestParam(value="s_name", defaultValue = "")String s_name, ServletResponse resp){
		List<Deployment> list = repositoryService.createDeploymentQuery()
												.deploymentNameLike("%" + s_name + "%")
												.orderByDeploymenTime()
												.desc()
												.listPage(pageBean.getStart(), pageBean.getRows());
		JsonConfig config = new JsonConfig();
		config.setExcludes(new String[]{"resources"});
		config.registerJsonValueProcessor(Date.class, new DateJsonUtil("yyyy-MM-dd HH:mm:ss"));
		JSONObject o = new JSONObject();
		o.put("total", repositoryService.createDeploymentQuery().deploymentNameLike("%" + s_name + "%").count());
		o.put("rows", JSONArray.fromObject(list, config));
		ResponseUtil.write(resp, o);
	}
	
	
	@PostMapping("svae")
	public void deploy(MultipartFile deployName, PrintWriter out){
		try {
			repositoryService.createDeployment()
							.addZipInputStream(new ZipInputStream(deployName.getInputStream()))
							.name(deployName.getOriginalFilename())
							.deploy();
		} catch (IOException e) {
			e.printStackTrace();
		}
		out.print("{\"success\":true}");
	}
	
	@PostMapping("delete")
	public void delete(String ids, PrintWriter out){
		String[] idArr = ids.split(",");
		for (String id : idArr)
			repositoryService.deleteDeployment(id, true);
		out.print("{\"success\":true}");
	}
}
