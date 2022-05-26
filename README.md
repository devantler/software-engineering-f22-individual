# software-engineering-f22

This repo contains everything from our main repository, which is related to the semester project. As I am the owner of the original repository I can't fork it (You can only fork a repository to another account than the original owner). As such this repository is not a fork of the original repository, but a copy of it.

## List of Changes

- Added system initialization so the system has a name
- Changed Model to have a Configuration instead of multiple
- Changed Configuration to have a list of services and devices
- Added Service grammar rule
  - Added Mqtt grammar rule
  - Added Database grammar rule
  - Added Address grammar rule
- Changed Device grammar rule to include 'create' keyword
- Added UnitTest grammar rule
  - Added HealthCheckUnitTest
  - Added DeviceInitializationUnitTest
  - Added RunWithoutFailureUnitTest
- Added UppaalQuery grammar rule
  - Added AllPathsUppaalQuery
  - Added OnePathUppaalQuery
  - Added LeadsToUppaalQuery
- Added Expression grammar rule with left-factoring
  - Added AddOrExpression
  - Added ImplyExpression
  - Added ValueExpression
  - Added DeviceState
- Added enum SERVICE_NAME to specify supported services.
- Added title separators for configuration, logic, unit tests and Uppaal queries.
- Code generated project title from system name for Orchestrator
- Code generated system folder name from system name for UPPAAL Project
- Moved all csharp code generation files to `xtext.factoryLang.generator.csharp`
- Moved all UPPAAL code generation files to `xtext.factoryLang.generator.uppaal`
- Added code generation to generate a csharp test project.
  - Code generated Unit Tests.
  - Made changes to Dockerfiles to include Unit Tests.
