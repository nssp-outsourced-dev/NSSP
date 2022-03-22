package kr.go.nssp.utl;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.poifs.crypt.EncryptionInfo;
import org.apache.poi.poifs.crypt.EncryptionMode;
import org.apache.poi.poifs.crypt.Encryptor;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.servlet.view.AbstractView;

import kr.go.nssp.utl.egov.EgovProperties;

/**
 * @packageName : kr.go.nssp.utl
 * @fileName : ExcelDownloader.java
 * @author : dgkim
 * @date : 2022.02.04
 * @description : * ===========================================================
 *              DATE AUTHOR NOTE *
 *              -----------------------------------------------------------
 *              2022.02.04 dgkim 최초 생성
 */
public class ExcelDownloader extends AbstractView {
	private String EXCEL_PASSWORD = EgovProperties.getProperty("Globals.excelPassword");// 엑셀 비밀번호

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String fileName = "";
		Map<String, Object> result = (Map<String, Object>) model.get("result");

		/*
		 * 참고 : http://www.mungchung.com/xe/protip/114275
		 */
		OutputStream os = null;
		Workbook workbook = null;
		ByteArrayOutputStream fileOut = new ByteArrayOutputStream();
		// FileOutputStream fos = new FileOutputStream(fileName);

		try {
			// workbook 생성
			if (result.containsKey("menuCd")) {
				String menuCd = String.valueOf(result.get("menuCd"));

				switch (menuCd) {
				case "00040":// 범죄사건부일 경우
					workbook = this.getCrimeCaseWorkbook((List<HashMap>) result.get("data"), request);
					
					fileName = "범죄사건부_EXCEL";
					break;
				default:
					break;
				}
			}
			fileName += ".xlsx";
			// workbook 생성 END

			// 각 브라우저에 따른 파일이름 인코딩
			String browser = request.getHeader("User-Agent");
			if (browser.indexOf("MSIE") > -1) {
				fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
			} else if (browser.indexOf("Trident") > -1) {// IE11
				fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
			} else if (browser.indexOf("Firefox") > -1) {
				fileName = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
			} else if (browser.indexOf("Opera") > -1) {
				fileName = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
			} else if (browser.indexOf("Chrome") > -1) {
				StringBuffer sb = new StringBuffer();
				for (int i = 0; i < fileName.length(); i++) {
					char c = fileName.charAt(i);
					if (c > '~') {
						sb.append(URLEncoder.encode("" + c, "UTF-8"));
					} else {
						sb.append(c);
					}
				}

				fileName = sb.toString();
			} else if (browser.indexOf("Safari") > -1) {
				fileName = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
			} else {
				fileName = "\"" + new String(fileName.getBytes("UTF-8"), "8859_1") + "\"";
			}

			response.setContentType("application/download;charset=utf-8");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
			response.setHeader("Content-Transfer-Encoding", "binary");

			workbook.write(fileOut);

			InputStream filein = new ByteArrayInputStream(fileOut.toByteArray());
			POIFSFileSystem fs = new POIFSFileSystem();
			EncryptionInfo info = new EncryptionInfo(EncryptionMode.agile);

			// setup the encryption
			Encryptor enc = info.getEncryptor();
			enc.confirmPassword(EXCEL_PASSWORD);

			OPCPackage opc = OPCPackage.open(filein);
			os = enc.getDataStream(fs);
			opc.save(os);
			opc.close();

			OutputStream fileOut2 = null;
			fileOut2 = response.getOutputStream();
			fs.writeFilesystem(fileOut2);
			fileOut2.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (workbook != null) {
				try {
					workbook.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			if (os != null) {
				try {
					os.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			fileOut.close();
		}
	}

	/**
	 * @methodName : getCrimeCaseWorkbook
	 * @date : 2022.02.04
	 * @author : dgkim
	 * @description : 범죄사건부 엑셀 생성
	 * @param data
	 * @return
	 * @throws Exception
	 */
	private XSSFWorkbook getCrimeCaseWorkbook(List<HashMap> data, HttpServletRequest request) throws Exception {
		final String[][] headerTxt = {
				{ "사건번호", "수리", "구분", "수사담당자", "피의자", "        ", "    ", "조회", "죄명(위반죄명)", "범죄", "                ",
						"피해정도", "피해자 등", "체포/구속", "       ", "            ", "        ", "        ", "석방일시및사유", "송치",
						"    ", "    ", "압수번호", "수사미결사건철번호", "검사처분", "    ", "판결요지", "    ", "비고", "범죄원표", "          ",
						"        " },
				{ "        ", "    ", "    ", "          ", "성명", "주민번호", "직업", "    ", "              ", "(발생)일시",
						"(발생)장소", "        ", "         ", "체포영장", "긴급체포", "현행범인체포", "구속영장", "인치구금", "              ",
						"연월일", "번호", "의견", "        ", "                  ", "연월일", "요지", "연월일", "요지", "    ", "발생사건표",
						"검거사건표", "피의자표" } };

		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet("Sheet 1");
		// sheet.protectSheet("1234");//시트 잠금

		/*
		 * sheet.setColumnWidth(0, 3000); sheet.setColumnWidth(1, 3000);
		 * sheet.setColumnWidth(2, 3000); sheet.setColumnWidth(3, 3000);
		 * sheet.setColumnWidth(4, 5000); sheet.setColumnWidth(5, 8000);
		 * 
		 * headerStyle.setBorderTop(BorderStyle.THIN);
		 * headerStyle.setBorderBottom(BorderStyle.THIN);
		 * headerStyle.setBorderRight(BorderStyle.THIN);
		 * headerStyle.setBorderLeft(BorderStyle.THIN);
		 * headerStyle.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
		 * headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND); //배경색 쓸 때 필수
		 * 
		 */

		XSSFCellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setAlignment(HorizontalAlignment.CENTER);
		headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

		/*
		 * headerStyle.setFillForegroundColor(new XSSFColor(new java.awt.Color(238, 238,
		 * 238))); headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		 * 
		 * headerStyle.setBorderColor(BorderSide.LEFT, new XSSFColor(new
		 * java.awt.Color(220, 220, 220)));
		 * headerStyle.setBorderBottom(BorderStyle.THIN);
		 */

		XSSFCell headerCell = null;

		// 헤더 행 생성
		for (int i = 0; i < headerTxt.length; i++) {
			XSSFRow headerRow = sheet.createRow(i);

			for (int j = 0; j < headerTxt[i].length; j++) {// 해당 행의 열 셀 생성
				sheet.setColumnWidth(j, 5000);

				headerCell = headerRow.createCell(j);
				headerCell.setCellStyle(headerStyle);// headerCell style 지정
				headerCell.setCellValue(headerTxt[i][j]);
				// System.err.println("i: " + i + ", j: " + j + ", text: " + headerTxt[i][j]);
			}
		}

		// 셀병합
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 0/* 첫열 */, 0/* 마지막열 */));// 사건번호
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 1/* 첫열 */, 1/* 마지막열 */));// 수리
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 2/* 첫열 */, 2/* 마지막열 */));// 구분
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 3/* 첫열 */, 3/* 마지막열 */));// 수사담당자
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 0/* 마지막행 */, 4/* 첫열 */, 6/* 마지막열 */));// 피의자
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 7/* 첫열 */, 7/* 마지막열 */));// 조회
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 8/* 첫열 */, 8/* 마지막열 */));// 죄명(위반죄명)
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 0/* 마지막행 */, 9/* 첫열 */, 10/* 마지막열 */));// 범죄
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 11/* 첫열 */, 11/* 마지막열 */));// 피해정도
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 12/* 첫열 */, 12/* 마지막열 */));// 피해자 등
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 0/* 마지막행 */, 13/* 첫열 */, 17/* 마지막열 */));// 체포/구속
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 18/* 첫열 */, 18/* 마지막열 */));// 석방일시및사유
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 0/* 마지막행 */, 19/* 첫열 */, 21/* 마지막열 */));// 송치
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 22/* 첫열 */, 22/* 마지막열 */));// 압수번호
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 23/* 첫열 */, 23/* 마지막열 */));// 수사미결사건철번호
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 0/* 마지막행 */, 24/* 첫열 */, 25/* 마지막열 */));// 검사처분
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 0/* 마지막행 */, 26/* 첫열 */, 27/* 마지막열 */));// 판결요지
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 1/* 마지막행 */, 28/* 첫열 */, 28/* 마지막열 */));// 비고
		sheet.addMergedRegion(new CellRangeAddress(0/* 첫행 */, 0/* 마지막행 */, 29/* 첫열 */, 31/* 마지막열 */));// 범죄원표

		XSSFCellStyle bodyStyle = workbook.createCellStyle();
		bodyStyle.setAlignment(HorizontalAlignment.CENTER);
		bodyStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		// bodyStyle.setBorderTop(BorderStyle.THIN);
		// bodyStyle.setBorderBottom(BorderStyle.THIN);
		// bodyStyle.setBorderRight(BorderStyle.THIN);
		// bodyStyle.setBorderLeft(BorderStyle.THIN);

		XSSFRow bodyRow = null;
		XSSFCell bodyCell = null;
		for (int i = 0; i < data.size(); i++) {
			// list 값 꺼내오기
			HashMap item = data.get(i);
			// 행 생성
			bodyRow = sheet.createRow(i + headerTxt.length);// 헤더 다음번째 부터

			bodyCell = bodyRow.createCell(0);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("CASE_NO")))) ? "" : String.valueOf(item.get("CASE_NO")));

			bodyCell = bodyRow.createCell(1);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("PRSCT_DE")))) ? "" : String.valueOf(item.get("PRSCT_DE")));

			bodyCell = bodyRow.createCell(2);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("INV_PROVIS_NM")))) ? ""
					: String.valueOf(item.get("INV_PROVIS_NM")));

			bodyCell = bodyRow.createCell(3);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue("null".equals(String.valueOf(item.get("CHARGER_NM"))) ? ""
					: String.valueOf(item.get("CHARGER_NM")));

			bodyCell = bodyRow.createCell(4);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("TRGTER_NM")))) ? ""
					: String.valueOf(item.get("TRGTER_NM")));

			bodyCell = bodyRow.createCell(5);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("TRGTER_RRN")))) ? ""
					: String.valueOf(item.get("TRGTER_RRN")));

			bodyCell = bodyRow.createCell(6);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("OCCP_NM")))) ? "" : String.valueOf(item.get("OCCP_NM")));

			bodyCell = bodyRow.createCell(7);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TEMP1")))) ? "" : String.valueOf(item.get("TEMP1")));

			bodyCell = bodyRow.createCell(8);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("VIOLT_NM")))) ? "" : String.valueOf(item.get("VIOLT_NM")));

			bodyCell = bodyRow.createCell(9);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("OCCRRNC_BEGIN_DT")))) ? ""
					: String.valueOf(item.get("OCCRRNC_BEGIN_DT")));

			bodyCell = bodyRow.createCell(10);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("OCCRRNC_ADDR")))) ? ""
					: String.valueOf(item.get("OCCRRNC_ADDR")));

			bodyCell = bodyRow.createCell(11);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TEMP2")))) ? "" : String.valueOf(item.get("TEMP2")));

			bodyCell = bodyRow.createCell(12);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("SUFRER_NM"))) ? ""
					: String.valueOf(item.get("SUFRER_NM"))));

			bodyCell = bodyRow.createCell(13);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TEMP22")))) ? "" : String.valueOf(item.get("TEMP22")));

			bodyCell = bodyRow.createCell(14);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TEMP23")))) ? "" : String.valueOf(item.get("TEMP23")));

			bodyCell = bodyRow.createCell(15);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TEMP24"))) ? "" : String.valueOf(item.get("TEMP24"))));

			bodyCell = bodyRow.createCell(16);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TEMP25")))) ? "" : String.valueOf(item.get("TEMP25")));

			bodyCell = bodyRow.createCell(17);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("ATTRACT_PLACE")))) ? ""
					: String.valueOf(item.get("ATTRACT_PLACE")));

			bodyCell = bodyRow.createCell(18);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("RSL_DT"))) ? "" : String.valueOf(item.get("RSL_DT"))));

			bodyCell = bodyRow.createCell(19);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TRN_DE"))) ? "" : String.valueOf(item.get("TRN_DE"))));

			bodyCell = bodyRow.createCell(20);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TRN_NO"))) ? "" : String.valueOf(item.get("TRN_NO"))));

			bodyCell = bodyRow.createCell(21);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("TRN_OPINION_NM")))) ? ""
					: String.valueOf(item.get("TRN_OPINION_NM")));

			bodyCell = bodyRow.createCell(22);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("CCDRC_NO")))) ? "" : String.valueOf(item.get("CCDRC_NO")));

			bodyCell = bodyRow.createCell(23);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("TEMP3")))) ? "" : String.valueOf(item.get("TEMP3")));

			bodyCell = bodyRow.createCell(24);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("PRSEC_DSPS_DE")))) ? ""
					: String.valueOf(item.get("PRSEC_DSPS_DE")));

			bodyCell = bodyRow.createCell(25);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("PRSEC_DSPS_OUTLINE"))) ? ""
					: String.valueOf(item.get("PRSEC_DSPS_OUTLINE"))));

			bodyCell = bodyRow.createCell(26);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("JUDMN_DE")))) ? "" : String.valueOf(item.get("JUDMN_DE")));

			bodyCell = bodyRow.createCell(27);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("JUDMN_OUTLINE")))) ? ""
					: String.valueOf(item.get("JUDMN_OUTLINE")));

			bodyCell = bodyRow.createCell(28);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(
					("null".equals(String.valueOf(item.get("RM")))) ? "" : String.valueOf(item.get("RM")));

			bodyCell = bodyRow.createCell(29);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("OCCRRNC_ZERO_NO")))) ? ""
					: String.valueOf(item.get("OCCRRNC_ZERO_NO")));

			bodyCell = bodyRow.createCell(30);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue(("null".equals(String.valueOf(item.get("ARREST_ZERO_NO")))) ? ""
					: String.valueOf(item.get("ARREST_ZERO_NO")));

			bodyCell = bodyRow.createCell(31);
			bodyCell.setCellStyle(bodyStyle);
			bodyCell.setCellValue("null".equals(String.valueOf(item.get("SUSPCT_ZERO_NO"))) ? ""
					: String.valueOf(item.get("SUSPCT_ZERO_NO")));
		}
		
		// body cell 병합
		for (int i = sheet.getFirstRowNum() + headerTxt.length; i <= sheet.getLastRowNum(); i++) {
			String currentCaseNo = sheet.getRow(i).getCell(0).getStringCellValue();// 현재행 사건번호
			String nextCaseNo = ((i + 1) > sheet.getLastRowNum()) ? "" : sheet.getRow(i + 1).getCell(0).getStringCellValue();// 다음행 사건번호

			if(currentCaseNo == nextCaseNo) {//현재행 사건번호랑 다음행 사건번호가 같으면
				for (int j = i + 1; j <= sheet.getLastRowNum() + 1; j++) {// 현재행부터 마지막행까지 loop
					//System.out.println("i: " + i + ", j" + j);
					
					if (currentCaseNo != (( j > sheet.getLastRowNum() ) ? "" : sheet.getRow(j).getCell(0).getStringCellValue())) {// 사건번호가 다르면
						// 사건번호가 같은것까지 병합
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 0/* 첫열 */, 0/* 마지막열 */));// 사건번호
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 1/* 첫열 */, 1/* 마지막열 */));// 수리
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 2/* 첫열 */, 2/* 마지막열 */));// 구분
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 3/* 첫열 */, 3/* 마지막열 */));// 수사담당자
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 9/* 첫열 */, 9/* 마지막열 */));// (발생)일시
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 10/* 첫열 */, 10/* 마지막열 */));// (발생)장소
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 12/* 첫열 */, 12/* 마지막열 */));// 피해자
																															// 등
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 29/* 첫열 */, 29/* 마지막열 */));// 발생사건표
						sheet.addMergedRegion(new CellRangeAddress(i/* 첫행 */, j - 1/* 마지막행 */, 30/* 첫열 */, 30/* 마지막열 */));// 검거사건표
						i = j - 1;// 위 for문 진입시 +1를 하기 때문에 -1로 설정
						break;
					}
				}
			}
		}
		
		/*
		 * 2022.03.14
		 * coded by dgkim
		 * 범죄사건부 보안조치 출력자 출력
		 * 권종열 사무관 요청
		 * */
		bodyRow = sheet.createRow(data.size() + headerTxt.length + 5);
		bodyCell = bodyRow.createCell(0);
		bodyCell.setCellStyle(bodyStyle);
		bodyCell.setCellValue("IP");
		
		bodyCell = bodyRow.createCell(1);
		bodyCell.setCellStyle(bodyStyle);
		bodyCell.setCellValue("출력일시");
		
		bodyCell = bodyRow.createCell(2);
		bodyCell.setCellStyle(bodyStyle);
		bodyCell.setCellValue("사용자 ID");

		bodyRow = sheet.createRow(data.size() + headerTxt.length + 6);
		bodyCell = bodyRow.createCell(0);
		bodyCell.setCellStyle(bodyStyle);
		bodyCell.setCellValue(request.getRemoteAddr());
		
		bodyCell = bodyRow.createCell(1);
		bodyCell.setCellStyle(bodyStyle);
		bodyCell.setCellValue(new SimpleDateFormat("yyyy. MM. dd. HH:mm:ss").format(new Date()));
		
		bodyCell = bodyRow.createCell(2);
		bodyCell.setCellStyle(bodyStyle);
		bodyCell.setCellValue(String.valueOf(request.getSession().getAttribute("user_id")));
		
		return workbook;
	}
}
