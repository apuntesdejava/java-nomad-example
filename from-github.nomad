job "from-github" {
  datacenters = ["dc1"]
  group "backend" {
    count = 1
    network {
      port "http" {
        static = 8080
      }
    }
    task "api" {
      driver = "java"
      artifact {
         source      = "https://github.com/apuntesdejava/java-nomad-example/releases/download/3/java-nomad-example-runner.jar"
         destination = "local"
      }
      config {
        jar_path = "local/java-nomad-example-runner.jar"
      }

    }
  }

}
