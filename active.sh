#!/usr/bin/env bash

set -e

HOME_SOURCE="$(findmnt -n -o SOURCE /home)"
ROOT_SOURCE="$(findmnt -n -o SOURCE /)"
HOME_FSTYPE="$(findmnt -n -o FSTYPE /home)"

echo "ROOT : $ROOT_SOURCE"
echo "HOME : $HOME_SOURCE"
echo "FS   : $HOME_FSTYPE"
echo ""

# =====================================================
# VALIDAR /home
# =====================================================

if [[ "$HOME_FSTYPE" == "ext4" && "$HOME_SOURCE" != "$ROOT_SOURCE" ]]; then
    echo "Activando EXT4 kernel quota."
    sudo umount /home
    sudo tune2fs -O quota "$HOME_SOURCE"
    echo "OK"
fi

echo ""
echo "Ejecutando e2fsck..."
sudo e2fsck -f "$HOME_SOURCE"
echo ""
echo "Verificando feature..."
sudo tune2fs -l "$HOME_SOURCE" | grep quota
sudo mount /home
echo ""
echo "==========================================="
echo " COMPLETADO"
echo "==========================================="
