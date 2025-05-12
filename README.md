# 🐘 Odoo 18 - Entorno de Desarrollo con Docker

Este repositorio proporciona un entorno de desarrollo para Odoo 18 utilizando Docker y Docker Compose. Incluye configuración personalizada para módulos locales, logs separados, y herramientas para facilitar el trabajo del desarrollador.

> ✅ **Nota:** Este README está enfocado en el uso del entorno, **no** en el contenido o lógica de los módulos Odoo.

---

## 📦 Estructura del Proyecto

```
.
├── addons/                  # Directorio para módulos externos adicionales (vacío por defecto)
├── config/                  # Configuración de Odoo (odoo.conf)
├── db_logs.txt              # Logs de la base de datos (generados automáticamente)
├── docker-compose.yml       # Orquestador de servicios Odoo y PostgreSQL
├── odoo_logs.txt            # Logs de Odoo (generados automáticamente)
├── run.sh                   # Script para levantar y reiniciar contenedores
└── .gitignore               # Ignora directorio de módulos personalizados
```

---

## 📁 ¿Dónde van los módulos personalizados?

Por convención, puedes colocar tus módulos personalizados en un directorio como `odoo/`. **Este directorio está ignorado por Git**, lo que significa que **no forma parte del repositorio**. Esto permite que cada desarrollador cree su propio entorno sin conflictos con el repositorio base.

### ⚠️ Importante

Debes crear tu propio directorio para módulos (por ejemplo, `mi-odoo`) y modificar `docker-compose.yml` para reflejar la ruta adecuada:

```yaml
volumes:
  - ./mi-odoo:/mnt/mi-odoo  # Reemplaza con tu ruta local
```

Y asegurarte de que esa ruta esté incluida en la configuración de Odoo (`addons_path` en `odoo.conf`).

---

## 🚀 Cómo levantar el entorno

Usa el script `run.sh` para iniciar el entorno de forma rápida:

```bash
./run.sh normal
```

Esto hace lo siguiente:
- Verifica que Docker y Docker Compose estén instalados (e intenta instalarlos si no lo están)
- Inicia los contenedores Odoo y PostgreSQL
- Redirige logs automáticamente a `odoo_logs.txt` y `db_logs.txt`

---

### 🔄 Reinicio completo (limpiar datos)

Si quieres **reiniciar desde cero** (eliminando volúmenes y base de datos):

```bash
./run.sh clean
```

---

## ⚙️ Configuración de Docker Compose

`docker-compose.yml` define:

- **PostgreSQL (db):**  
  - Usuario: `odoo`  
  - Base de datos: `odoo_db`  
  - Puerto local: `5433`

- **Odoo (web):**
  - Imagen: `odoo:18`
  - Puerto local: `8080` → acceso en `http://localhost:8080`
  - Volúmenes montados:
    - `./config` → configuración (`odoo.conf`)
    - `./addons` → módulos externos
    - `./<tu-directorio>` → módulos personalizados
  - Inicializa los módulos base: `base, web, mail`

---

## 🛠️ Comandos útiles para desarrollo

### 🔄 Actualizar un módulo sin reiniciar todo

1. Accede al contenedor Odoo:

```bash
docker exec -it odoo-web-1 bash
```

2. Ejecuta la actualización del módulo (reemplaza `my_module` por el nombre de tu módulo):

```bash
odoo -u my_module -d odoo_db --stop-after-init
```

- Esto aplicará los cambios y detendrá el proceso Odoo (puedes volver a levantarlo con `docker-compose restart web`).
- También puedes usarlo **sin detener** el proceso si estás en modo desarrollo:

```bash
odoo -u my_module -d odoo_db
```

---

## 🔍 Ver Logs

Los logs de Odoo y PostgreSQL se redirigen automáticamente a archivos locales:

- Odoo: `odoo_logs.txt`
- PostgreSQL: `db_logs.txt`

Puedes monitorearlos en vivo con:

```bash
tail -f odoo_logs.txt
```

---

## 🧰 Requisitos del sistema

- Docker
- Docker Compose
- Bash (para ejecutar `run.sh`)

---

## ✅ Acceso a Odoo

Una vez levantado el entorno:

```
http://localhost:8080
```

Usuario y contraseña se configuran al crear la base de datos la primera vez desde el navegador.

---

## 🧹 Limpieza de contenedores y volúmenes

Para eliminar contenedores y datos persistentes manualmente:

```bash
docker-compose down -v
```

---

## 📄 Archivos clave

- `run.sh` — Script de ayuda para iniciar o reiniciar el entorno con logs automatizados
- `docker-compose.yml` — Orquestador de contenedores
- `config/odoo.conf` — Configuración de Odoo
- `odoo_logs.txt` / `db_logs.txt` — Logs generados automáticamente al levantar el entorno

---

## 📬 Contribuciones

Este entorno está pensado para desarrollo local. Si encuentras mejoras que puedan ayudar a otros, ¡los PRs son bienvenidos!