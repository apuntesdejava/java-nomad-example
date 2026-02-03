# java-nomad-example

Este es un ejemplo de cómo ejecutar el proyecto con Nomad con Java:

* Descargando un compilado (que está en GitHub)
* Ejecutando desde local (que está en la carpeta `target`)

## Preparando el entorno

Antes de ejecutar `nomad` necesitamos preparar el servicio. Para ello, lo ejecutaremos en modo de **desarrollo**. (Ojo, en modo de producción tiene otro procedimiento)

Bash (Linux/macOS):
```shell
ip link show # Primero, identificamos qué adaptador usaremos. En mi caso usaré "eth0"

sudo nomad agent -dev -bind=0.0.0.0 -network-interface=eth0 -log-level=DEBUG # Aquí, se indica el adatador en el parámetro `network-interface`

```

Powershell (Windows)
```powershell
Get-NetAdapter # Primero, identificamos qué adaptador usaremos. En mi caso usaré "Wi-Fi"

nomad agent -dev -bind="0.0.0.0" -network-interface="Wi-Fi" -log-level=DEBUG  # Aquí, se indica el adatador en el parámetro `network-interface`

```

## Descargando un compilado

Se puede ejecutar el comando nomad con el task `java`, pero tiene la restricción que solo puede ejecutar archivos que sean descargados, no desde local:

```hcl
task "api" {
  driver = "java"
#....
```

Por ello, se hizo un "[GH Actions](.github/workflows/release.yml)" que publica el .jar compilado en [GitHub](https://github.com/apuntesdejava/java-nomad-example/releases).

Finalmente, el nomad para ser ejecutado es este: [from-github.nomad](from-github.nomad), y comando es:

```shell
nomad run from-github.nomad
```

## Ejecutando desde local

Para ejecutar desde local, no se ejecuta el task `java` sino `raw_exec`. 

1. Compilar el proyecto como uber-jar:

Bash:
```shell
./mvnw clean package -Dquarkus.package.type=uber-jar
```

Powershell:
```powershell 
.\mwnw clean package "-Dquarkus.package.jar.type=uber-jar"
```




2. Con eso ya se tiene el .jar compilado, ahora, ejecutamos el nomad, pero para ello necesitamos pasar la posición del jar.
   Por ello, el archivo [`from-local.nomad`](from-local.nomad) tiene la definición de un parámetro de entrada

```hcl
variable "jar_path" {
  type        = string
  description = "Ruta absoluta al JAR en la máquina host"
}

```

Y en la parte donde va el .jar, se indica esa variable:

```hcl
    task "api" {
      driver = "raw_exec"
      config {
        command = "java"
        args = [
          "-jar",
          var.jar_path  # Aquí va la variable
        ]
      }
    }
```

Finalmente, para ser ejecutado, se hace de la siguiente manera:

Bash (Linux/macOS):

```shell
nomad job run -var="jar_path=$(pwd)/target/java-nomad-example-runner.jar" from-local.nomad
```

Powershell (Windows)
```powershell
nomad job run -var="jar_path=$(Get-Location)\target\java-nomad-example-runner.jar" .\from-local.nomad
```

La variable `$(pwd)` en bash y la variable `$(Get-Location)` en PowerShell dan la ruta absoluta desde donde se está ejecutando el comando. Por ello se está concatenando la parte de `target` y el jar generado, a fin de no colocar un hardcode de la ruta absoluta.