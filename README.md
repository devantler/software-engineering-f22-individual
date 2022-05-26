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
- Changed Device grammar rule to include 'create' key word
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
- Extended Configuration to accept defining services.
