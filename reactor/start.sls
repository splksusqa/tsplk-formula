## salt util sync_all
sync-all-states-files:
  local.saltutil.sync_all:
    - tgt: {{ data['id'] }}

fire-event:
  local.event.fire_master:
    - tgt: {{ data['id'] }}
    - arg:
      - '{"data": "states have been synced "}'
      - states-synced
    - require:
      - sync-all-states-files
