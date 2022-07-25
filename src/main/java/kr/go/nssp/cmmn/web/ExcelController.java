package kr.go.nssp.cmmn.web;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.go.nssp.cmmn.service.ExcelService;
import kr.go.nssp.utl.Excel;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/cmm/")
public class ExcelController {

	@Resource
    private ExcelService excelService;

    @RequestMapping(value="/excel/")
    public void excelCreate(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        Utility utility = Utility.getInstance();
		HashMap map = new HashMap();
		List<HashMap> list = null;
        list = excelService.excelContents(map);
        
		//head(columnValue, headValue)
		LinkedHashMap<String, Object> labelm = new LinkedHashMap<String, Object>();

        labelm.put("title1", "TEXT1");
        labelm.put("title2", "TEXT2");
        labelm.put("title3", "TEXT3");
        labelm.put("title4", "TEXT4");
        labelm.put("title5", "TEXT5");
        labelm.put("title6", "TEXT6");
        labelm.put("title7", "TEXT7");
        labelm.put("title8", "TEXT8");
        labelm.put("title9", "TEXT9");
        labelm.put("title10", "TEXT10");

		//subHead(colspan, headValue)
		LinkedHashMap<String, Object> subLabelm = new LinkedHashMap<String, Object>();
        subLabelm.put("Bigtitle1", "2");
        subLabelm.put("Bigtitle2", "3");
        subLabelm.put("Bigtitle3", "4");
        subLabelm.put("Bigtitle4", "1");


        Excel excel = new Excel();
        
        /* 표 한개 
        //엑셀 data 세팅
        if(excel.setExcel(list, labelm, subLabelm, "엑셀 첫번째")){
        	//엑셀 다운로드
        	if(excel.excelDownload("gogo.xls", response)){
				//성공
        	}
        }
        */

        /* 표 여러개 */
        //엑셀 data 세팅
        excel.setExcel(list, labelm, subLabelm, "엑셀 첫번째");
        excel.setExcel(list, labelm, subLabelm, "엑셀 두번째");
    	//엑셀 다운로드
    	if(excel.excelDownload("gogo.xls", response)){
    		//성공
    	}        

        //model.addAttribute("excel", utility.excelDownload(list, labelm, subLabelm, subject));
        //return "cmm/excelCreate";

    }

}
