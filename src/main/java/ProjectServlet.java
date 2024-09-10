import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 8454090657443906965L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:oracle:thin:@localhost:1521/orcl";
        String user = "system"; 
        String password = "oracle"; 

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, user, password);

            CallableStatement stmt = conn.prepareCall("{call insert_new_project(?,?,?,?,?,?,?,?,?,?)}");
            stmt.setInt(1, Integer.parseInt(request.getParameter("projectID")));
            stmt.setString(2, request.getParameter("name"));
            stmt.setString(3, request.getParameter("type"));
            stmt.setString(4, request.getParameter("purpose"));
            stmt.setString(5, request.getParameter("location"));
            stmt.setDate(6, java.sql.Date.valueOf(request.getParameter("startDate")));
            stmt.setDate(7, java.sql.Date.valueOf(request.getParameter("expectedCompletionDate")));
            stmt.setDouble(8, Double.parseDouble(request.getParameter("budget")));
            stmt.setInt(9, Integer.parseInt(request.getParameter("numberOfMilestones")));
            stmt.setInt(10, Integer.parseInt(request.getParameter("managerID")));
            stmt.execute();

            PrintWriter out = response.getWriter();
            out.println("Project inserted successfully!");

            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
        }
    }
}
