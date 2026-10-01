DISCO=$(lsblk -d -n -o NAME,SIZE | awk '$2 ~ /10G/ {print $1}' | head -n 1)

if [ -z "$DISCO" ]; then
    echo "Error: No se encontró el disco de 10GB."
    exit 1
fi

DISCO_PATH="/dev/$DISCO"


sudo sfdisk "$DISCO_PATH" <<EOF
label: gpt
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
size=1G, type=Linux
EOF

PUNTOS_MONTAJE=(
  "/Examenes-UTN/alumno_1/parcial_1"
  "/Examenes-UTN/alumno_1/parcial_2"
  "/Examenes-UTN/alumno_1/parcial_3"
  "/Examenes-UTN/alumno_2/parcial_1"
  "/Examenes-UTN/alumno_2/parcial_2"
  "/Examenes-UTN/alumno_2/parcial_3"
  "/Examenes-UTN/alumno_3/parcial_1"
  "/Examenes-UTN/alumno_3/parcial_2"
  "/Examenes-UTN/alumno_3/parcial_3"
  "/Examenes-UTN/profesores"
)

for i in "${!PUNTOS_MONTAJE[@]}"; do
    PART_NUM=$((i + 1))
    PART_DEV="${DISCO_PATH}${PART_NUM}"
    MNT_DIR="${PUNTOS_MONTAJE[$i]}"

    sudo mkfs.ext4 -F "$PART_DEV"
    sudo mount "$PART_DEV" "$MNT_DIR"

    UUID=$(sudo blkid -s UUID -o value "$PART_DEV")
    echo "UUID=$UUID $MNT_DIR ext4 defaults 0 0" | sudo tee -a /etc/fstab
done
s