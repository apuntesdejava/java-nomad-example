variable "jar_path" {
  type        = string
  description = "Ruta absoluta al JAR en la máquina host"
}

job "from-local" {
  datacenters = ["dc1"]


  group "backend" {
    count = 1
    network {
      port "http" {}
      port "debug" {}
    }
    task "api" {
      driver = "raw_exec"
      config {
        command = "java"
        args = [
          "-Dquarkus.http.port=${NOMAD_PORT_http}",
          "-Dquarkus.http.host=0.0.0.0",
          "-Ddebug.port=${NOMAD_PORT_debug}",
          "-jar",
          var.jar_path
        ]
      }

      env {
        MY_IP_ADDRESS = "${NOMAD_IP_http}"
        MY_PORT       = "${NOMAD_PORT_http}"
      }
    }
  }

}
