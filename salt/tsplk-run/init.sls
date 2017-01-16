# this is called by salt-call state.highstate not local

#timeout cron job
#timeout-manager:
#  cron.present:
#    - name: check-
#    - user: root
#    - hour: 1
{% set user = salt['pillar.get']('tsplk:user', 'tu') %}
{% set project = salt['pillar.get']('tsplk:project', 'tp') %}

# salt util sync_all
sync-all-states-files:
  salt.function:
    - name: saltutil.sync_all
    - tgt: '*'


# sync data from s3
#tf-variables:
#  file.managed:
#    - name: /tmp/tf-vars.json
#    - source: salt://{{ user }}/{{ project }}/tf.vars.json
#
### store credential for tf backend
#aws-credintial:
#  cmd.run:
#
### spin up vm
#terraform-apply:
#  cmd.run:
#    - name: terraform apply -var-file=/tmp/tf-vars.json tf
#    - cwd: /srv/tsplk-infra
##
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