include:
  - git

# sync salt code
salty-splunk:
  file.managed:
    - name: /tmp/salty-splunk-key
    - source: salt://salty-splunk-key
    - mode: 600
  git.latest:
    - name: git@bitbucket.org:splunksusqa/salt-mirror.git
    - target: /srv/salty-splunk
    - rev: {{ salt['pillar.get']('tsplk:salty-splunk:version', 'master') }}
    - identity: /tmp/salty-splunk-key
    - force_clone: True
    - require:
      - sls: git