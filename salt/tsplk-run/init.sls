# this is called by salt-call state.highstate not local
include:
  - salty-splunk
  -

{% set user = salt['pillar.get']('tsplk:user', 'tu') %}
{% set project = salt['pillar.get']('tsplk:project', 'tp') %}

# salt util sync_all
sync-all-states-files:
  salt.function:
    - name: saltutil.sync_all
    - tgt: '*'

# sync all extra data from host
pillar-data:
  file.managed:
    # this is defined in master config
    - name: /srv/data
    # base path is needed for s3fs backend
    - source: salt://base/{{ project }}/data

### spin up vm
terraform-apply:
  cmd.run:
    - name: |
        terraform remote config -backend=s3 -backend-config="bucket=tsplk-bucket" \
        -backend-config="key=base/{{ user }}/{{ project }}/terraform.tfstate" \
        -backend-config="region=us-west-2"
    - cwd: /srv

terraform-apply:
  cmd.run:
    - name: terraform apply -var-file=data/salt_minion_var.json /tsplk-infra/tf/salt_minion
    - cwd: /srv

### run runner grains assign
##salt.runner:
##  file.managed:
##    - name: /srv/pillar
##    - source:
##
### run runner
##hipchat:
#
#
#run-manage-up:
# salt.runner:
#   - name: manage.up