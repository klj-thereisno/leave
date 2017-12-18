package fun.thereisno.dao;

import java.util.List;
import java.util.Map;

import fun.thereisno.entity.Ship;

public interface ShipDao {

	List<Ship> listById(Map<String, Object> map);
	
}
