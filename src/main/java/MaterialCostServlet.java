import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MaterialCostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:oracle:thin:@localhost:1521/orcl";
        String user = "system"; 
        String password = "oracle"; 

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, user, password);

            String sql = "SELECT SUM(m.cost) as totalCost FROM Project p JOIN ProjectMaterial pm ON p.projectID = pm.projectID JOIN Material m ON pm.materialID = m.materialID WHERE p.projectID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(request.getParameter("projectID")));
            ResultSet rs = stmt.executeQuery();

            PrintWriter out = response.getWriter();
            if(rs.next()){
                out.println("Project ID: " + request.getParameter("projectID") + ", Total Material Cost: " + rs.getInt("totalCost"));
            } else {
                out.println("No data found for project ID: " + request.getParameter("projectID"));
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
        }
    }
}