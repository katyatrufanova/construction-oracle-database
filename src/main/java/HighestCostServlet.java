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

public class HighestCostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:oracle:thin:@localhost:1521/orcl";
        String user = "system"; 
        String password = "oracle"; 

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, user, password);

            String sql = "SELECT p.projectID, p.name, SUM(m.cost) as totalMaterialCost " +
                         "FROM Project p " +
                         "JOIN ProjectMaterial pm ON p.projectID = pm.projectID " +
                         "JOIN Material m ON pm.materialID = m.materialID " +
                         "GROUP BY p.projectID, p.name " +
                         "ORDER BY totalMaterialCost DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            PrintWriter out = response.getWriter();
            while(rs.next()){
                out.println("Project ID: " + rs.getInt("projectID") + ", Project Name: " + rs.getString("name") + ", Total Material Cost: " + rs.getDouble("totalMaterialCost"));
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