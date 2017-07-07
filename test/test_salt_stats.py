"""
Self-test.
Test the configuration of our own salt-dev machine. The salt-dev box is Ubuntu.
"""
import yaml
import pytest


# def test_salt_version(Docker):
#     result = Docker.run('salt-call test.version')
#     assert '2016.11.4' in result.stdout
#
#
# def test_terraform(Docker):
#     Docker.provision_state('terraform')
#     Cmd = Docker.get_module("Command")
#     assert Cmd.exists('terraform')
#     assert Cmd.run_test('terraform version')
test_data = {
    'terraform':
        {
            'version': '0.9.5',
            'hash': 'd127b4f981b1c8cba8ceb90fc6ab0788'
        }
}


class TestTopFile(object):
    def test_master_config(self, Docker):
        Docker.provision_as('tsplk-packer', pillar_data=
            {'tsplk': {'user': 'testuser', 'project': 'testproject'}})
        cmd = Docker.get_module("Command")
        out = cmd.check_output(
                    'cat /etc/salt/master')
        print(out)
        assert 'testuser/testproject/pillar' in out
        assert pillar['salty-splunk']['version'] in out

class TestTsplkRun(object):
    @pytest.mark.skip
    def test_debugging_splunk(self, Docker):
        result = Docker.run('echo test')
        print(result.stdout)
        result = Docker.run('ls /srv/salt')
        print(result.stdout)
        Docker.provision_state('debugging-splunk')


    def test_tsplk_pillar_data(self, Docker):
        Docker.provision_state('tsplk-pillar-data', pillar_data={'tsplk': {'user': 'testuser', 'project': 'testproject',
                                                                   'bucket-name': 'tsplk-bucket'}})
        result = Docker.run('ls /srv/pillar')
        assert 'testdata' in result.stdout
        result = Docker.run('ls /srv/pillar/testfolder')
        assert 'testdata' in result.stdout


    def test_master_config(self, Docker):
        Docker.provision_state('tsplk-master-config', pillar_data={'tsplk': {'bucket-name': 'tsplk-bucket'}})
        # result = Docker.check_output(
        #     'salt-call -l debug --master=localhost test.version')
        result = Docker.run('salt-run fileserver.file_list backend=s3fs')
        print(result.stdout)
        print(result.stderr)
        result = Docker.run('ls /srv')
        print(result)


    def test_tsplk_terraform(self, Docker):
        tf_version = '0.9.11'
        data = {'terraform': {'version': tf_version}}
        Docker.provision_state('terraform', pillar_data=data)
        cmd = Docker.run('terraform version')
        print(cmd.stdout)
        assert tf_version in cmd.stdout


    def test_tsplk_run(self, Docker):
        result = Docker.check_output('salt --version')
        print(result)
        result = Docker.check_output('salt-call --local pillar.items')
        print(result)
        result = Docker.check_output('salt-call --local state.apply tsplk-run')
        print(result)


    # @pytest.mark.parametrize(
    #     'pillar',
    #     [
    #         None,
    #         {'tsplk': {'salty-splunk': {'version': '0.4'}}}
    #     ]
    # )
    # def test_salty_splunk(self, Docker, pillar):
    #     Docker.provision_state('salty-splunk', pillar_data=pillar)
    #     f_class = Docker.get_module("File")
    #     f = f_class('/srv/salty-splunk/README.md')
    #     Cmd = Docker.get_module("Command")
    #     if pillar:
    #         out = Cmd.check_output(
    #             'cd /srv/salty-splunk && git describe --tags')
    #         assert pillar['salty-splunk']['version'] in out
    #     assert f.exists
    #
    # def test_tsplk_infra(self, Docker):
    #     Docker.provision_state('tsplk', 'tsplk-infra')
    #     f_class = Docker.get_module("File")
    #     f = f_class('/srv/tsplk-infra/splunk.tf')
    #     assert f.exists
    #
    # def test_tsplk_master_conf(self, Docker):
    #     Docker.provision_state('tsplk', 'salt-master-conf')
    #     Cmd = Docker.get_module("Command")
    #     out = Cmd.check_output('cat /etc/salt/master')
    #     data = yaml.load(out)
    #     assert data['auto_accept'] is True


# class TestIntegration(object):
#     def test_integration_master(self, Docker):
#         Docker.provision_as('tsplk-saltmaster')

