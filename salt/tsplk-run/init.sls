# this is called by salt-call state.highstate not local
include:
  - debugging-splunk
  - salty-splunk
  - tsplk-infra
  - terraform

{% set user = salt['pillar.get']('tsplk:user', 'tu') %}
{% set project = salt['pillar.get']('tsplk:project', 'tp') %}
{% set bucket_name = salt['pillar.get']('tsplk:bucket-name', 'tp') %}
{% set hipchat_room_id = salt['pillar.get']('hipchat_room_id', '') %}
{% set hipchat_room_token = salt['pillar.get']('hipchat_room_token', '') %}

# init terraform
terraform-init:
  cmd.run:
    - name: terraform init --backend-config=key={{ user }}-{{ project }} --backend-config=bucket={{ bucket_name }}
    - cwd: /srv/tsplk-infra
    - require:
      - file: pillar-data
      - sls: terraform

# apply terraform
terraform-apply:
  cmd.run:
    - name: terraform apply -var-file=/srv/pillar/tf_vars.json -target=module.minion
    - cwd: /srv/tsplk-infra
    - require:
      - file: pillar-data
      - sls: terraform
      - cmd: terraform-init

wait_for_start:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - timeout: 600
    - id_list:
{% for id_name in salt['pillar.get']('tsplk:id_list', []) %}
      - {{ id_name }}
{% endfor %}
    - require:
      - cmd: terraform-apply
      - cmd: terraform-init

hipchat-message:
  hipchat.send_message:
    - room_id: {{ hipchat_room_id }}
    - message: 'This state was executed successfully.'
    - api_url: https://hipchat.splunk.com
    - api_key: {{ hipchat_room_token }}
    - api_version: v2
    - require:
      - salt: wait_for_start


# wait for all
#run-manage-up:
# salt.runner:
#   - name: manage.up
#
## salt util sync_all
#sync-all-states-files:
#  salt.function:
#    - name: saltutil.sync_all
#    - tgt: '*'
#    - require:
#      - sls: salty-splunk
#      - sls: tsplk-infra
#      - cmd.run: terraform-apply


### run runner grains assign
#salt.runner:
#  file.managed:
#    - name: /srv/pillar
#    - source:
#
## run runner
#hipchat:
#
#
#run-manage-up:
# salt.runner:
#   - name: manage.up