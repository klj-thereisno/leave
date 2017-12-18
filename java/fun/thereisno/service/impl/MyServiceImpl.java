package fun.thereisno.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import fun.thereisno.dao.MyDao;
import fun.thereisno.service.MyService;

@Service
public class MyServiceImpl implements MyService{

	@Resource
	private MyDao myDao;

	public void updatePassword(String id, String password) {
		// TODO Auto-generated method stub
		myDao.updatePassword(id, password);
	}
	
	
}
