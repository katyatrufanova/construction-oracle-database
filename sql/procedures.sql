-- Operation 1: Insert a new project
CREATE OR REPLACE PROCEDURE insert_new_project(
  p_projectID NUMBER,
  p_name VARCHAR2,
  p_type VARCHAR2,
  p_purpose VARCHAR2,
  p_location VARCHAR2,
  p_startDate DATE,
  p_expectedCompletionDate DATE,
  p_budget NUMBER,
  p_numberOfMilestones NUMBER,
  p_managerID NUMBER
) IS 
BEGIN
  INSERT INTO Project 
  VALUES (
    ProjectType(
      p_projectID, 
      p_name, 
      p_type, 
      p_purpose, 
      p_location, 
      p_startDate, 
      p_expectedCompletionDate, 
      p_budget, 
      p_numberOfMilestones, 
      (SELECT REF(p) FROM ProjectManager p WHERE managerID = p_managerID), 
      MilestoneTypeList(),
      ChallengeTypeList())
  );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END insert_new_project;
/

-- Operation 2: Print information about a specific project and all of its milestones
CREATE OR REPLACE PROCEDURE print_project_and_milestones (p_projectID IN NUMBER)
IS 
  CURSOR c_projects IS
    SELECT p.projectID, p.name, m.description 
    FROM Project p, TABLE(p.milestones) m 
    WHERE p.projectID = p_projectID;
  v_project c_projects%ROWTYPE;
BEGIN
  OPEN c_projects;
  LOOP
    FETCH c_projects INTO v_project;
    EXIT WHEN c_projects%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Project ID: ' || v_project.projectID || ', Project Name: ' || v_project.name || ', Milestone Description: ' || v_project.description);
  END LOOP;
  CLOSE c_projects;
END print_project_and_milestones;
/

-- Operation 3: Print the total cost of construction materials for a specific project
CREATE OR REPLACE PROCEDURE print_total_material_cost (p_projectID IN NUMBER)
IS 
  v_totalMaterialCost NUMBER;
BEGIN
  SELECT SUM(m.cost) INTO v_totalMaterialCost
  FROM Project p
  JOIN ProjectMaterial pm ON p.projectID = pm.projectID
  JOIN Material m ON pm.materialID = m.materialID
  WHERE p.projectID = p_projectID;
  DBMS_OUTPUT.PUT_LINE('Project ID: ' || p_projectID || ', Total Material Cost: ' || v_totalMaterialCost);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No data found for project ID: ' || p_projectID);
END print_total_material_cost;
/

-- Operation 4: Print all of the projects and the descriptions of the challenges
CREATE OR REPLACE PROCEDURE print_projects_and_challenges_mv
IS 
  CURSOR c_challenges IS
    SELECT projectID, name, description
    FROM mv_project_challenges
    ORDER BY timestamp;
  v_challenge c_challenges%ROWTYPE;
BEGIN
  OPEN c_challenges;
  LOOP
    FETCH c_challenges INTO v_challenge;
    EXIT WHEN c_challenges%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Project ID: ' || v_challenge.projectID || ', Project Name: ' || v_challenge.name || ', Challenge Description: ' || v_challenge.description);
  END LOOP;
  CLOSE c_challenges;
END print_projects_and_challenges_mv;
/

-- Operation 5: Print all of the projects ordered by the highest total cost of construction materials used
CREATE OR REPLACE PROCEDURE print_projects_by_material_cost
IS 
  CURSOR c_projects IS
    SELECT p.projectID, p.name, SUM(m.cost) as totalMaterialCost
    FROM Project p
    JOIN ProjectMaterial pm ON p.projectID = pm.projectID
    JOIN Material m ON pm.materialID = m.materialID
    GROUP BY p.projectID, p.name
    ORDER BY totalMaterialCost DESC;
  v_project c_projects%ROWTYPE;
BEGIN
  OPEN c_projects;
  LOOP
    FETCH c_projects INTO v_project;
    EXIT WHEN c_projects%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Project ID: ' || v_project.projectID || ', Project Name: ' || v_project.name || ', Total Material Cost: ' || v_project.totalMaterialCost);
  END LOOP;
  CLOSE c_projects;
END print_projects_by_material_cost;
/

-- Operation 6: Print the architectural and engineering details and the progress updates of the project with the lowest number of milestones
CREATE OR REPLACE PROCEDURE print_lowest_milestone_project_details
IS 
  v_projectID NUMBER;
  CURSOR c_architecturalDetails IS
    SELECT ad.type, ad.description
    FROM ProjectArchitecturalDetail pad
    JOIN ArchitecturalDetail ad ON pad.architecturalDetailID = ad.architecturalDetailID
    WHERE pad.projectID = v_projectID;
  v_architecturalDetail c_architecturalDetails%ROWTYPE;
  CURSOR c_engineeringSpecifications IS
    SELECT es.type, es.description
    FROM ProjectEngineeringSpecification pes
    JOIN EngineeringSpecification es ON pes.engineeringSpecificationID = es.engineeringSpecificationID
    WHERE pes.projectID = v_projectID;
  v_engineeringSpecification c_engineeringSpecifications%ROWTYPE;
  CURSOR c_progressUpdates IS
    SELECT pu.type, pu.description, pu.timestamp
    FROM ProjectProgressUpdate ppu
    JOIN ProgressUpdate pu ON ppu.progressUpdateID = pu.progressUpdateID
    WHERE ppu.projectID = v_projectID;
  v_progressUpdate c_progressUpdates%ROWTYPE;
BEGIN
  -- find the project with the lowest number of milestones
  SELECT p.projectID INTO v_projectID
  FROM Project p
  ORDER BY p.numberOfMilestones ASC
  FETCH FIRST ROW ONLY;
  
  -- print architectural details for this project
  OPEN c_architecturalDetails;
  LOOP
    FETCH c_architecturalDetails INTO v_architecturalDetail;
    EXIT WHEN c_architecturalDetails%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Architectural Detail Type: ' || v_architecturalDetail.type || ', Description: ' || v_architecturalDetail.description);
  END LOOP;
  CLOSE c_architecturalDetails;

  -- print engineering specifications for this project
  OPEN c_engineeringSpecifications;
  LOOP
    FETCH c_engineeringSpecifications INTO v_engineeringSpecification;
    EXIT WHEN c_engineeringSpecifications%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Engineering Specification Type: ' || v_engineeringSpecification.type || ', Description: ' || v_engineeringSpecification.description);
  END LOOP;
  CLOSE c_engineeringSpecifications;
  
  -- print progress updates for this project
  OPEN c_progressUpdates;
  LOOP
    FETCH c_progressUpdates INTO v_progressUpdate;
    EXIT WHEN c_progressUpdates%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Progress Update Type: ' || v_progressUpdate.type || ', Description: ' || v_progressUpdate.description || ', Timestamp: ' || v_progressUpdate.timestamp);
  END LOOP;
  CLOSE c_progressUpdates;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No project found with the lowest number of milestones.');
END print_lowest_milestone_project_details;
/