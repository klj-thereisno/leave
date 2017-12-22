package fun.thereisno.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import fun.thereisno.dao.LeaveDao;
import fun.thereisno.entity.Leave;
import fun.thereisno.service.LeaveService;
@Service
public class LeaveServiceImpl implements LeaveService{

	@Resource
	private LeaveDao leaveDao;
	
	public List<Leave> listLeave(Map<String, Object> map) {
		return leaveDao.listLeave(map);
	}

	public Integer count(Map<String, Object> map) {
		return leaveDao.count(map);
	}

	public void save(Leave leave) {
		leaveDao.save(leave);
	}

	public Leave findById(Integer id) {
		return leaveDao.findById(id);
	}

	public Leave findByInstanceId(Integer instanceId){
		return leaveDao.findByInstanceId(instanceId);
	}
	
	public void update(Leave leave) {
		leaveDao.update(leave);
	}
}
