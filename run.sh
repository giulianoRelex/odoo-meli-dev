#!/usr/bin/env bash

set -e

function mostrar_uso() {
  echo "Uso: $0 [opcion]"
  echo "Opciones:"
  echo "  normal     Levanta contenedores en modo normal"
  echo "  clean      Elimina volúmenes y reinicia contenedores desde cero"
  echo "  restart    Reinicia solo el contenedor web (para recargar cambios Python)"
  echo
  echo "Ejemplo: $0 dev"
  exit 1
}

if ! command -v docker &> /dev/null; then
  echo "Docker no está instalado. Instalando..."
  sudo apt-get update -y
  sudo apt-get install -y docker.io
fi

if ! command -v docker-compose &> /dev/null; then
  echo "docker-compose no está instalado. Instalando..."
  sudo apt-get update -y
  sudo apt-get install -y docker-compose
fi

function iniciar_logs() {
  echo "Guardando logs en odoo_logs.txt y db_logs.txt..."
  docker-compose logs -f web > odoo_logs.txt 2>&1 &
  docker-compose logs -f db > db_logs.txt 2>&1 &
}

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

function reiniciar_web() {
  echo "Reiniciando servicio web (Odoo)..."
  docker-compose restart web
}

case "$1" in
  normal)
    arranque_normal
    ;;
  clean)
    arranque_clean
    ;;
  restart)
    reiniciar_web
    ;;
  *)
    mostrar_uso
    ;;
esac

echo "¡Listo! Contenedores levantados y logs en archivos."
