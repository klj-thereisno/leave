package fun.thereisno.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.springframework.stereotype.Service;

import fun.thereisno.dao.UserDao;
import fun.thereisno.entity.User;
import fun.thereisno.service.UserService;
@Service
public class UserServiceImpl implements UserService{

	@Resource
	private UserDao userDao;
	
	public List<User> list(Map<String, Object> map) {
		return userDao.list(map);
	}

	public Integer count(Map<String, Object> map) {
		return userDao.count(map);
	}
	
	public User getUserById(String id) {
		return userDao.getUserById(id);
	}

	public void update(UserEntity user) {
		// TODO Auto-generated method stub
		userDao.update(user);
	}

	public void delete(Map<String, Object> map) {
		// TODO Auto-generated method stub
		userDao.delete(map);
	}

}
