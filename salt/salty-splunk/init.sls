include:
  - git

# sync salt code
salty-splunk:
  file.managed:
    - name: {{ salt['pillar.get']('tsplk:salty-splunk:key-path', '/home/ubuntu/salty-splunk-key') }}
    - mode: 600
  git.latest:
    - name: git@bitbucket.org:splunksusqa/salt-mirror.git
    - target: /srv/salty-splunk
    - rev: {{ salt['pillar.get']('tsplk:salty-splunk:version', 'master') }}
    - identity: {{ salt['pillar.get']('tsplk:salty-splunk:key-path', '/home/ubuntu/salty-splunk-key') }}
    - force_clone: True
    - require:
      - sls: git
