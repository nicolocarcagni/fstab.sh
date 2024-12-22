######################################
# Created by github.com/nicolocarcagni
######################################

#!/bin/bash

# Funzione per mostrare i dischi collegati
display_disks() {
    echo "\nDischi disponibili:"
    lsblk -o NAME,MODEL,SIZE,FSTYPE,MOUNTPOINT | grep -v "\[SWAP\]"
    echo
}

# Funzione per selezionare un disco
select_disk() {
    echo "Inserisci il nome del disco (es: sda, sdb1):"
    read -r disk_name

    if [ -b "/dev/$disk_name" ]; then
        echo "\nHai selezionato: /dev/$disk_name"
    else
        echo "\nErrore: /dev/$disk_name non esiste. Riprova."
        select_disk
    fi

    echo "$disk_name"
}

# Funzione per scegliere un punto di montaggio
select_mount_point() {
    echo "\nInserisci il punto di montaggio desiderato (es: /mnt/disco):"
    read -r mount_point

    if [ ! -d "$mount_point" ]; then
        echo "\nLa directory $mount_point non esiste. Crearla? (s/n)"
        read -r create_dir

        if [[ "$create_dir" == "s" || "$create_dir" == "S" ]]; then
            sudo mkdir -p "$mount_point"
            echo "\nDirectory $mount_point creata."
        else
            echo "\nErrore: punto di montaggio non valido. Riprova."
            select_mount_point
        fi
    fi

    echo "$mount_point"
}

# Funzione per scegliere il formato del filesystem
select_filesystem() {
    echo "\nInserisci il formato della partizione (es: ext4, vfat, ntfs):"
    read -r filesystem

    if [[ -z "$filesystem" ]]; then
        echo "\nErrore: formato del filesystem non valido. Riprova."
        select_filesystem
    fi

    echo "$filesystem"
}

# Funzione per ottenere il UUID del disco
get_uuid() {
    local disk_name=$1
    uuid=$(sudo blkid -s UUID -o value "/dev/$disk_name")

    if [ -z "$uuid" ]; then
        echo "\nErrore: impossibile ottenere l'UUID per /dev/$disk_name. Assicurati che il disco abbia un filesystem valido."
        exit 1
    fi

    echo "$uuid"
}

# Funzione per aggiungere una voce a /etc/fstab
add_to_fstab() {
    local uuid=$1
    local mount_point=$2
    local filesystem=$3

    echo "\nUUID=$uuid $mount_point $filesystem defaults,nofail 0 2" | sudo tee -a /etc/fstab

    echo "\nLa voce è stata aggiunta a /etc/fstab. Provo a montare il disco..."
    sudo mount -a

    if mount | grep -q "$mount_point"; then
        echo "\nIl disco è stato montato correttamente su $mount_point."
    else
        echo "\nErrore: il disco non è stato montato correttamente. Controlla /etc/fstab."
    fi
}

# Script principale
echo "--- Script per configurare il montaggio dei dischi su Raspberry Pi OS ---"
display_disks

disk_name=$(select_disk)
mount_point=$(select_mount_point)
filesystem=$(select_filesystem)
uuid=$(get_uuid "$disk_name")

add_to_fstab "$uuid" "$mount_point" "$filesystem"
