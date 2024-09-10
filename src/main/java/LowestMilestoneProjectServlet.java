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

public class LowestMilestoneProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = "jdbc:oracle:thin:@localhost:1521/orcl";
        String user = "system"; 
        String password = "oracle"; 

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, user, password);

            String sqlProjectId = "SELECT p.projectID FROM Project p ORDER BY p.numberOfMilestones ASC FETCH FIRST ROW ONLY";
            PreparedStatement stmtProjectId = conn.prepareStatement(sqlProjectId);
            ResultSet rsProjectId = stmtProjectId.executeQuery();
            
            if (!rsProjectId.next()){
                PrintWriter out = response.getWriter();
                out.println("No project found with the lowest number of milestones.");
                return;
            }

            int projectId = rsProjectId.getInt("projectID");

            // Architectural details
            String sqlArchitecturalDetails = "SELECT ad.type, ad.description FROM ProjectArchitecturalDetail pad JOIN ArchitecturalDetail ad ON pad.architecturalDetailID = ad.architecturalDetailID WHERE pad.projectID = ?";
            PreparedStatement stmtArchitecturalDetails = conn.prepareStatement(sqlArchitecturalDetails);
            stmtArchitecturalDetails.setInt(1, projectId);
            ResultSet rsArchitecturalDetails = stmtArchitecturalDetails.executeQuery();

            // Engineering specifications
            String sqlEngineeringSpecifications = "SELECT es.type, es.description FROM ProjectEngineeringSpecification pes JOIN EngineeringSpecification es ON pes.engineeringSpecificationID = es.engineeringSpecificationID WHERE pes.projectID = ?";
            PreparedStatement stmtEngineeringSpecifications = conn.prepareStatement(sqlEngineeringSpecifications);
            stmtEngineeringSpecifications.setInt(1, projectId);
            ResultSet rsEngineeringSpecifications = stmtEngineeringSpecifications.executeQuery();

            // Progress updates
            String sqlProgressUpdates = "SELECT pu.type, pu.description, pu.timestamp FROM ProjectProgressUpdate ppu JOIN ProgressUpdate pu ON ppu.progressUpdateID = pu.progressUpdateID WHERE ppu.projectID = ?";
            PreparedStatement stmtProgressUpdates = conn.prepareStatement(sqlProgressUpdates);
            stmtProgressUpdates.setInt(1, projectId);
            ResultSet rsProgressUpdates = stmtProgressUpdates.executeQuery();

            PrintWriter out = response.getWriter();
            out.println("Project ID: " + projectId);

            while(rsArchitecturalDetails.next()){
                out.println("Architectural Detail Type: " + rsArchitecturalDetails.getString("type") + ", Description: " + rsArchitecturalDetails.getString("description"));
            }

            while(rsEngineeringSpecifications.next()){
                out.println("Engineering Specification Type: " + rsEngineeringSpecifications.getString("type") + ", Description: " + rsEngineeringSpecifications.getString("description"));
            }

            while(rsProgressUpdates.next()){
                out.println("Progress Update Type: " + rsProgressUpdates.getString("type") + ", Description: " + rsProgressUpdates.getString("description") + ", Timestamp: " + rsProgressUpdates.getDate("timestamp"));
            }

            rsProjectId.close();
            rsArchitecturalDetails.close();
            rsEngineeringSpecifications.close();
            rsProgressUpdates.close();
            stmtProjectId.close();
            stmtArchitecturalDetails.close();
            stmtEngineeringSpecifications.close();
            stmtProgressUpdates.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
        }
    }
}