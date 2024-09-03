CREATE OR REPLACE PROCEDURE populate_ProjectManager AS
BEGIN
  INSERT INTO ProjectManager(managerID, name, surname, DOB) 
  VALUES (1, 'John', 'Doe', TO_DATE('1980/01/01', 'yyyy/mm/dd'));
  INSERT INTO ProjectManager(managerID, name, surname, DOB) 
  VALUES (2, 'Jane', 'Smith', TO_DATE('1985/02/01', 'yyyy/mm/dd'));
  INSERT INTO ProjectManager(managerID, name, surname, DOB) 
  VALUES (3, 'Robert', 'Johnson', TO_DATE('1975/03/01', 'yyyy/mm/dd'));
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE populate_Material AS
BEGIN
FOR i IN 1..100 LOOP
INSERT INTO Material(materialID, type, strength, durability, cost, recommendedApplications)
VALUES (i, DBMS_RANDOM.STRING('A', 20), DBMS_RANDOM.VALUE(50, 150), DBMS_RANDOM.VALUE(50, 150), DBMS_RANDOM.VALUE(10, 500), DBMS_RANDOM.STRING('A', 50));
END LOOP;
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE populate_ArchitecturalDetail AS
BEGIN
  INSERT INTO ArchitecturalDetail(architecturalDetailID, type, description) 
  VALUES (1, 'floor plan', 'Pointed arches, ribbed vault, flying buttress');
  INSERT INTO ArchitecturalDetail(architecturalDetailID, type, description) 
  VALUES (2, '3D model', 'Archways, thick walls, large towers');
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE populate_EngineeringSpecification AS
BEGIN
  INSERT INTO EngineeringSpecification(engineeringSpecificationID, type, description) 
  VALUES (1, 'structural design', 'Must withstand wind speeds up to 120 mph');
  INSERT INTO EngineeringSpecification(engineeringSpecificationID, type, description) 
  VALUES (2, 'load-bearing capacity', 'Must include three-phase power supply');
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE populate_SafetyProtocol AS
BEGIN
  INSERT INTO SafetyProtocol(safetyProtocolID, type, description) 
  VALUES (1, 'standard', 'Fire extinguishers and alarms must be installed');
  INSERT INTO SafetyProtocol(safetyProtocolID, type, description) 
  VALUES (2, 'requirement', 'All workers must use harnesses when working at height');
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE populate_EnvironmentalConsideration AS
BEGIN
  INSERT INTO EnvironmentalConsideration(environmentalConsiderationID, type, description) 
  VALUES (1, 'design', 'All waste must be properly disposed of');
  INSERT INTO EnvironmentalConsideration(environmentalConsiderationID, type, description) 
  VALUES (2, 'green material', 'Building must be designed to minimize energy usage');
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE populate_ProgressUpdate AS
BEGIN
  INSERT INTO ProgressUpdate(progressUpdateID, type, description, timestamp) 
  VALUES (1, 'Construction', 'Foundation has been completed', TO_DATE('2023/01/01', 'yyyy/mm/dd'));
  INSERT INTO ProgressUpdate(progressUpdateID, type, description, timestamp) 
  VALUES (2, 'Planning', 'Architectural plans have been submitted', TO_DATE('2022/12/01', 'yyyy/mm/dd'));
  COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE populate_Project AS
  v_milestones MilestoneTypeList;
  v_challenges ChallengeTypeList;
  v_startdate DATE;
  v_enddate DATE;
  v_random INT;
BEGIN
  FOR i IN 1..1000 LOOP
    v_milestones := MilestoneTypeList();
    v_challenges := ChallengeTypeList();
    v_startdate := SYSDATE + DBMS_RANDOM.VALUE(1, 365);
    v_enddate := v_startdate + DBMS_RANDOM.VALUE(1, 365);
    v_random := DBMS_RANDOM.VALUE(1, 4);

    FOR j IN 1..v_random LOOP
      v_milestones.EXTEND;
      v_milestones(j) := MilestoneType(j, DBMS_RANDOM.STRING('A', 50), v_startdate + DBMS_RANDOM.VALUE(1, 365));
    END LOOP;

    FOR j IN 1..v_random LOOP
      v_challenges.EXTEND;
      v_challenges(j) := ChallengeType(j, DBMS_RANDOM.STRING('A', 50), v_startdate + DBMS_RANDOM.VALUE(1, 365));
    END LOOP;

    INSERT INTO Project(projectID, name, type, purpose, location, startDate, expectedCompletionDate, budget, numberOfMilestones, milestones, challenges) 
    VALUES (i, DBMS_RANDOM.STRING('A', 20), 'residential', DBMS_RANDOM.STRING('A', 50), DBMS_RANDOM.STRING('A', 50), v_startdate, v_enddate, 9999999999, v_random, v_milestones, v_challenges);
  END LOOP;
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE populate_ProjectMaterial AS
  v_random INT;
  v_material INT;
  type MaterialSet is table of INT index by PLS_INTEGER;
  v_materials MaterialSet;
BEGIN
  FOR i IN 1..1000 LOOP
    v_random := TRUNC(DBMS_RANDOM.VALUE(1, 6));  

    v_materials.DELETE;  -- Clear the set at the start of each iteration

    FOR j IN 1..v_random LOOP
      LOOP
        v_material := TRUNC(DBMS_RANDOM.VALUE(1, 101));  

        EXIT WHEN v_materials.EXISTS(v_material) = FALSE;  
      END LOOP;

      v_materials(v_material) := v_material;  

      INSERT INTO ProjectMaterial(projectID, materialID) VALUES (i, v_material);  
    END LOOP;
  END LOOP;
  
  COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE populate_ProjectArchitecturalDetail AS
BEGIN
  INSERT INTO ProjectArchitecturalDetail(projectID, architecturalDetailID) VALUES (1, 1);
  INSERT INTO ProjectArchitecturalDetail(projectID, architecturalDetailID) VALUES (2, 1);
  INSERT INTO ProjectArchitecturalDetail(projectID, architecturalDetailID) VALUES (3, 2);
  COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE populate_ProjectEngineeringSpecification AS
BEGIN
  INSERT INTO ProjectEngineeringSpecification(projectID, engineeringSpecificationID) VALUES (1, 1);
  INSERT INTO ProjectEngineeringSpecification(projectID, engineeringSpecificationID) VALUES (2, 1);
  INSERT INTO ProjectEngineeringSpecification(projectID, engineeringSpecificationID) VALUES (3, 2);
  COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE populate_ProjectSafetyProtocol AS
BEGIN
  INSERT INTO ProjectSafetyProtocol(projectID, safetyProtocolID) VALUES (1, 1);
  INSERT INTO ProjectSafetyProtocol(projectID, safetyProtocolID) VALUES (2, 2);
  INSERT INTO ProjectSafetyProtocol(projectID, safetyProtocolID) VALUES (3, 1);
  COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE populate_ProjectEnvironmentalConsideration AS
BEGIN
  INSERT INTO ProjectEnvironmentalConsideration(projectID, environmentalConsiderationID) VALUES (1, 1);
  INSERT INTO ProjectEnvironmentalConsideration(projectID, environmentalConsiderationID) VALUES (2, 1);
  INSERT INTO ProjectEnvironmentalConsideration(projectID, environmentalConsiderationID) VALUES (3, 1);
  COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE populate_ProjectProgressUpdate AS
BEGIN
  INSERT INTO ProjectProgressUpdate(projectID, progressUpdateID) VALUES (1, 1);
  INSERT INTO ProjectProgressUpdate(projectID, progressUpdateID) VALUES (2, 2);
  COMMIT;
END;
/