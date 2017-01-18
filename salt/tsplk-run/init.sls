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

# sync pillar data
#pillar-data:
#  file.managed:
#    # this is defined in master config
#    - name: /srv/pillar
#    # base path is needed for s3fs backend
#    - source: salt://base/{{ user }}/{{ project }}/pillar

# sync terraform variables

## store credential for tf backend if it's on AWS and backend is S3
aws-credintial:
  pkg.installed:
    - name: jq
  cmd.run:
#    todo hard code tsplk here
    - name: curl http://169.254.169.254/latest/meta-data/iam/security-credentials/tsplk | jq .'AccessKeyId' >> /tmp/test
    - require: aws-credintial.pkg

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