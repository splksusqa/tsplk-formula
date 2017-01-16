# Make sure this state only executed by salt-call
# use template here
salt-master-conf:
  file.managed:
    - name: /etc/salt/master
    - source: salt://tsplk-master-config/master_config.yml
    - template: jinja
    - context:
        user: {{ salt['pillar.get']('tsplk:user', 'tu') }}
        project: {{ salt['pillar.get']('tsplk:project', 'tp') }}

restart-salt-master:
  service.running:
    - name: salt-master
    - enable: True
    - watch:
      - file: salt-master-conf