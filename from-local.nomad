variable "jar_path" {
  type        = string
  description = "Ruta absoluta al JAR en la máquina host"
}

job "from-local" {
  datacenters = ["dc1"]


  group "backend" {
    count = 1
    network {
      port "http" {
        static = 8080
      }
    }
    task "api" {
      driver = "raw_exec"
      config {
        command = "java"
        args = [
          "-jar",
          var.jar_path
        ]
      }
    }
  }

}
