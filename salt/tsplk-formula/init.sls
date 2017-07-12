include:
  - git

# sync tf file
{% set version = salt['pillar.get']('tsplk:tsplk-formula:version', 'master') %}
tsplk-formula:
  git.latest:
    - name: https://github.com/splksusqa/tsplk-formula
    - target: /srv/tsplk-formula
    - branch: {{ version }}
    - rev: {{ version }}
    - force_reset: True
    - force_clone: True
    - require:
      - sls: git
