job "transcode" {
  type        = "batch"
  datacenters = ["dc1"]

  parameterized {
    meta_required = ["input", "keyid", "secretkey"]
  }

  task "transcode" {
    driver = "exec"

    artifact {
      mode        = "file"
      destination = "local/file"
      source      = "${NOMAD_META_INPUT}"
    }

    env {
      "AWS_DEFAULT_REGION"    = "US"
      "AWS_ACCESS_KEY_ID"     = "${NOMAD_META_KEYID}"
      "AWS_SECRET_ACCESS_KEY" = "${NOMAD_META_SECRETKEY}"
    }

    config {
      command = "transcode.sh"
    }

    resources {
      cpu    = 1024
      memory = 1024
    }

    template {
      destination = "local/s3cfg.ini"
      data = <<EOH
[default]
access_key = "${NOMAD_META_KEYID}"
secret_key = "${NOMAD_META_SECRETKEY}"
host_base = nyc3.digitaloceanspaces.com
host_bucket = %(bucket)s.nyc3.digitaloceanspaces.com
EOH
    }
  }
}