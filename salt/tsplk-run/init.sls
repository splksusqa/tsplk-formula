# this is called by salt-call state.highstate not local
include:
  - salty-splunk
  - tsplk-infra

{% set user = salt['pillar.get']('tsplk:user', 'tu') %}
{% set project = salt['pillar.get']('tsplk:project', 'tp') %}
{% set bucket_name = salt['pillar.get']('tsplk:bucket-name', 'tp') %}
{% set hipchat_room_id = salt['pillar.get']('hipchat_room_id', '') %}
{% set hipchat_room_token = salt['pillar.get']('hipchat_room_token', '') %}
{% set atlas_token = salt['pillar.get']('atlas_token') %}

# init terraform
terraform-init:
  cmd.run:
    - name: terraform init --backend-config=key={{ user }}-{{ project }} --backend-config=bucket={{ bucket_name }}
    - cwd: /srv/tsplk-infra/tf
    - require:
      - sls: tsplk-infra

# apply terraform
terraform-apply:
  cmd.run:
    - name: terraform apply -var-file=/srv/pillar/tf_vars.json -target=module.minion
    - cwd: /srv/tsplk-infra/tf
    - env:
      - TF_VAR_atlas_token: {{ atlas_token }}
    - require:
      - cmd: terraform-init

# copy license to filebase
{% set license = salt['pillar.get']('license_name', "") %}
{% if license != "" %}
copy-license:
  file.copy:
    - name: /srv/files/{{ license }}
    - source: /srv/pillar/{{ license }}
    - force: True

{% endif %}

{% set version = salt['pillar.get']('version', "") %}
{% if version != "" %}
### run runner grains assign
create-site:
  salt.runner:
    - name: splunk.create_site
    - require:
      - cmd: terraform-apply
{% endif %}

# send hipchat message to users
{% set mention_name = salt['pillar.get']('tsplk:mention_name', '') %}
{% set hipchat_server = "https://hipchat.splunk.com/v2" %}
{% if version != "" %}
  {% set require = "salt: create-site" %}
{% else %}
  {% set require = "cmd: terraform-apply" %}
{% endif %}

hipchat-message:
  http.query:
    - name: {{ hipchat_server }}/room/{{ hipchat_room_id }}/notification?auth_token={{ hipchat_room_token }}
    - data: "message=@{{ mention_name }} The project {{ project }} was deployed successfully.&color=random&message_format=text"
    - status: 204
    - method: POST
    - require:
      - {{ require }}

{% set slack_web_hook = salt['pillar.get']('slack_web_hook', '') %}
{% if slack_web_hook != "" %}
slack-message:
    cmd.run:
    - name: "curl -X POST -H 'Content-type: application/json' --data '{\"text\":\"<@{{ user }}> Your project {{ project }} was deployed successfully\"}' {{ slack_web_hook }}"
    - require:
      - {{ require }}
{% endif %}

#run-manage-up:
# salt.runner:
#   - name: manage.up
