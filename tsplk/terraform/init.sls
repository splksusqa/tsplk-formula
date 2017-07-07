{% set tf_version = salt['pillar.get']('terraform:version') %}

# terraform
install-terraform:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://releases.hashicorp.com/terraform/{{ tf_version }}/terraform_{{ tf_version }}_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/terraform/{{ tf_version }}/terraform_{{ tf_version }}_SHA256SUMS
    - enforce_toplevel: False
    - archive_format: zip