base:
  'salt-dev':
    - docker
    - testinfra

# this is called by packer
  'tsplk-packer':
    - tsplk-infra
    - terraform
    - salty-splunk
    - debugging-splunk

#  called by user_data/shell script
  'tsplk-master-bootstrap':
    - tsplk-master-config

# config s3 pillar data, spin up minions,
# called by master and minion itself
  'tsplk-master':
    - tsplk-infra
    - salty-splunk
    - tsplk-run
