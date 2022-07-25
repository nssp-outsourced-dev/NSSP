package kr.go.nssp.cmmn.web;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.go.nssp.utl.SimpleUtils;
import kr.go.nssp.cmmn.service.JusoPopService;
import kr.go.nssp.utl.InvUtil;

@Controller
@RequestMapping(value = "/juso/")
public class JusoPopController {

	@Autowired
	private JusoPopService jusoPopService;

	@RequestMapping(value="/jusoPopup/")
    public String zipPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("paramTxtId", request.getParameter("paramTxtId"));
        return "cmm/jusoPopup";
    }

	@RequestMapping (value = "/jusoListAjax/")
	public ModelAndView jusoListAjax (HttpServletRequest request) throws Exception {
		//현재 페이지 파라메타
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
        int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if( hidPageBlock== null || hidPageBlock.equals("")){
			hidPageBlock = "10";
		}
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

    	//page
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		Map map = InvUtil.getInstance().getParameterMap(request);
		map.put("startRow", paginationInfo.getFirstRecordIndex());
    	map.put("endRow", paginationInfo.getLastRecordIndex());
    	List<HashMap> list = jusoPopService.selectJusoList(map);
    	int list_cnt = 0;
    	if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}
    	HashMap cMap = new HashMap();
    	cMap.put("list", list);
    	cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
}
