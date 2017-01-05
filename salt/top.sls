base:
  'salt-dev':
    - docker
    - testinfra

  'tsplk-saltmaster':
    - tsplk
    - terraform
    - salty-splunk
