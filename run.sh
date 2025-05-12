#!/usr/bin/env bash

# Script para levantar contenedores y guardar logs en archivos separados.

set -e

# Función para mostrar uso del script
function mostrar_uso() {
  echo "Uso: $0 [opcion]"
  echo "Opciones:"
  echo "  normal     Levanta contenedores en modo normal"
  echo "  clean      Elimina volúmenes y reinicia contenedores desde cero"
  echo
  echo "Ejemplo: $0 clean"
  exit 1
}

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
  echo "Docker no está instalado. Instalando..."
  sudo apt-get update -y
  sudo apt-get install -y docker.io
fi

# Verificar que docker-compose esté instalado
if ! command -v docker-compose &> /dev/null; then
  echo "docker-compose no está instalado. Instalando..."
  sudo apt-get update -y
  sudo apt-get install -y docker-compose
fi

# Función para iniciar logueo en archivos separados
function iniciar_logs() {
  echo "Guardando logs en odoo_logs.txt y db_logs.txt..."
  docker-compose logs -f web > odoo_logs.txt 2>&1 &
  docker-compose logs -f db > db_logs.txt 2>&1 &
}

# Funciones para cada modo de arranque
function arranque_normal() {
  echo "Arranque normal..."
  docker-compose up -d
  iniciar_logs
}

function arranque_clean() {
  echo "Eliminando volúmenes y reiniciando contenedores..."
  docker-compose down -v
  docker-compose up -d
  iniciar_logs
}

# Verificar parámetro
case "$1" in
  normal)
    arranque_normal
    ;;
  clean)
    arranque_clean
    ;;
  *)
    mostrar_uso
    ;;
esac

echo "¡Listo! Contenedores levantados y logs en archivos."
