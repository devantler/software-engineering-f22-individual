# software-engineering-f22

This repo contains everything from our main repository, which is related to the semester project. As I am the owner of the original repository I can't fork it (You can only fork a repository to another account than the original owner). As such this repository is not a fork of the original repository, but a copy of it.

## List of Changes

### General Grammar

- Added system initialization so the system has a name
- Changed Model to have a Configuration instead of multiple configurations
- Changed Configuration to have a list of services and devices
- Added title separators for configuration, logic, unit tests and Uppaal queries.

### Services Grammar

- Added Service grammar rule
  - Added Mqtt grammar rule
  - Added Database grammar rule
  - Added Address grammar rule
- Changed Device grammar rule to include 'create' keyword
- Added enum SERVICE_NAME to specify supported services.

### Unit Tests Grammar

- Added UnitTest grammar rule
  - Added HealthCheckUnitTest
  - Added ConnectionUnitTest
  - Added DeviceInitializationUnitTest
  - Added RunWithoutFailureUnitTest

### UPPAAL Queries Grammar

- Added UppaalQuery grammar rule
  - Added AllPathsUppaalQuery
  - Added OnePathUppaalQuery
  - Added LeadsToUppaalQuery
- Added Expression grammar rule with left-factoring
  - Added AddOrExpression
  - Added ImplyExpression
  - Added ValueExpression
  - Added DeviceState

### C# Code generation

- Code generated project title from system name for Orchestrator
- Moved all csharp code generation files to `xtext.factoryLang.generator.csharp`
- Changed code generation of C# src project so the program is testable.
- Code-Generated solution file
- Added code generation to generate a C# test project.
  - Code generated Unit Tests.
    - Implemented HealthCheckUnitTest
    - Implemented ConnectionUnitTest
    - Implemented DeviceInitializationUnitTest
    - Implemented RunWithoutFailureUnitTest
- Code-Generated Dockerfile that includes src and test projects.

### UPPAAL Code Generation

- Moved all UPPAAL code generation files to `xtext.factoryLang.generator.uppaal`
- Code generated system folder name from system name for UPPAAL Project