package kr.go.nssp.menu.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class MenuDAO extends EgovComAbstractDAO {

	public List selectMenuList(HashMap map) throws Exception {
		return list("menu.selectMenuList", map);
	}

    public HashMap selectMenuDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("menu.selectMenuDetail", map);
    }

	public void insertMenu(HashMap map) throws Exception{
	    insert("menu.insertMenu", map);
	}
	
	public void updateMenu(HashMap map) throws Exception{
	    update("menu.updateMenu", map);
	}

	public List selectMenuClList(HashMap map) throws Exception {
		return list("menu.selectMenuClList", map);
	}

    public HashMap selectMenuClDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("menu.selectMenuClDetail", map);
    }

	public void insertMenuCl(HashMap map) throws Exception{
	    insert("menu.insertMenuCl", map);
	}
	
	public void updateMenuCl(HashMap map) throws Exception{
	    update("menu.updateMenuCl", map);
	}


	public List selectRelateList(HashMap map) throws Exception {
		return list("menu.selectRelateList", map);
	}

    public HashMap selectRelateDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("menu.selectRelateDetail", map);
    }

	public void insertRelate(HashMap map) throws Exception{
	    insert("menu.insertRelate", map);
	}

	public void updateRelate(HashMap map) throws Exception{
	    update("menu.updateRelate", map);
	}

	public void deleteRelate(HashMap map) throws Exception{
	    delete("menu.deleteRelate", map);
	}
	public int selectRelateCnt(HashMap map) throws Exception{
        return (Integer)selectByPk("menu.selectRelateCnt", map);
	}

	public List selectAuthorClList(HashMap map) throws Exception {
		return list("menu.selectAuthorClList", map);
	}

    public HashMap selectAuthorClDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("menu.selectAuthorClDetail", map);
    }

    public String selectAuthorCd(HashMap map) throws Exception {
        return (String)selectByPk("menu.selectAuthorCd", map);
    }

	public void insertAuthorCl(HashMap map) throws Exception{
	    insert("menu.insertAuthorCl", map);
	}
	
	public void updateAuthorCl(HashMap map) throws Exception{
	    update("menu.updateAuthorCl", map);
	}

	public List selectAuthorList(HashMap map) throws Exception {
		return list("menu.selectAuthorList", map);
	}

	public void insertAuthor(HashMap map) throws Exception{
	    insert("menu.insertAuthor", map);
	}

	public void deleteAuthor(HashMap map) throws Exception{
	    delete("menu.deleteAuthor", map);
	}

	public List<HashMap> selectAuthorChck(HashMap map) throws Exception {
		return list("menu.selectAuthorChck", map);
	}

	public List<HashMap> selectMenuClChck(HashMap map) throws Exception {
		return list("menu.selectMenuClChck", map);
	}

	public List<HashMap> selectMenuChck(HashMap map) throws Exception {
		return list("menu.selectMenuChck", map);
	}
}
