include:
  - git

# sync tf file
tsplk-infra:
  git.latest:
    - name: https://github.com/splksusqa/tsplk-formula
    - target: /srv/tsplk-formula
    - branch: {{ salt['pillar.get']('tsplk:tsplk-formula:version', 'master') }}
    - force_clone: True
    - require:
      - sls: git