include:
  - python-pip

awscli:
  pip.installed:
    - require:
      - sls: python-pip