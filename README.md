# Construction Project Management System

## Project Overview

The ConstructionMasters Project Management System is a database solution designed to manage and track construction projects across various sectors. This system is the result of a comprehensive development process, including thorough requirements analysis, conceptual and logical design, and physical implementation.

The project encompasses:

- Detailed requirements collection and analysis
- Conceptual design with skeleton and complete schemas
- Logical design including volume and operation analysis
- Physical design with custom types, tables, triggers, and procedures
- Query optimization for efficient data retrieval
- A web application interface for user interaction

This system provides robust functionality for project managers, architects, engineers, and stakeholders involved in residential, commercial, and industrial construction projects.

## Features

- Project Management: Store and manage detailed information about construction projects including name, purpose, location, start date, expected completion date, and budget.
- Material Tracking: Comprehensive database of construction materials with details on strength, durability, cost, and recommended applications.
- Architectural and Engineering Specifications: Store building designs, blueprints, floor plans, 3D models, structural designs, load-bearing capacities, and safety measures.
- Environmental Considerations: Track sustainable construction practices, energy-efficient designs, and green building materials.
- Progress Monitoring: Real-time tracking of project milestones and challenges.
- Safety Compliance: Maintain records of safety protocols and regulations to ensure industry standard compliance.

## Project Structure

```
constructionmasters/
│
├── docs/
│   └── project_report.pdf
│
├── sql/
│   ├── population_procedures.sql
│   ├── procedures.sql
│   ├── tables.sql
│   ├── triggers.sql
│   └── types.sql
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── constructionmasters/
│   │   │           ├── servlets/
│   │   │           │   ├── HighestCostServlet.java
│   │   │           │   ├── LowestMilestoneProjectServlet.java
│   │   │           │   ├── MaterialCostServlet.java
│   │   │           │   ├── ProjectChallengesServlet.java
│   │   │           │   ├── ProjectInfoServlet.java
│   │   │           │   └── ProjectServlet.java
│   │   │           ├── models/
│   │   │           │   ├── Project.java
│   │   │           │   ├── Material.java
│   │   │           │   └── ...
│   │   │           └── utils/
│   │   │               └── DatabaseConnection.java
│   │   ├── resources/
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── web.xml
│   └── test/
│       └── java/
│           └── com/
│               └── constructionmasters/
│
└── README.md
```

## Comprehensive Development Process

### 1. Requirements Collection and Analysis

The project began with a thorough analysis of requirements. This phase involved:

- Structuring of requirements
- Creation of a glossary of terms
- Identification of key entities and relationships

### 2. Conceptual Design

The conceptual design phase resulted in:

- A skeleton schema outlining primary entities
- A complete schema detailing all entities and relationships
- Documentation of business rules governing the system

![finalER](https://github.com/user-attachments/assets/0f820220-93df-4cec-a1f7-8b5edb1c0972)

### 3. Logical Design

The logical design phase included:

- Creation of volume tables to estimate data growth
- Analysis of operation frequency and complexity
- Development of access tables for each operation
- Redundancy analysis to optimize data storage

![logicalschema](https://github.com/user-attachments/assets/e4a51edd-9def-41d5-abcc-b152ecb963fe)

### 4. Physical Design

The physical implementation involved:

- Creation of custom types and tables
- Implementation of triggers for data integrity
- Development of procedures and functions for complex operations
- Query optimization techniques for efficient data retrieval

## Database Schema

The database schema includes carefully designed tables for:
- Projects
- Materials
- Architectural Details
- Engineering Specifications
- Safety Protocols
- Environmental Considerations
- Progress Updates

## Key Operations

1. Insert a new project (Weekly)
2. Print project information with milestones (Weekly)
3. Calculate and print total material cost for a specific project (Daily)
4. Print projects and their challenges, ordered by time (Bi-weekly)
5. Print projects ordered by highest material cost (Monthly)
6. Print architectural and engineering details for the project with the lowest number of milestones (Bi-monthly)

## Web Application

![srv](https://github.com/user-attachments/assets/ed0b3399-d737-48b6-9a54-715d0b131cf3)

The system is complemented by a web application interface, allowing users to interact with the database through the following servlets:

- HighestCostServlet: Handles requests for projects ordered by highest material cost
- LowestMilestoneProjectServlet: Retrieves details for the project with the lowest number of milestones
- MaterialCostServlet: Calculates and returns material costs for a specific project
- ProjectChallengesServlet: Retrieves project challenges ordered by time
- ProjectInfoServlet: Provides detailed project information including milestones
- ProjectServlet: Handles insertion of new projects

## Documentation

For a more detailed explanation of the design process, including conceptual and logical schemas, please refer to the [Documentation](docs/project_report.pdf).
