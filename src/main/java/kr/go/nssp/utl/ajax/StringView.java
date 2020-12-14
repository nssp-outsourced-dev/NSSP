package kr.go.nssp.utl.ajax;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

/**
 * ModelAndView StringView에 대한 호출을 처리하는 VIEW
 * 넘어온 String 을 그대로 출력
 */
public class StringView extends AbstractView {

    @Override
    protected void renderMergedOutputModel(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("application/x-json");
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("UTF-8");
		String rString = (String) model.get("stringData");
		PrintWriter writer = response.getWriter();
		writer.write(rString);
    }
}
