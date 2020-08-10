job "transcoding" {
  type        = "batch"
  datacenters = ["dc1"]
  priority    = 1

  parameterized {
    payload       = "optional"
    meta_required = [
      "cmd",
      "s3_in",
      "s3_out",
      "script_path"
    ]
  }

  group "transcoding" {
    task "transcoding" {
      restart {
        attempts = 3
        delay    = "10s"
      }

      resources {
        cpu    = 4000
        memory = 1000
      }

      driver = "raw_exec"

      config {
        command = "/usr/bin/bash"
        args    = [
          "${NOMAD_META_SCRIPT_PATH}",
          "${NOMAD_META_S3_IN}",
          "${NOMAD_META_S3_OUT}",
          "${NOMAD_META_CMD}",
        ]
      }
    }

    reschedule {
      attempts       = 3
      delay          = "10s"
      max_delay      = "30m"
      unlimited      = false
      delay_function = "exponential"
    }
  }
}