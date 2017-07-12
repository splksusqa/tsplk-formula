include:
  - git

# sync tf file
tsplk-formula:
  git.latest:
    - name: https://github.com/splksusqa/tsplk-formula
    - target: /srv/tsplk-formula
    - rev: {{ salt['pillar.get']('tsplk:tsplk-formula:version', 'master') }}
    - force_clone: True
    - require:
      - sls: git