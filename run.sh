#!/usr/bin/env bash

set -e

# Variables
WEB_CONTAINER="web"
DB_CONTAINER="db"
WEB_LOG="odoo_logs.txt"
DB_LOG="db_logs.txt"

function mostrar_uso() {
  echo "Uso: $0 [opcion]"
  echo "Opciones disponibles:"
  echo "  normal     Levanta contenedores en modo normal"
  echo "  clean      Elimina volúmenes y reinicia contenedores desde cero"
  echo "  restart    Reinicia solo el contenedor web"
  echo "  stop       Apaga todos los contenedores"
  echo
  echo "Ejemplo: $0 normal"
  exit 1
}

function verificar_dependencias() {
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
}

function iniciar_logs() {
  echo "Guardando logs en $WEB_LOG y $DB_LOG..."
  docker-compose logs -f $WEB_CONTAINER > "$WEB_LOG" 2>&1 &
  echo $! > .web_log_pid
  docker-compose logs -f $DB_CONTAINER > "$DB_LOG" 2>&1 &
  echo $! > .db_log_pid
}

function detener_logs() {
  echo "Deteniendo logs..."
  [[ -f .web_log_pid ]] && kill $(cat .web_log_pid) && rm .web_log_pid
  [[ -f .db_log_pid ]] && kill $(cat .db_log_pid) && rm .db_log_pid
}

function arranque_normal() {
  echo "Iniciando contenedores..."
  docker-compose up -d
  iniciar_logs
}

function arranque_clean() {
  echo "Eliminando contenedores y volúmenes..."
  docker-compose down -v
  docker-compose up -d
  iniciar_logs
}

function reiniciar_web() {
  echo "Reiniciando contenedor $WEB_CONTAINER..."
  docker-compose restart $WEB_CONTAINER
}

function detener_contenedores() {
  echo "Apagando contenedores..."
  docker-compose down
  detener_logs
}

# Verificar dependencias
verificar_dependencias

# Ejecutar según opción
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
  stop)
    detener_contenedores
    ;;
  *)
    mostrar_uso
    ;;
esac

echo "✅ Operación '$1' completada."
