include:
  - git

# sync tf file
tsplk-infra:
  git.latest:
    - name: https://github.com/beelit94/tsplk-infra.git
    - target: /srv/tsplk-infra
    - branch: {{ salt['pillar.get']('tsplk:tsplk-infra:version', 'master') }}
    - force_clone: True
    - require:
      - sls: git