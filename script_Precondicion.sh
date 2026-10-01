#!/bin/bash

TIMESTAMP=$(date +%Y%m%d)

TARGET_DIR="${1:-$PWD}"
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

DIR_SCRIPTS="${TARGET_DIR}/RTA_SCRIPT_Examen_${TIMESTAMP}"
DIR_ARCHIVOS="${TARGET_DIR}/RTA_ARCHIVOS_Examen_${TIMESTAMP}"

# 1. Crear carpetas de trabajo
mkdir -p "$DIR_SCRIPTS" "$DIR_ARCHIVOS"

# 2. Manejo de scripts Punto_*.sh (Mover si existen en la raíz o crearlos)
if ls "${TARGET_DIR}"/Punto_*.sh 1> /dev/null 2>&1; then
    mv "${TARGET_DIR}"/Punto_*.sh "$DIR_SCRIPTS/"
else
    touch "$DIR_SCRIPTS"/Punto_{A..F}.sh
fi
chmod +x "$DIR_SCRIPTS"/Punto_*.sh 2>/dev/null

# 3. Manejo y blindaje de ~/.bash_history
touch ~/.bash_history

# Si ya tiene el atributo 'a', se remueve temporalmente para poder hacer chmod
if [[ "$(lsattr "$HOME/.bash_history" 2>/dev/null | awk '{print $1}')" == *a* ]]; then
    sudo chattr -a ~/.bash_history 2>/dev/null
fi

chmod 600 ~/.bash_history

# Se le vuelve a aplicar el atributo +a para blindarlo
if command -v sudo >/dev/null 2>&1; then
    sudo chattr +a ~/.bash_history 2>/dev/null
fi

# 4. Configurar ~/.bashrc
shopt -s histappend

if ! grep -cq "Configuración del historial de comandos" ~/.bashrc 2>/dev/null; then
    cat << 'EOF' >> ~/.bashrc

###########################################################
#     Configuración del historial de comandos 
#---------------------------------------------------------#
export HISTSIZE=10000
export HISTFILESIZE=-1
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
###########################################################
EOF
fi

# 5. Sincronizar historial
history -a

echo "=============================================================================="
echo " ¡PRECONDICIÓN COMPLETADA!"
echo " Por favor ejecute en su terminal para activar los cambios:"
echo " source ~/.bashrc && history -a"
echo "=============================================================================="