/* Header: contains the package and necessary imports. */
package com.prd.web.actions;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.pentaho.reporting.engine.classic.core.MasterReport;
import org.pentaho.reporting.engine.classic.core.ReportProcessingException;
import org.pentaho.reporting.engine.classic.core.modules.output.pageable.pdf.PdfReportUtil;
import org.pentaho.reporting.engine.classic.core.modules.output.table.base.StreamReportProcessor;
import org.pentaho.reporting.engine.classic.core.modules.output.table.html.AllItemsHtmlPrinter;
import org.pentaho.reporting.engine.classic.core.modules.output.table.html.FileSystemURLRewriter;
import org.pentaho.reporting.engine.classic.core.modules.output.table.html.HtmlPrinter;
import org.pentaho.reporting.engine.classic.core.modules.output.table.html.StreamHtmlOutputProcessor;
import org.pentaho.reporting.libraries.repository.ContentIOException;
import org.pentaho.reporting.libraries.repository.ContentLocation;
import org.pentaho.reporting.libraries.repository.DefaultNameGenerator;
import org.pentaho.reporting.libraries.repository.file.FileRepository;
import org.pentaho.reporting.libraries.resourceloader.Resource;
import org.pentaho.reporting.libraries.resourceloader.ResourceException;
import org.pentaho.reporting.libraries.resourceloader.ResourceManager;

/* The next line defines that this class is a Servlet, as well as the URL Mapping.  */
@WebServlet("/secondReport")
public class SecondReport extends HttpServlet {

  private static final long serialVersionUID = 1L;

  /* Method doGet(): this determines that this class will only respond to requests of the type HTTP GET. */
  protected void doGet(HttpServletRequest request,
                   HttpServletResponse response) throws ServletException, IOException {

   /* The following three lines take the parameters sent by the client and assign them to variables. In our case, we need "year" and "month" so that we can pass them to the PRD engine, since in our report we have defined the parameters "SelectYear"and "SelectMonth" respectively. The parameter "outputType" will 
help us to determine which type of output was required by the user.*/
//    Integer year = Integer.parseInt(request.getParameter("year"));
//    Integer month = Integer.parseInt(request.getParameter("month"));
//    String outputType = request.getParameter("outputType");

    String errorMsg = "";
    try {
/* The call to doReport() is the one that will finally process the report.*/
      doReport( response);
    } catch (Exception e) {
      e.printStackTrace();
      errorMsg = "ERROR: " + e.getMessage();
    }
/* The following if checks if an error has occurred, in which case creates a string with the error message and stores it in an attribute of the "request" object, and then performs a redirect to the index. */
    if (errorMsg.length() > 0) {
      request.setAttribute("errorMsg", errorMsg);
      RequestDispatcher dispatcher = getServletContext()
        .getRequestDispatcher("/index.jsp");
      dispatcher.forward(request, response);
    }
}

  /* Method doReport(): */
  private void doReport(HttpServletResponse response) throws ReportProcessingException,
      IOException, ResourceException, ContentIOException {
    
    /* -> Global Setup */
    ResourceManager manager = new ResourceManager();
    manager.registerDefaults();
    URL urlToReport = new URL("file:"
        + getServletContext().getRealPath(
            "WEB-INF/report/SecondReport.prpt"));
    Resource res = manager.createDirectly(urlToReport, MasterReport.class);
    MasterReport report = (MasterReport) res.getResource();

    response.setHeader("Content-disposition", "filename=out.html");

    

    
      response.setContentType("text/html");
      String fileName = "_out" + System.currentTimeMillis() + ".html";
      File folderOut = new File(getServletContext().getRealPath(
          "/out/" + System.currentTimeMillis()));

      if (!folderOut.exists()) {
        folderOut.mkdirs();
        final FileRepository targetRepository = new FileRepository(
            folderOut);
        final ContentLocation targetRoot = targetRepository.getRoot();
        final HtmlPrinter printer = new AllItemsHtmlPrinter(
            report.getResourceManager());
        printer.setContentWriter(targetRoot, new DefaultNameGenerator(
            targetRoot, fileName));
        printer.setDataWriter(targetRoot, new DefaultNameGenerator(
            targetRoot, "content"));
        printer.setUrlRewriter(new FileSystemURLRewriter());
        final StreamHtmlOutputProcessor outputProcessor = new StreamHtmlOutputProcessor(
            report.getConfiguration());
        outputProcessor.setPrinter(printer);
        final StreamReportProcessor reportProcessor = new StreamReportProcessor(
            report, outputProcessor);
        reportProcessor.processReport();
        reportProcessor.close();

        String route = "out/" + folderOut.getName() + "/" + fileName;
        response.sendRedirect(route);
      
    }
  }
}