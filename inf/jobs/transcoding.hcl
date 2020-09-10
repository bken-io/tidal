job "transcoding" {
  priority    = 100
  type        = "batch"
  datacenters = ["dc1"]

  parameterized {
    payload       = "optional"
    meta_required = [
      "cmd",
      "s3_in",
      "s3_out"
    ]
  }

  group "transcoding" {
    task "transcoding" {
      driver = "raw_exec"

      restart {
        attempts = 3
        delay    = "10s"
      }

      resources {
        cpu    = 2000
        memory = 1000
      }

      config {
        command = "/usr/bin/bash"
        args    = [
          "/root/src/transcoding.sh",
          "${NOMAD_META_S3_IN}",
          "${NOMAD_META_S3_OUT}",
          "${NOMAD_META_CMD}",
        ]
      }
    }

    reschedule {
      attempts       = 3
      delay          = "10s"
      max_delay      = "120s"
      unlimited      = false
      delay_function = "exponential"
    }
  }
}