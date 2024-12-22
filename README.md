# Script per Configurare il Montaggio Automatico dei Dischi su Raspberry Pi OS

Questo script ti permette di selezionare un disco collegato al Raspberry Pi, scegliere un punto di montaggio e aggiungere una voce al file `/etc/fstab` per montare automaticamente il disco all'avvio. Puoi anche specificare il formato del filesystem del disco.

## Requisiti

- Raspberry Pi OS (o una distribuzione Linux compatibile).
- Privilegi di amministratore (sudo).
- Un disco o una partizione collegata al Raspberry Pi.

## Installazione

1. Clona o copia lo script nel tuo sistema.
2. Salva il file con il nome `mount_disk.sh` (o un altro nome a tua scelta).

## Uso

### 1. Rendere eseguibile lo script
Rendi eseguibile lo script con il seguente comando:
```bash
chmod +x mount_disk.sh
```

### 2. Eseguire lo script
Esegui lo script con privilegi di superutente:
```bash
sudo ./mount_disk.sh
```

### 3. Seguire le istruzioni
Lo script ti guiderà attraverso i seguenti passaggi:

1. Mostra un elenco dei dischi collegati.
2. Chiede di selezionare il disco da configurare (es: `sda`, `sdb1`).
3. Richiede il punto di montaggio (es: `/mnt/disco`).
   - Se la directory non esiste, ti chiederà se desideri crearla.
4. Chiede di specificare il formato del filesystem (es: `ext4`, `vfat`, `ntfs`).
5. Recupera l'UUID del disco selezionato.
6. Aggiunge una voce al file `/etc/fstab` per montare automaticamente il disco all'avvio.
7. Prova a montare il disco immediatamente per verificare che tutto funzioni correttamente.

### 4. Verifica
Dopo l'esecuzione dello script, il disco selezionato dovrebbe essere montato automaticamente sul punto di montaggio specificato.
Puoi verificare il montaggio con:
```bash
mount | grep <punto_di_montaggio>
```

## Note
- Assicurati di selezionare il formato del filesystem corretto per evitare errori.
- Controlla il file `/etc/fstab` in caso di problemi:
  ```bash
  sudo nano /etc/fstab
  ```
- Se il disco non viene montato correttamente, prova a rieseguire lo script o controlla i log di sistema:
  ```bash
  dmesg | tail
  ```

## Avvertenze
- Usa questo script con attenzione per evitare modifiche errate a `/etc/fstab`, che potrebbero impedire l'avvio del sistema.
- Esegui sempre un backup del file `/etc/fstab` prima di modifiche:
  ```bash
  sudo cp /etc/fstab /etc/fstab.backup
  ```

## Licenza
Questo script è fornito "così com'è" senza garanzie. Usalo a tuo rischio e pericolo.

