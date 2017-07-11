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

{% set count = len(salt['pillar.get']('tsplk:id_list', [])) %}
wait_for_start:
  salt.runner:
    - name: state.event
    - tagmatch: "salt/minion/*/start"
    - quiet: True
    - count: {{ count }}
    - timeout: 600
    - require:
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


## salt util sync_all
sync-all-states-files:
  salt.function:
    - name: saltutil.sync_all
    - tgt: '*'
    - require:
      - salt: wait_for_start


### run runner grains assign
create-site:
  salt.runner:
    - name: splunk.create_site
    - require:
      - salt: sync-all-states-files

## run runner
#hipchat:
#
#
#run-manage-up:
# salt.runner:
#   - name: manage.up