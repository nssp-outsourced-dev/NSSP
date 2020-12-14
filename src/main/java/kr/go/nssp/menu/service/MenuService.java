package kr.go.nssp.menu.service;

import java.util.HashMap;
import java.util.List;

public interface MenuService {
    public List<HashMap> getMenuList(HashMap map) throws Exception;
    public HashMap getMenuDetail(HashMap map) throws Exception;
	public void addMenu(HashMap map) throws Exception;
	public void updateMenu(HashMap map) throws Exception;

    public List<HashMap> getMenuClList(HashMap map) throws Exception;
    public HashMap getMenuClDetail(HashMap map) throws Exception;
	public void addMenuCl(HashMap map) throws Exception;
	public void updateMenuCl(HashMap map) throws Exception;

	public List getRelateList(HashMap map) throws Exception;
    public HashMap getRelateDetail(HashMap map) throws Exception;
	public void addRelate(HashMap map) throws Exception;
	public void updateRelate(HashMap map) throws Exception;
	public void deleteRelate(HashMap map) throws Exception;
    public int getRelateCnt(HashMap map) throws Exception;

    public List<HashMap> getAuthorClList(HashMap map) throws Exception;
    public HashMap getAuthorClDetail(HashMap map) throws Exception;
	public void addAuthorCl(HashMap map) throws Exception;
	public void updateAuthorCl(HashMap map) throws Exception;

    public List<HashMap> getAuthorList(HashMap map) throws Exception;

    public List<HashMap> getAuthorChck(HashMap map) throws Exception;
    public List<HashMap> getMenuClChck(HashMap map) throws Exception;
    public List<HashMap> getMenuChck(HashMap map) throws Exception;
}
