import salt.runner
import salt.config
import logging
import time


log = logging.getLogger(__name__)
opts = salt.config.master_config('/etc/salt/master')
runner = salt.runner.RunnerClient(opts)


def wait_for_minions_to_connect(name, minions, timeout=300):
    '''
    '''
    ret = {'name': name, 'changes': {}, 'result': False, 'comment': '',}

    start_time = time.time()
    all_connected = False

    while True:
        if time.time() - start_time > timeout and len(minions) > 0:
            all_connected = False
            break

        connected = runner.cmd('manage.up', [])
        for m in connected:
            minions.remove(m)

        if len(minions) == 0:
            all_connected = True
            break

    if all_connected:
        ret['comment'] = "All minions have been connected"
        ret['result'] = True
    else:
        ret['comment'] = "Timeout waiting for minions to connect"

    return ret
