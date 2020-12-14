package kr.go.nssp.menu.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.go.nssp.menu.service.MenuService;

@Service("MenuService")
public class MenuServiceImpl implements MenuService {

	@Resource(name = "menuDAO")
	private MenuDAO menuDAO;


    public List<HashMap> getMenuList(HashMap map) throws Exception {
        return menuDAO.selectMenuList(map);
    }

    public HashMap getMenuDetail(HashMap map) throws Exception {
        return menuDAO.selectMenuDetail(map);
    }

	public void addMenu(HashMap map) throws Exception {
		menuDAO.insertMenu(map);
	}

	public void updateMenu(HashMap map) throws Exception {
		menuDAO.updateMenu(map);
	}

    public List<HashMap> getMenuClList(HashMap map) throws Exception {
        return menuDAO.selectMenuClList(map);
    }

    public HashMap getMenuClDetail(HashMap map) throws Exception {
        return menuDAO.selectMenuClDetail(map);
    }

	public void addMenuCl(HashMap map) throws Exception {
		menuDAO.insertMenuCl(map);
	}

	public void updateMenuCl(HashMap map) throws Exception {
		menuDAO.updateMenuCl(map);
	}

	
	public List getRelateList(HashMap map) throws Exception {
        return menuDAO.selectRelateList(map);
	}

    public HashMap getRelateDetail(HashMap map) throws Exception {
        return menuDAO.selectRelateDetail(map);
    }

	public void addRelate(HashMap map) throws Exception{
		menuDAO.insertRelate(map);
	}
	public void updateRelate(HashMap map) throws Exception{
		menuDAO.updateRelate(map);
	}

	public void deleteRelate(HashMap map) throws Exception{
		menuDAO.deleteRelate(map);
	}
    public int getRelateCnt(HashMap map) throws Exception {
        return menuDAO.selectRelateCnt(map);
    }

    public List<HashMap> getAuthorClList(HashMap map) throws Exception {
        return menuDAO.selectAuthorClList(map);
    }
    
    public HashMap getAuthorClDetail(HashMap map) throws Exception {
        return menuDAO.selectAuthorClDetail(map);
    }

	public void addAuthorCl(HashMap map) throws Exception {
		HashMap mMap = new HashMap();
		String author_cd = menuDAO.selectAuthorCd(mMap);
		String esntl_id = (String) map.get("esntl_id");
		map.put("author_cd", author_cd);
		menuDAO.insertAuthorCl(map);

		//전체권한 삭제
		mMap.put("author_cd", author_cd);
		mMap.put("esntl_id", esntl_id);
		menuDAO.deleteAuthor(mMap);
		
		//선택권한 등록
		String[] menu_list = (String[]) map.get("menu_list");
		for(String menu_cd:menu_list) {
			mMap.put("menu_cd", menu_cd);
			menuDAO.insertAuthor(mMap);
		}
		
	}

	public void updateAuthorCl(HashMap map) throws Exception {
		menuDAO.updateAuthorCl(map);

		String author_cd = (String) map.get("author_cd");
		String esntl_id = (String) map.get("esntl_id");

		//전체권한 삭제
		HashMap mMap = new HashMap();
		mMap.put("author_cd", author_cd);
		mMap.put("esntl_id", esntl_id);
		menuDAO.deleteAuthor(mMap);
		
		//선택권한 등록
		String[] menu_list = (String[]) map.get("menu_list");
		for(String menu_cd:menu_list) {
			mMap.put("menu_cd", menu_cd);
			menuDAO.insertAuthor(mMap);
		}
	}

    public List<HashMap> getAuthorList(HashMap map) throws Exception {
        return menuDAO.selectAuthorList(map);
    }

    public List<HashMap> getAuthorChck(HashMap map) throws Exception{ 
        return menuDAO.selectAuthorChck(map);
    }

    public List<HashMap> getMenuClChck(HashMap map) throws Exception{ 
        return menuDAO.selectMenuClChck(map);
    }

    public List<HashMap> getMenuChck(HashMap map) throws Exception{ 
        return menuDAO.selectMenuChck(map);
    }
}
