import pytest
import testinfra
import json

target_boxes = ['ubuntu15-salt']
# get check_output from local host
check_output = testinfra.get_host("local://").check_output

# # Override the host fixture
# @pytest.fixture
# def host(request):
#     docker_id = check_output(
#         "docker run -d %s tail -f /dev/null", request.param)
#     # yield a dynamic created host
#     yield testinfra.get_host("docker://" + docker_id)
#     # destroy the container
#     check_output("docker rm -f %s", docker_id)

@pytest.fixture(scope='function', params=target_boxes)
def image_name(request):
    """
    This fixture returns the image names to test against.
    Override this fixture in your module if you need to test with different images.
    """
    return request.param


@pytest.fixture(scope='function')
def docker_image(image_name):
    from os.path import dirname
    test_dir = dirname(__file__)
    cmd = check_output("docker build -t %s %s/%s", image_name, test_dir, image_name)
    # assert cmd.rc == 0
    return image_name


def docker_backend_provision_as(self, minion_id):
    """
    Provision the image with Salt. The image is provisioned as if it were a minion with name `minion_id`.
    """
    # Command = self.run("Command")
    print('Executing salt-call locally for id', minion_id)
    salt_call_cmd = "salt-call --local --force-color " \
                    "--retcode-passthrough " \
                    "--id={0} state.highstate".format(minion_id)
    cmd = self.run(salt_call_cmd)
    print(cmd.stdout)
    assert cmd.rc == 0
    return cmd

def docker_backend_provision_state(self, state, id=None, pillar_data=None):

    cmd_str = 'state.sls_id' if id else 'state.apply'
    id_str = id if id else ''
    pillar_data = "pillar='{0}'".format(json.dumps(pillar_data)) if pillar_data else ''
    salt_call_cmd = "salt-call --local --force-color " \
                    "--retcode-passthrough " \
                    "{0} {1} {2} {3}".format(cmd_str, id_str, state, pillar_data)
    print(salt_call_cmd)
    cmd = self.run(salt_call_cmd)
    print(cmd.stdout)
    assert cmd.rc == 0, cmd.stderr
    return cmd
    

@pytest.fixture(scope='function')
def Docker(request, docker_image):
    """
    Boot and stop a docker image. The image is primed with salt-minion.
    """
    from os.path import dirname
    root_dir = dirname(dirname(__file__))

    formula_folder = '/srv/salt'
    print 'Project root dir is:', root_dir

    # Run a new container. Run in privileged mode, so systemd will start
    cmd_str = "docker run --privileged -d -l debug " \
              "-v {rd}/salt:{f} " \
              "{di}".format(rd=root_dir, di=docker_image, f=formula_folder)
    docker_id = check_output(cmd_str)

    def teardown():
        check_output("docker kill %s", docker_id)
        check_output("docker rm %s", docker_id)

    # At the end of each test, we destroy the container
    request.addfinalizer(teardown)
    docker = testinfra.get_host("docker://" + docker_id)
    import types
    docker.provision_as = types.MethodType(docker_backend_provision_as, docker)
    docker.provision_state = types.MethodType(docker_backend_provision_state, docker)

    return docker







# get_backend_class('docker').provision_as = \
#     docker_backend_provision_as
# testinfra.backend.get_backend_class('docker').provision_state = \
#     docker_backend_provision_state

@pytest.fixture
def Slow():
    """
    Run a slow check, check if the state is correct for `timeout` seconds.
    """
    import time
    def slow(check, timeout=30):
        timeout_at = time.time() + timeout
        while True:
            try:
                assert check()
            except AssertionError, e:
                if timeout_at < time.time():
                    time.sleep(1)
                else:
                    raise e
            else:
                return
    return slow

# vim:sw=4:et:ai
