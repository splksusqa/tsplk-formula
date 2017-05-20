/opt/splunk-6.6.0-1c4f3bbe1aea-Linux-x86_64.tgz:
  file.managed:
    - source: "https://www.splunk.com/bin/splunk/DownloadActivityServlet?\
    architecture=x86_64&platform=linux&version=6.6.0&product=splunk&\
    filename=splunk-6.6.0-1c4f3bbe1aea-Linux-x86_64.tgz&wget=true"
    - source_hash: "https://download.splunk.com/products/splunk/releases/6.6.0/\
    linux/splunk-6.6.0-1c4f3bbe1aea-Linux-x86_64.tgz.md5"

install-and-start:
  cmd.run:
    - name: >
        tar xf splunk-6.6.0-1c4f3bbe1aea-Linux-x86_64.tgz &&
        ./splunk/bin/splunk start --accept-license --answer-yes &&
        ./splunk/bin/splunk enable boot-start &&
        ./splunk/bin/splunk add monitor /var/log -auth admin:changeme
    - cwd: /opt
    - require:
      - file: /opt/splunk-6.6.0-1c4f3bbe1aea-Linux-x86_64.tgz