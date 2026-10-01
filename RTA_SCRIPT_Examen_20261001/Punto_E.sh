REPO_DIR=$(git rev-parse --show-toplevel 2>/dev/null)
RTA_DIR=$(find "$REPO_DIR" -type d -name "RTA_ARCHIVOS_Examen_*" | head -n 1)

if [ -z "$RTA_DIR" ]; then
    RTA_DIR="${REPO_DIR}/RTA_ARCHIVOS_Examen_"
    mkdir -p "$RTA_DIR"
fi

grep MemTotal /proc/meminfo > "$RTA_DIR/Filtro_Basico.txt"
sudo dmidecode -t chassis | grep -E "Chassis Information|Manufacturer:" >> "$RTA_DIR/Filtro_Basico.txt"