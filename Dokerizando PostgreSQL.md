# Dokerizando PostgreSQL

## Momentos previos

Si se tiene docker instalado y ya cuentas con un contenedor de postgres debes eliminarlo si deseas realizar una nueva conterizacion. Sigue los siguientes pasos.

- [ ] Liste los contenedores en ejecución 

  ```bash
  docker ps
  
  D:\BreakLineCorp\Contenedores\Bases de datos\PostgresMejorada>docker ps
  CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS                    PORTS                                         NAMES
  a20bae3cb95f   dpage/pgadmin4:latest   "/entrypoint.sh"         39 minutes ago   Up 39 minutes             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp       pgadmin_web
  bcccd0c47f36   postgres:16             "docker-entrypoint.s…"   39 minutes ago   Up 39 minutes (healthy)   0.0.0.0:5433->5432/tcp, [::]:5433->5432/tcp   postgres_db
  ```

- [ ] Liste la imagenes disponibles

  ```
  docker images
  ```

  ```bash
  D:\BreakLineCorp\Contenedores\Bases de datos\PostgresMejorada>docker images
  REPOSITORY                       TAG           IMAGE ID       CREATED         SIZE
  dpage/pgadmin4                   latest        5929bac24d91   9 days ago      785MB
  postgres                         16            66a5efb5677f   2 weeks ago     637MB
  mcr.microsoft.com/mssql/server   2022-latest   6249e946034c   6 weeks ago     2.26GB
  mysql                            latest        f1049ce35b39   4 months ago    1.17GB
  mysql                            8.4.3         106d5197fd8e   10 months ago   816MB
  ```

- [ ] Ejecute el comando

  ```bash
  docker ps -a
  ```

  ![](https://i.ibb.co/5Wxc4Gzx/image.png)

- [ ] Detenga los contenedores

  ```
  docker stop
  ```

  ```
  docker stop a20bae3cb95f -> Contenedor PgAdmin
  docker stop bcccd0c47f36 -> Contenedor Postgres
  ```

  

- [ ] Ejecute el comando `docker rm [ID Contenedor]` Para el ejemplo practico se eliminara el contenedor de pgadmin y el de postgreSQL

  ```
  docker rm a20bae3cb95f -> Contenedor PgAdmin
  docker rm bcccd0c47f36 -> Contenedor Postgres
  ```

   Cuando se realiza el proceso de stop y rm cada comando retorna el ID del contenedor.

  ```bash
  D:\BreakLineCorp\Contenedores\Bases de datos\PostgresMejorada>docker stop a20bae3cb95f
  a20bae3cb95f
  D:\BreakLineCorp\Contenedores\Bases de datos\PostgresMejorada>docker stop bcccd0c47f36
  bcccd0c47f36
  D:\BreakLineCorp\Contenedores\Bases de datos\PostgresMejorada>docker rm a20bae3cb95f
  a20bae3cb95f
  D:\BreakLineCorp\Contenedores\Bases de datos\PostgresMejorada>docker rm bcccd0c47f36
  bcccd0c47f36
  ```

- [ ] Elimine las imagenes use el comando `docker images`

  ```bash
  REPOSITORY                       TAG           IMAGE ID       CREATED         SIZE
  dpage/pgadmin4                   latest        5929bac24d91   9 days ago      785MB
  postgres                         16            66a5efb5677f   2 weeks ago     637MB
  mcr.microsoft.com/mssql/server   2022-latest   6249e946034c   6 weeks ago     2.26GB
  mysql                            latest        f1049ce35b39   4 months ago    1.17GB
  mysql                            8.4.3         106d5197fd8e   10 months ago   816MB
  ```

  ```
  docker rmi dpage/pgadmin4
  docker rmi postgres:16
  ```

## Paso a paso creación y montaje

- [ ] Instale Docker y Docker Compose

- [ ] Cree una Carpeta para almacenar los archivos principales de Docker

  - [ ] Cree el archivo .env

    ```bash
    # Postgres
    POSTGRES_USER=npi
    POSTGRES_PASSWORD=jjpardo
    POSTGRES_DB=ecommerce
    POSTGRES_PORT=5433
    
    # pgAdmin
    PGADMIN_DEFAULT_EMAIL=admin@example.com
    PGADMIN_DEFAULT_PASSWORD=SuperSegura123!
    PGADMIN_PORT=8080
    ```

  - [ ] Cree el Archivo Docker Compose (docker-compose.yaml)

    ```yaml
    services:
      postgres:
        image: postgres:16
        container_name: postgres_db
        environment:
          POSTGRES_USER: ${POSTGRES_USER}
          POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
          POSTGRES_DB: ${POSTGRES_DB}
        ports:
          - "${POSTGRES_PORT}:5432"
        volumes:
          - postgres_data:/var/lib/postgresql/data
        healthcheck:
          test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
          interval: 10s
          timeout: 5s
          retries: 5
        networks:
          - app_network
    
      pgadmin:
        image: dpage/pgadmin4:latest
        container_name: pgadmin_web
        depends_on:
          postgres:
            condition: service_healthy
        environment:
          PGADMIN_DEFAULT_EMAIL: ${PGADMIN_DEFAULT_EMAIL}
          PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_DEFAULT_PASSWORD}
          PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION: "True"
          PGADMIN_CONFIG_CONSOLE_LOG_LEVEL: "10"
        ports:
          - "${PGADMIN_PORT}:80"
        volumes:
          - pgadmin_data:/var/lib/pgadmin
          # 👉 OPCIONAL: auto-registrar el servidor Postgres en pgAdmin al primer arranque
          # - ./servers.json:/pgadmin4/servers.json:ro
        networks:
          - app_network
    
    volumes:
      postgres_data:
      pgadmin_data:
    
    networks:
      app_network:
    ```

    #### Detail

    #### 🔹 `services:`

    Aquí se definen los contenedores que Docker Compose va a crear.

    ------

    #### 🐘 Servicio **Postgres**

    ```
      postgres:
        image: postgres:16
    ```

    - Usa la **imagen oficial de Postgres** en su versión 16.
    - Esto incluye el motor de base de datos.

    ```
        container_name: postgres_db
    ```

    - Nombra explícitamente el contenedor `postgres_db` (si no, Docker le pondría uno aleatorio).

    ```
        environment:
          POSTGRES_USER: ${POSTGRES_USER}
          POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
          POSTGRES_DB: ${POSTGRES_DB}
    ```

    - Variables de entorno necesarias para inicializar la DB:
      - `POSTGRES_USER` → usuario administrador.
      - `POSTGRES_PASSWORD` → contraseña de ese usuario.
      - `POSTGRES_DB` → base que se crea automáticamente al arranque.
    - Están parametrizadas con **variables en `.env`**.

    ```
        ports:
          - "${POSTGRES_PORT}:5432"
    ```

    - Expone el puerto 5432 del contenedor en el host.
    - El puerto externo se toma de `.env` (`POSTGRES_PORT`, por ejemplo 5433).

    ```
        volumes:
          - postgres_data:/var/lib/postgresql/data
    ```

    - Monta un **volumen nombrado** (`postgres_data`) en la carpeta de datos de Postgres.
    - Así los datos persisten aunque borres el contenedor.

    ```
        healthcheck:
          test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
          interval: 10s
          timeout: 5s
          retries: 5
    ```

    - Define un chequeo de salud.
    - Ejecuta `pg_isready` cada 10s con un timeout de 5s.
    - Considera al contenedor sano si responde antes de 5 intentos.
    - Esto permite que otros servicios (como pgAdmin) esperen a que Postgres esté listo.

    ```
        networks:
          - app_network
    ```

    - Conecta el contenedor a la red interna `app_network`.
    - Permite que `pgadmin` lo encuentre con el hostname `postgres`.

    ------

    #### 🖥️ Servicio **pgAdmin**

    ```
      pgadmin:
        image: dpage/pgadmin4:latest
    ```

    - Usa la imagen oficial de **pgAdmin 4** (cliente web para PostgreSQL).

    ```
        container_name: pgadmin_web
    ```

    - Nombra el contenedor `pgadmin_web`.

    ```
        depends_on:
          postgres:
            condition: service_healthy
    ```

    - Espera a que el servicio `postgres` esté **healthy** antes de arrancar pgAdmin.

    ```
        environment:
          PGADMIN_DEFAULT_EMAIL: ${PGADMIN_DEFAULT_EMAIL}
          PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_DEFAULT_PASSWORD}
          PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION: "True"
          PGADMIN_CONFIG_CONSOLE_LOG_LEVEL: "10"
    ```

    - Configuración de pgAdmin:
      - Email y password de acceso (se definen en `.env`).
      - Opciones de seguridad y logging.

    ```
        ports:
          - "${PGADMIN_PORT}:80"
    ```

    - Expone el puerto 80 del contenedor (pgAdmin) al puerto externo definido en `.env` (`PGADMIN_PORT`, por ejemplo 8080).
    - Luego accedes con: `http://localhost:8080`.

    ```
        volumes:
          - pgadmin_data:/var/lib/pgadmin
          # - ./servers.json:/pgadmin4/servers.json:ro
    ```

    - Volumen `pgadmin_data` para que la configuración y usuarios de pgAdmin persistan.
    - (Opcional) puedes montar un `servers.json` para que pgAdmin ya tenga registrado el servidor Postgres automáticamente.

    ```
        networks:
          - app_network
    ```

    - Se conecta a la misma red que Postgres.
    - Así, cuando configures la conexión en pgAdmin, usas `Host: postgres` en lugar de `localhost`.

    ------

    #### 📦 `volumes:`

    ```
    volumes:
      postgres_data:
      pgadmin_data:
    ```

    - Define dos volúmenes nombrados para persistencia:
      - `postgres_data` → datos de la DB.
      - `pgadmin_data` → configuración de pgAdmin.

    ------

    #### 🌐 `networks:`

    ```
    networks:
      app_network:
    ```

    - Crea una red interna llamada `app_network`.
    - Solo los servicios definidos aquí pueden comunicarse entre sí.

    ------

    #### 🚀 Flujo completo

    1. Levantas todo con:

       ```
       docker compose up -d
       ```

    2. Docker crea:

       - `postgres_db` en `5433:5432`
       - `pgadmin_web` en `8080:80`

    3. Accedes en el navegador:

       - `http://localhost:8080`
       - Email: `${PGADMIN_DEFAULT_EMAIL}`
       - Pass: `${PGADMIN_DEFAULT_PASSWORD}`

    4. Desde pgAdmin, agregas un servidor con:

       - Host: `postgres` (nombre del servicio, no localhost)
       - Port: `5432`
       - User: `${POSTGRES_USER}`
       - Pass: `${POSTGRES_PASSWORD}`

  - [ ] Ejecute el comando `docker compose up -d`

> Recostruir Imagen
>
> docker compose up --force-recreate --build -d