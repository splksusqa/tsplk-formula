## salt util sync_all
sync-all-states-files:
  salt.function:
    - name: saltutil.sync_all
    - tgt: {{ data['id'] }}