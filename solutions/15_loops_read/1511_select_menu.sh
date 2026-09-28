#!/bin/bash
PS3="Opcion: "
select opt in listar contar salir; do
  case $opt in
    listar) ls ;;
    contar) echo "$(ls | wc -l) files" ;;
    salir) echo bye; break ;;
    *) echo "invalid option" ;;
  esac
done

