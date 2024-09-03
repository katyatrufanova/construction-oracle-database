CREATE TABLE ProjectManager of ProjectManagerType
(
  managerID PRIMARY KEY,
  name NOT NULL,
  surname NOT NULL,
  DOB NOT NULL
);
/
CREATE TABLE Material of MaterialType
(
  materialID PRIMARY KEY,
  type NOT NULL,
  cost NOT NULL
);
/
CREATE TABLE ArchitecturalDetail of ArchitecturalDetailType
(
  architecturalDetailID PRIMARY KEY,
  type NOT NULL
);
/
CREATE TABLE EngineeringSpecification of EngineeringSpecificationType
(
  engineeringSpecificationID PRIMARY KEY,
  type NOT NULL
);
/
CREATE TABLE SafetyProtocol of SafetyProtocolType
(
  safetyProtocolID PRIMARY KEY,
  type NOT NULL
);
/
CREATE TABLE EnvironmentalConsideration of EnvironmentalConsiderationType
(
  environmentalConsiderationID PRIMARY KEY,
  type NOT NULL
);
/
CREATE TABLE ProgressUpdate of ProgressUpdateType
(
  progressUpdateID PRIMARY KEY,
  type NOT NULL,
  timestamp NOT NULL
);
/
CREATE TABLE Project of ProjectType
  (PRIMARY KEY (projectID))
NESTED TABLE milestones STORE AS milestone_nested_table,
NESTED TABLE challenges STORE AS challenge_nested_table;
/

-- Junction Tables --
CREATE TABLE ProjectMaterial 
(
  projectID NUMBER,
  materialID NUMBER,
  CONSTRAINT project_material_pk PRIMARY KEY (projectID, materialID),
  CONSTRAINT project_material_project_fk FOREIGN KEY (projectID) REFERENCES Project(projectID),
  CONSTRAINT project_material_material_fk FOREIGN KEY (materialID) REFERENCES Material(materialID)
);
/

CREATE TABLE ProjectArchitecturalDetail 
(
  projectID NUMBER,
  architecturalDetailID NUMBER,
  CONSTRAINT project_architecturalDetail_pk PRIMARY KEY (projectID, architecturalDetailID),
  CONSTRAINT project_architecturalDetail_project_fk FOREIGN KEY (projectID) REFERENCES Project(projectID),
  CONSTRAINT project_architecturalDetail_detail_fk FOREIGN KEY (architecturalDetailID) REFERENCES ArchitecturalDetail(architecturalDetailID)
);
/

CREATE TABLE ProjectEngineeringSpecification 
(
  projectID NUMBER,
  engineeringSpecificationID NUMBER,
  CONSTRAINT project_engineeringSpecification_pk PRIMARY KEY (projectID, engineeringSpecificationID),
  CONSTRAINT project_engineeringSpecification_project_fk FOREIGN KEY (projectID) REFERENCES Project(projectID),
  CONSTRAINT project_engineeringSpecification_specification_fk FOREIGN KEY (engineeringSpecificationID) REFERENCES EngineeringSpecification(engineeringSpecificationID)
);
/

CREATE TABLE ProjectSafetyProtocol 
(
  projectID NUMBER,
  safetyProtocolID NUMBER,
  CONSTRAINT project_safetyProtocol_pk PRIMARY KEY (projectID, safetyProtocolID),
  CONSTRAINT project_safetyProtocol_project_fk FOREIGN KEY (projectID) REFERENCES Project(projectID),
  CONSTRAINT project_safetyProtocol_protocol_fk FOREIGN KEY (safetyProtocolID) REFERENCES SafetyProtocol(safetyProtocolID)
);
/

CREATE TABLE ProjectEnvironmentalConsideration 
(
  projectID NUMBER,
  environmentalConsiderationID NUMBER,
  CONSTRAINT project_environmentalConsideration_pk PRIMARY KEY (projectID, environmentalConsiderationID),
  CONSTRAINT project_environmentalConsideration_project_fk FOREIGN KEY (projectID) REFERENCES Project(projectID),
  CONSTRAINT project_environmentalConsideration_consideration_fk FOREIGN KEY (environmentalConsiderationID) REFERENCES EnvironmentalConsideration(environmentalConsiderationID)
);
/

CREATE TABLE ProjectProgressUpdate 
(
  projectID NUMBER,
  progressUpdateID NUMBER,
  CONSTRAINT project_progressUpdate_pk PRIMARY KEY (projectID, progressUpdateID),
  CONSTRAINT project_progressUpdate_project_fk FOREIGN KEY (projectID) REFERENCES Project(projectID),
  CONSTRAINT project_progressUpdate_update_fk FOREIGN KEY (progressUpdateID) REFERENCES ProgressUpdate(progressUpdateID)
);
/

-- MATERIALIZED VIEW --
CREATE MATERIALIZED VIEW mv_project_challenges AS 
SELECT p.projectID, p.name, c.description, c.timestamp
FROM Project p, TABLE(p.challenges) c;



GRANT SELECT, INSERT ON Project to ConstructionMasters;
GRANT SELECT ON Material to ConstructionMasters;
GRANT SELECT ON mv_project_challenges to ConstructionMasters;
GRANT SELECT ON ProjectMaterial to ConstructionMasters;