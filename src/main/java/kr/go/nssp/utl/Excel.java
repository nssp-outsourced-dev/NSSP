package kr.go.nssp.utl;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import javax.servlet.http.HttpServletResponse;

public class Excel {
    private String setHtml = "";

    public boolean setExcel(List<HashMap> data, LinkedHashMap plabel, LinkedHashMap subLabelm, String subject) {
        try {
            this.setHtml = String.valueOf(this.setHtml) + "<table border=\"1\" style=\"table-layout: fixed; width: 100%;\">";
            this.setHtml = String.valueOf(this.setHtml) + "\t<thead>";
            this.setHtml = String.valueOf(this.setHtml) + "\t\t<tr>";
            if (plabel.size() > 0) {
                this.setHtml = String.valueOf(this.setHtml) + "<th colspan=\"" + (plabel.size() + 1) + "\" style=\"height:40px; font-weight:bold; font-size:25px;\"> ";
            } else {
                this.setHtml = String.valueOf(this.setHtml) + "<th style=\"height:40px; font-weight:bold; font-size:25px;\"> ";
            }
            this.setHtml = String.valueOf(this.setHtml) + subject;
            this.setHtml = String.valueOf(this.setHtml) + "\t\t</th>";
            this.setHtml = String.valueOf(this.setHtml) + "\t</tr>";
            this.setHtml = String.valueOf(this.setHtml) + "\t<tr>";
            if (plabel.size() > 0) {
                this.setHtml = String.valueOf(this.setHtml) + "<th colspan=\"" + (plabel.size() + 1) + "\" style=\"background-color: #e1d7ed; height:10px;\"></th> ";
            } else {
                this.setHtml = String.valueOf(this.setHtml) + "<th style=\"background-color: #e1d7ed; height:10px;\"></th> ";
            }
            this.setHtml = String.valueOf(this.setHtml) + "\t\t</tr>";
            if (subLabelm.size() > 0) {
                this.setHtml = this.setHtml + "\t\t<tr>";
                this.setHtml = this.setHtml + "\t\t<th style=\"background-color: #e5f2fc; height:30px;\" colspan=\"1\" rowspan=\"2\">번호</th>";
                for (Iterator<String> iterator = subLabelm.keySet().iterator(); iterator.hasNext(); ) {
                    String key = iterator.next();
                    if (key != null && subLabelm.get(key) != null) {
                        this.setHtml = String.valueOf(this.setHtml) + "<th colspan=\"" + subLabelm.get(key) + "\" style=\"background-color: #e5f2fc; height:30px;\">";
                        this.setHtml = String.valueOf(this.setHtml) + key;
                        this.setHtml = String.valueOf(this.setHtml) + "</th>";
                    }
                }
                this.setHtml = String.valueOf(this.setHtml) + "\t\t</tr>";
            }
            this.setHtml = String.valueOf(this.setHtml) + "\t\t<tr>";
            if (subLabelm.size() == 0)
                this.setHtml = this.setHtml + "\t\t<th style=\"background-color: #e5f2fc; height:30px;\" colspan=\"1\" rowspan=\"1\">번호</th>";
            for (Iterator<String> iter = plabel.keySet().iterator(); iter.hasNext(); ) {
                String key = iter.next();
                if (plabel.get(key) != null)
                    this.setHtml = String.valueOf(this.setHtml) + "\t\t<th style=\"background-color: #e5f2fc; height:30px;\">" + key + "</th>";
            }
            this.setHtml = String.valueOf(this.setHtml) + "\t\t</tr>";
            this.setHtml = String.valueOf(this.setHtml) + "\t</thead>";
            this.setHtml = String.valueOf(this.setHtml) + "\t<tbody>";
            int i = 1;
            for (HashMap sMap : data) {
                this.setHtml = String.valueOf(this.setHtml) + "<tr>";
                this.setHtml = String.valueOf(this.setHtml) + "\t<td>" + i + "</td>";
                for (Iterator<String> iterator = plabel.keySet().iterator(); iterator.hasNext(); ) {
                    String key = iterator.next();
                    String keyValue = (String)plabel.get(key);
                    String rowdata = "";
                    if (sMap.get(keyValue) != null)
                        rowdata = SimpleUtils.default_set(sMap.get(keyValue).toString());
                    this.setHtml = String.valueOf(this.setHtml) + "\t<td>" + rowdata + "</td>";
                }
                this.setHtml = String.valueOf(this.setHtml) + "</tr>";
                i++;
            }
            this.setHtml = String.valueOf(this.setHtml) + "\t</tbody>";
            this.setHtml = String.valueOf(this.setHtml) + "</table>";
            this.setHtml = String.valueOf(this.setHtml) + "<br>";
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public void init() {
        this.setHtml = "";
    }

    public boolean excelDownload(String excelFileName, HttpServletResponse response) {
        String innerHtml = "";
        response.setHeader("Content-Disposition", "attachment; filename=" + excelFileName);
        response.setHeader("Content-Description", "JSP Generated Data");
        response.setContentType("application/vnd.ms-excel;charset=utf-8");
        try {
            innerHtml = String.valueOf(innerHtml) + "<!DOCTYPE html>";
            innerHtml = String.valueOf(innerHtml) + "<html>";
            innerHtml = String.valueOf(innerHtml) + "<head>";
            innerHtml = String.valueOf(innerHtml) + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
            innerHtml = String.valueOf(innerHtml) + "<title>excel</title>";
            innerHtml = String.valueOf(innerHtml) + "<style>";
            innerHtml = String.valueOf(innerHtml) + "td {mso-number-format:\"@\"}";
            innerHtml = String.valueOf(innerHtml) + "</style>";
            innerHtml = String.valueOf(innerHtml) + "</head>";
            innerHtml = String.valueOf(innerHtml) + "<body>";
            innerHtml = String.valueOf(innerHtml) + this.setHtml;
            innerHtml = String.valueOf(innerHtml) + "</body>";
            innerHtml = String.valueOf(innerHtml) + "</html>";
            PrintWriter writer = response.getWriter();
            writer.write(innerHtml);
            writer.close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
