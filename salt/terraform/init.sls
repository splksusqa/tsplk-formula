{% set tf_version = salt['pillar.get']('terraform:version') %}
{% set tf_hash = salt['pillar.get']('terraform:hash') %}

# terraform
install-terraform:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://releases.hashicorp.com/terraform/{{ tf_version }}/terraform_{{ tf_version }}_linux_amd64.zip
    - source_hash: {{ tf_hash }}
    - enforce_toplevel: False
    - archive_format: zip