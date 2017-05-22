base:
# this is called by packer
  'tsplk-packer':
    - tsplk-infra
    - terraform
    - salty-splunk
    - debugging-splunk
    - awscli

#  called by user_data/shell script
  'tsplk-master-bootstrap':
    - tsplk-master-config
    - tsplk-run
