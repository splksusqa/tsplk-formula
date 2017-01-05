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

# Make sure this state only executed by salt-call
salt-master-conf:
  file.managed:
    - name: /etc/salt/master
    - source: salt://tsplk/master_config.yml
    - require:
      - git: salty-splunk

restart-salt-master:
  service.running:
    - name: salt-master
    - enable: True
    - watch:
      - file: salt-master-conf