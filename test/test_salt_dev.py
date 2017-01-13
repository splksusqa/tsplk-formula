"""
Self-test.
Test the configuration of our own salt-dev machine. The salt-dev box is Ubuntu.
"""
import yaml
import pytest

def test_salt_version(Docker):
    result = Docker.run('salt-call test.version')
    assert '2016.11.1' in result.stdout


def test_terraform(Docker):
    Docker.provision_state('terraform')
    Cmd = Docker.get_module("Command")
    assert Cmd.exists('terraform')
    assert Cmd.run_test('terraform version')


class TestTsplk(object):
    @pytest.mark.parametrize(
        'pillar',
        [
            None,
            {'tsplk': {'salty-splunk': {'version': '0.4'}}}
        ]
    )
    def test_salty_splunk(self, Docker, pillar):
        Docker.provision_state('salty-splunk', pillar_data=pillar)
        f_class = Docker.get_module("File")
        f = f_class('/srv/salty-splunk/README.md')
        Cmd = Docker.get_module("Command")
        if pillar:
            out = Cmd.check_output(
                'cd /srv/salty-splunk && git describe --tags')
            assert pillar['salty-splunk']['version'] in out
        assert f.exists

    def test_tsplk_infra(self, Docker):
        Docker.provision_state('tsplk', 'tsplk-infra')
        f_class = Docker.get_module("File")
        f = f_class('/srv/tsplk-infra/splunk.tf')
        assert f.exists

    def test_tsplk_master_conf(self, Docker):
        Docker.provision_state('tsplk', 'salt-master-conf')
        Cmd = Docker.get_module("Command")
        out = Cmd.check_output('cat /etc/salt/master')
        data = yaml.load(out)
        assert data['auto_accept'] is True


class TestIntegration(object):
    def test_integration_master(self, Docker):
        Docker.provision_as('tsplk-saltmaster')

