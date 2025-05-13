# 🐃 Odoo 18 - Entorno de Desarrollo con Docker

Este repositorio proporciona un entorno de desarrollo para Odoo 18 utilizando Docker y Docker Compose. Incluye configuraciones para una experiencia de desarrollo moderna: logs automáticos, persistencia de datos, sincronización de código y reinicio rápido.

> ✅ **Nota:** Este README está enfocado en el uso del entorno, **no** en el contenido o lógica de los módulos Odoo.

---

## 📦 Estructura del Proyecto

```
.
├── addons/                  # Directorio de desarrollo para módulos personalizados (montado en el contenedor)
├── config/                  # Configuración de Odoo (odoo.conf)
├── db_logs.txt              # Logs de la base de datos (generados automáticamente)
├── docker-compose.yml       # Orquestador de servicios Odoo y PostgreSQL
├── odoo_logs.txt            # Logs de Odoo (generados automáticamente)
├── run.sh                   # Script para levantar, reiniciar y administrar los contenedores
└── .gitignore               # Ignora directorio de módulos personalizados
```

---

## 📅 Comandos Disponibles

El script `run.sh` facilita distintas acciones según el entorno deseado:

```bash
./run.sh [opcion]
```

Opciones disponibles:

* `normal` ➔ Levanta contenedores normalmente (modo predeterminado de desarrollo)
* `clean` ➔ Elimina volúmenes (datos y DB) y reinicia el entorno desde cero
* `restart` ➔ Reinicia rápidamente solo el contenedor de Odoo para aplicar cambios de código

Ejemplo:

```bash
./run.sh restart
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

## 🚀 Comandos útiles dentro del contenedor Odoo

Accede al contenedor con:

```bash
docker exec -it odoo-web-1 bash
```

### 🔄 Actualizar un módulo

```bash
odoo -u nombre_modulo -d odoo_db --without-demo=all --stop-after-init
```

### 🤖 Odoo Shell (modo interactivo Python)

```bash
odoo shell -d odoo_db
```

Ejemplo:

```python
partner = env['res.partner'].search([('email', '=', 'usuario@ejemplo.com')], limit=1)
partner.name = 'Nuevo Nombre'
```

### 📦 Instalar un módulo

```bash
odoo -i nombre_modulo -d odoo_db --without-demo=all --stop-after-init
```

### 🔮 Ejecutar tests

```bash
odoo -i nombre_modulo --test-enable --log-level=test -d odoo_db --stop-after-init
```

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

## 🚮 Limpieza manual de contenedores y datos

```bash
docker-compose down -v
```

---

## 📄 Archivos clave

* `run.sh` — Script para automatizar el arranque, reinicio y limpieza del entorno
* `docker-compose.yml` — Define servicios de Odoo y PostgreSQL
* `config/odoo.conf` — Configuración central de Odoo
* `addons/` — Directorio local sincronizado con el contenedor para tus módulos personalizados

---

## 📩 Contribuciones

Este entorno está diseñado para uso local en desarrollo. Si tienes ideas o mejoras útiles para otros desarrolladores, los PRs son bienvenidos. ✨
