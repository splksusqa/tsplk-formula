
# terraform
install-terraform:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://releases.hashicorp.com/terraform/0.8.2/terraform_0.8.2_linux_amd64.zip
    - source_hash: 6d0e8cf1221a2f2f05331a80e83bd795
    - enforce_toplevel: False