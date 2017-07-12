## salt util sync_all
sync-all-states-files:
  local.saltutil.sync_all:
    - tgt: {{ data['id'] }}
