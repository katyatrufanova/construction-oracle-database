CREATE OR REPLACE TYPE ProjectManagerType AS OBJECT
(
  managerID NUMBER,
  name VARCHAR2(50),
  surname VARCHAR2(50),
  DOB DATE
);
/
CREATE OR REPLACE TYPE MaterialType AS OBJECT
(
  materialID NUMBER,
  type VARCHAR2(50),
  strength NUMBER,
  durability NUMBER,
  cost NUMBER,
  recommendedApplications VARCHAR2(200)
);
/
CREATE OR REPLACE TYPE ArchitecturalDetailType AS OBJECT
(
  architecturalDetailID NUMBER,
  type VARCHAR2(50),
  description VARCHAR2(200)
);
/
CREATE OR REPLACE TYPE EngineeringSpecificationType AS OBJECT
(
  engineeringSpecificationID NUMBER,
  type VARCHAR2(50),
  description VARCHAR2(200)
);
/
CREATE OR REPLACE TYPE ProgressUpdateType AS OBJECT
(
  progressUpdateID NUMBER,
  type VARCHAR2(50),
  description VARCHAR2(200),
  timestamp DATE
);
/
CREATE OR REPLACE TYPE SafetyProtocolType AS OBJECT
(
  safetyProtocolID NUMBER,
  type VARCHAR2(50),
  description VARCHAR2(200)
);
/
CREATE OR REPLACE TYPE EnvironmentalConsiderationType AS OBJECT
(
  environmentalConsiderationID NUMBER,
  type VARCHAR2(50),
  description VARCHAR2(200)
);
/
CREATE OR REPLACE TYPE MilestoneType AS OBJECT
(
  milestoneID NUMBER,
  description VARCHAR2(200),
  timestamp DATE
);
/
CREATE OR REPLACE TYPE ChallengeType AS OBJECT
(
  challengeID NUMBER,
  description VARCHAR2(200),
  timestamp DATE
);
/
CREATE OR REPLACE TYPE MilestoneTypeList AS TABLE OF MilestoneType;
/
CREATE OR REPLACE TYPE ChallengeTypeList AS TABLE OF ChallengeType;
/
CREATE OR REPLACE TYPE ProjectType AS OBJECT
(
  projectID NUMBER,
  name VARCHAR2(50),
  type VARCHAR2(50),
  purpose VARCHAR2(200),
  location VARCHAR2(100),
  startDate DATE,
  expectedCompletionDate DATE,
  budget NUMBER,
  numberOfMilestones NUMBER,
  projectManager REF ProjectManagerType,
  milestones MilestoneTypeList,
  challenges ChallengeTypeList
);
/