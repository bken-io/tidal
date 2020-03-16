job "thumbnailer" {
  type        = "batch"
  datacenters = ["dc1"]

  parameterized {
    meta_required = ["input", "timecode", "keyid", "secretkey"]
  }

  task "thumbnailer" {
    driver = "exec"

    artifact {
      mode        = "file"
      destination = "local/file"
      source      = "${NOMAD_META_INPUT}"
    }

    // env {
    //   "AWS_DEFAULT_REGION"    = "US"
    //   "AWS_ACCESS_KEY_ID"     = "${NOMAD_META_KEYID}"
    //   "AWS_SECRET_ACCESS_KEY" = "${NOMAD_META_SECRETKEY}"
    // }

    config {
      command = "thumbnailer.sh"
      args    = ["${NOMAD_META_INPUT}", "${NOMAD_META_TIMECODE}"]
    }

    resources {
      cpu    = 250
      memory = 128
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