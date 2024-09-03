--BR: The ‘Type’ attribute of the ‘Project’ entity must be ‘residential’, ‘commercial’ or ‘industrial’.
CREATE OR REPLACE TRIGGER project_type_check
BEFORE INSERT OR UPDATE ON Project
FOR EACH ROW
BEGIN
  IF :new.type NOT IN ('residential', 'commercial', 'industrial') THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid project type. Type must be residential, commercial or industrial.');
  END IF;
END;
/


--BR: A new 'Project Manager' can be inserted if their DOB indicates they are 18 years old or older.
CREATE OR REPLACE TRIGGER ProjectManagerDOBCheck
BEFORE INSERT ON ProjectManager
FOR EACH ROW
DECLARE
  v_years NUMBER;
BEGIN
  SELECT (SYSDATE - :NEW.DOB) / 365 INTO v_years FROM dual;
  IF v_years < 18 THEN
    RAISE_APPLICATION_ERROR(-20003, 'A project manager must be 18 years old or older.');
  END IF;
END;
/

--BR: The ‘Type’ attribute of the ‘Architectural Detail’ entity must be ‘building design, ‘blueprint’, ‘floor plan’, or ‘3D model’
CREATE OR REPLACE TRIGGER architectural_detail_type_check
BEFORE INSERT OR UPDATE ON ArchitecturalDetail
FOR EACH ROW
BEGIN
  IF :new.type NOT IN ('building design', 'blueprint', 'floor plan', '3D model') THEN
    RAISE_APPLICATION_ERROR(-20004, 'Invalid architectural detail type. Type must be building design, blueprint, floor plan, or 3D model.');
  END IF;
END;
/

--BR: The ‘Type’ attribute of the ‘Engineering Specification’ entity must be ‘structural design, ‘load-bearing capacity’, or ‘safety measure’
CREATE OR REPLACE TRIGGER engineering_specification_type_check
BEFORE INSERT OR UPDATE ON EngineeringSpecification
FOR EACH ROW
BEGIN
  IF :new.type NOT IN ('structural design', 'load-bearing capacity', 'safety measure') THEN
    RAISE_APPLICATION_ERROR(-20005, 'Invalid engineering specification type. Type must be structural design, load-bearing capacity, or safety measure.');
  END IF;
END;
/

--BR: The ‘Type’ attribute of the ‘Safety Protocol’ entity must be ‘standard’ or ‘requirement’
CREATE OR REPLACE TRIGGER safety_protocol_type_check
BEFORE INSERT OR UPDATE ON SafetyProtocol
FOR EACH ROW
BEGIN
  IF :new.type NOT IN ('standard', 'requirement') THEN
    RAISE_APPLICATION_ERROR(-20006, 'Invalid safety protocol type. Type must be standard or requirement.');
  END IF;
END;
/

--BR: The ‘Type’ attribute of the ‘Environmental Consideration’ entity must be ‘construction practice’, ‘design’, or ‘green material’
CREATE OR REPLACE TRIGGER environmental_consideration_type_check
BEFORE INSERT OR UPDATE ON EnvironmentalConsideration
FOR EACH ROW
BEGIN
  IF :new.type NOT IN ('construction practice', 'design', 'green material') THEN
    RAISE_APPLICATION_ERROR(-20007, 'Invalid environmental consideration type. Type must be construction practice, design, or green material.');
  END IF;
END;
/

--BR: A project's expected completion date must always be after the start date.
CREATE OR REPLACE TRIGGER project_date_check
BEFORE INSERT OR UPDATE ON Project
FOR EACH ROW
BEGIN
  IF :new.startDate >= :new.expectedCompletionDate THEN
    RAISE_APPLICATION_ERROR(-20008, 'Expected completion date must be after the start date.');
  END IF;
END;
/

--BR: The total cost of materials for a project cannot exceed the budget of the project.
CREATE OR REPLACE TRIGGER project_material_cost_check
FOR INSERT OR UPDATE ON ProjectMaterial
COMPOUND TRIGGER

  -- Define an array type to hold the project IDs
  TYPE t_projectIDs IS TABLE OF ProjectMaterial.projectID%TYPE;
  -- Define a variable of the new type
  v_projectIDs t_projectIDs := t_projectIDs();

AFTER EACH ROW IS
BEGIN
  -- Capture affected project IDs during row-level events
  v_projectIDs.EXTEND;
  v_projectIDs(v_projectIDs.COUNT) := :NEW.projectID;
END AFTER EACH ROW;

AFTER STATEMENT IS
  v_totalMaterialCost NUMBER;
  v_projectBudget NUMBER;
BEGIN
  -- Loop over each affected project
  FOR i IN 1..v_projectIDs.COUNT LOOP
    -- Calculate total material cost and project budget for each affected project
    SELECT SUM(m.cost) INTO v_totalMaterialCost
    FROM Material m
    JOIN ProjectMaterial pm ON m.materialID = pm.materialID
    WHERE pm.projectID = v_projectIDs(i);

    SELECT budget INTO v_projectBudget
    FROM Project
    WHERE projectID = v_projectIDs(i);

    -- Check if total cost of materials exceeds the budget
    IF v_totalMaterialCost > v_projectBudget THEN
      RAISE_APPLICATION_ERROR(-20009, 'Total cost of materials for a project cannot exceed the project budget.');
    END IF;
  END LOOP;
END AFTER STATEMENT;
END project_material_cost_check;
/