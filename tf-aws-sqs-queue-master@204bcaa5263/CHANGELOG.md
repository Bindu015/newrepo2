# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.2] - 2022-10-12
### Added
- Updated action to be configurable in resource policy since some application need to more actions.

## [0.2.1] - 2022-08-31
### Added
- Allow SQS to use same key arn as SNS

## [0.2.0] - 2022-08-18
### Added
- Support Multiple principle arns provided by user for policies 

## [0.1.9] - 2022-08-03
### Changed
- Implemented tags based on new tagging strategy.

## [0.1.8] - 2022-07-28
### Changed
- Change to >= 3.0

## [0.1.7] - 2022-07-25
### Changed
- Upgrade AWS/TF version to 4.0

## [0.1.6] - 2022-06-29
### Changed
- Update tags to allow custom tag merging

## [0.1.5] - 2022-06-13
### Added
- Added new deadletter queue and associated policies around them
- Added policy to force HTTPS for SendMessage

## [0.1.3] - 2022-03-13
### Added
- Added new required tags application_id and application_name.
- Added a README file.
- Added a CHANGELOG file.
### Changed
- Jenkinsfile now uses production pipeline.
