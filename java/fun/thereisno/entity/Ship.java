package fun.thereisno.entity;

import java.util.List;

import org.activiti.engine.impl.persistence.entity.UserEntity;

public class Ship {

	private String id;
	private List<UserEntity> users;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public List<UserEntity> getUsers() {
		return users;
	}
	public void setUsers(List<UserEntity> users) {
		this.users = users;
	}
}
