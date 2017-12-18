package fun.thereisno.entity;

public class PageBean {

	@SuppressWarnings("unused")
	private Integer start;
	private Integer page;
	private Integer rows;
	public Integer getPage() {
		return page;
	}
	public void setPage(Integer page) {
		this.page = page;
	}
	public Integer getRows() {
		return rows;
	}
	public void setRows(Integer rows) {
		this.rows = rows;
	}
	public Integer getStart() {
		return (page - 1) * rows;
	}
}
