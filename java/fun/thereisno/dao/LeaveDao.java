package fun.thereisno.dao;

import java.util.List;
import java.util.Map;

import fun.thereisno.entity.Leave;

public interface LeaveDao {

	List<Leave> listLeave(Map<String, Object> map);
	
	Integer count(Map<String, Object> map);
	
	void save(Leave leave);
	
	Leave findById(Integer id);
	
	Leave findByInstanceId(Integer instanceId);
	
	void update(Leave leave);
}
