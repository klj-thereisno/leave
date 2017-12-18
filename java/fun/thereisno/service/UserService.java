package fun.thereisno.service;

import java.util.List;
import java.util.Map;

import org.activiti.engine.impl.persistence.entity.UserEntity;

import fun.thereisno.entity.User;

public interface UserService {

	List<User> list(Map<String, Object> map);
	
	Integer count(Map<String, Object> map);
	
	/**
	 * @param id id_
	 * @return
	 */
	User getUserById(String id);
	
	void update(UserEntity user);

	void delete(Map<String, Object> map);
}
