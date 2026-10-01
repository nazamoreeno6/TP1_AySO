REPO_DIR=$(git rev-parse --show-toplevel 2>/dev/null)
RTA_DIR=$(find "$REPO_DIR" -type d -name "RTA_ARCHIVOS_Examen_*" | head -n 1)

if [ -z "$RTA_DIR" ]; then
    RTA_DIR="${REPO_DIR}/RTA_ARCHIVOS_Examen_"
    mkdir -p "$RTA_DIR"
fi

IP_PUB=$(curl -s ifconfig.me)
USUARIO=$(whoami)
HASH_PASS=$(sudo grep "^${USUARIO}:" /etc/shadow | cut -d: -f2)
REPO_URL=$(git remote get-url origin)

cat <<EOF > "$RTA_DIR/Filtro_Avanzado.txt"
Mi IP Publica es: $IP_PUB
Mi usuario es: $USUARIO
El Hash de mi Usuario es: $HASH_PASS
La URL de mi repositorio es: $REPO_URL
EOF