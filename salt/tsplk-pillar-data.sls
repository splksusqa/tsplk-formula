include:
  - python-pip

{% set user = salt['pillar.get']('tsplk:user', 'tu') %}
{% set project = salt['pillar.get']('tsplk:project', 'tp') %}
{% set bucket_name = salt['pillar.get']('tsplk:bucket-name', 'tp') %}

awscli:
  pip.installed:
    - require:
      - sls: python-pip

# sync all extra data from host
pillar-data:
  cmd.run:
    - name: aws s3 sync s3://{{ bucket_name }}/{{ user }}-{{ project }} /srv/pillar
    - require:
      - pip: awscli