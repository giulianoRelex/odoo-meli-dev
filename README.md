# 🐃 Odoo 18 - Entorno de Desarrollo con Docker

Este repositorio proporciona un entorno de desarrollo para Odoo 18 utilizando Docker y Docker Compose. Incluye configuraciones para una experiencia de desarrollo moderna: logs automáticos, persistencia de datos, sincronización de código y reinicio rápido.

> ✅ **Nota:** Este README está enfocado en el uso del entorno, **no** en el contenido o lógica de los módulos Odoo.

---

## 📦 Estructura del Proyecto

```
.
├── addons/                  # Directorio de desarrollo para módulos personalizados (montado en el contenedor)
├── enterprise-18.0/         # Módulos enterprise de Odoo 18 (montado en el contenedor)
├── config/                   # Configuración de Odoo (odoo.conf)
├── db_logs.txt              # Logs de la base de datos (generados automáticamente)
├── docker-compose.yml       # Configuración de servicios Docker
├── odoo_logs.txt            # Logs de Odoo (generados automáticamente)
├── run.sh                   # Script para gestion de los contenedores
└── .gitignore               # Ignora directorio de módulos personalizados
```

---


## ⚙️ Servicios Docker

El archivo `docker-compose.yml` define dos servicios principales:

- **PostgreSQL** (puerto local: `5433`)
  - Usuario: `odoo`
  - Contraseña: `odoo`
  - Base de datos: `odoo_db`

- **Odoo 18** (puerto local: `8080`)
  - Configuración personalizada en `config/odoo.conf`
  - Carga los addons desde `./addons` y `./enterprise-18.0`
  - Inicia con los módulos `base`, `web` y `mail`, sin datos demo

## 🛠 Configuración de Odoo

Archivo: `config/odoo.conf`

```ini
[options]
admin_passwd = admin
db_host = db
db_port = 5432
db_user = odoo
db_password = odoo
db_name = odoo_db
log_level = info
addons_path = /mnt/extra-addons,/mnt/enterprise-addons
```

---

## 🚀 Uso del Entorno

El script run.sh simplifica el manejo del entorno. Asegurate de tener permisos de ejecución:

```bash
chmod +x run.sh
```

Comandos disponibles:
```bash
./run.sh normal    # Levanta los contenedores en modo normal
./run.sh clean     # Elimina volúmenes y reinicia contenedores desde cero
./run.sh restart   # Reinicia solo el contenedor web
./run.sh stop      # Apaga todos los contenedores
```

---

## 📆 Flujo de desarrollo recomendado

1. Inicia el entorno:

   ```bash
   ./run.sh normal
   ```

2. Desarrolla tus módulos en `addons/`, que está montado dentro del contenedor de Odoo.

3. Los cambios en:

   * **Vistas XML** (por ejemplo, `*.xml` en `views/`): se aplican inmediatamente
   * **Modelos Python** (`models/`), **controladores**, o **archivos `.py` en general**: requieren reinicio

4. Reinicia rápidamente con:

   ```bash
   ./run.sh restart
   ```

   Esto **no borra datos** y permite ver los cambios de manera instantánea.

---

## 🔍 Ver logs

Logs generados localmente:

```bash
tail -f odoo_logs.txt     # Logs de Odoo
tail -f db_logs.txt       # Logs de PostgreSQL
```

---

## 🛠️ Requisitos

* Docker
* Docker Compose
* Bash (para ejecutar `run.sh`)

---

## 🔑 Acceso a Odoo

Una vez levantado el entorno:

```
http://localhost:8080
```

Configura tu base de datos la primera vez directamente desde la interfaz web.

---
### 📝 Notas
 - El directorio addons/ ya está montado como volumen. Cuando crees tus módulos personalizados, se cargarán automáticamente.
 - El directorio enterprise-18.0/ debe contener los módulos de Odoo Enterprise compatibles con la versión 18.0.
 - Este entorno fue probado con Docker Compose v3.8 y la imagen oficial odoo:18.
