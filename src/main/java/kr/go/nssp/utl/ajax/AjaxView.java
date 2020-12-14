package kr.go.nssp.utl.ajax;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * ModelAndView AjaxView에 대한 호출을 처리하는 VIEW
 * 넘어온 String Json 형식으로 변환하여 출력
 */
public class AjaxView extends AbstractView {

    @Override
    protected void renderMergedOutputModel(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("application/x-json");
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("UTF-8");
		Object ajaxList = model.get("ajaxData");
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
		String rString = gson.toJson(ajaxList);
		//System.out.println("response : " + rString);
		PrintWriter writer = response.getWriter();
		writer.write(rString);
    }
}
