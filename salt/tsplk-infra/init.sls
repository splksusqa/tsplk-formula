include:
  - git

# sync tf file
{% set version = salt['pillar.get']('tsplk:tsplk-infra:version', 'master') %}
tsplk-infra:
  git.latest:
    - name: https://github.com/beelit94/tsplk-infra.git
    - target: /srv/tsplk-infra
    - branch: {{ version }}
    - rev: {{ version }}
    - force_clone: True
    - force_reset: True
    - require:
      - sls: git

# init
