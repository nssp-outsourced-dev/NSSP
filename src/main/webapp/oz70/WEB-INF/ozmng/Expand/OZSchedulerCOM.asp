<%
	Dim Com
	Set Com = Server.CreateObject("SchedulerCOM.CSchedulerCall.1")

	If Not IsObject (Com) Then

		Response.Write("File이 정상적으로 생성되지 않았습니다.")
		Response.End

	Else

		With Com

			.Init()

			.SetServerIP "127.0.0.1"
			.SetServerPort "8003"
			.SetServerType "TCP"

'			.SetServerURL "http://127.0.0.1/oz50/server"
'			.SetServerType "Servlet"

			.SetSchedulerIP "127.0.0.1"
			.SetSchedulerPort "9521"
			.SetUser "admin"
			.SetPassword "admin"

			.SetProperty "launch_type", "immediately"
			.setProperty "cfg.type","new"
			
			
      .setExportProperty "connection.server", "127.0.0.1"
      .setExportProperty "connection.port", "8003"
      .setExportProperty "connection.reportName", "/parameter_test.ozr"
      .setExportProperty "connection.fetchtype", "BATCH"
      .setExportProperty "connection.args1=formparam", "form1"
      .setExportProperty "connection.args2=odiparam", "form2"
      .setExportProperty "connection.pcount", "2"
      .setExportProperty "odi.parameter_test.args1", "odiparam=odi1"
      .setExportProperty "odi.parameter_test.args2", "odiparam2=odi2"
      .setExportProperty "odi.parameter_test.pcount", "2"
      .setExportProperty "odi.odinames", "parameter_test"
      .setExportProperty "export.format", "ozd/html/jpg/xls/doc/svg/txt/ppt/tif/csv"
      .setExportProperty "ozd.filename", "test.ozd"
      .setExportProperty "html.filename", "test.html"
      .setExportProperty "jpg.filename", "test.jpg"
      .setExportProperty "excel.filename", "test.xls"
      .setExportProperty "word.filename", "test.doc"
      .setExportProperty "svg.filename", "test.svg"
      .setExportProperty "text.filename", "test.txt"
      .setExportProperty "ppt.filename", "test.ppt"
      .setExportProperty "tiff.filename", "test.tif"
      .setExportProperty "csv.filename", "test.csv"
      .setExportProperty "viewer.childcount", "1"
      .setExportProperty "child1.connection.server", "127.0.0.1"
      .setExportProperty "child1.connection.port", "8003"
      .setExportProperty "child1.connection.reportName", "/parameter_test.ozr"
      .setExportProperty "child1.connection.fetchtype", "BATCH"
      .setExportProperty "child1.connection.args1=formparam", "form1"
      .setExportProperty "child1.connection.args2=odiparam", "form2"
      .setExportProperty "child1.connection.pcount", "2"
      .setExportProperty "child1.odi.parameter_test.args1", "odiparam=odi1"
      .setExportProperty "child1.odi.parameter_test.args2", "odiparam2=odi2"
      .setExportProperty "child1.odi.parameter_test.pcount", "2"
      .setExportProperty "child1.odi.odinames", "parameter_test"
      .setExportProperty "child1.export.format", "ozd/html/jpg/xls/doc/svg/txt/ppt/tif/csv"
      .setExportProperty "child1.ozd.filename", "child_test.ozd"
      .setExportProperty "child1.html.filename", "child_test.html"
      .setExportProperty "child1.jpg.filename", "child_test.jpg"
      .setExportProperty "child1.excel.filename", "child_test.xls"
      .setExportProperty "child1.word.filename", "child_test.doc"
      .setExportProperty "child1.svg.filename", "child_test.svg"
      .setExportProperty "child1.text.filename", "child_test.txt"
      .setExportProperty "child1.ppt.filename", "child_test.ppt"
      .setExportProperty "child1.tiff.filename", "child_test.tif"
      .setExportProperty "child1.csv.filename", "child_test.csv"


			.Export()

			Response.Write(.IsExportSuccessed())

			.Clean()

		End With

		Set Com = Nothing

	End If
%>
