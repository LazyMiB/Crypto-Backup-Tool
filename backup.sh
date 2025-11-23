#!/usr/bin/env bash
if [ -z "$1" ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
  echo "./backup.sh /dir/to/backup"
  exit 0
fi
if ! [ -d "$1" ]; then
  echo "directory not found"
  exit 0
fi
name=$(basename "$1")
password=0

if [ -z "$PASSWORD" ]; then
  IFS= read -r -s -p "Enter password: " pwd_1
  echo ""
  IFS= read -r -s -p "Repeat password: " pwd_2
  echo ""
  if [ "$pwd_1" != "$pwd_2" ]; then
    echo "Error: passwords not equals. Exit."
    exit 0
  fi
  password="$pwd_1"
else
  password="$PASSWORD"
fi

echo "Generate hash'es..."

zip_pwd=$(echo -n "$password" | sha512sum | cut -f 1 -d " ")
gpg_pwd=$(echo "$zip_pwd" | sha512sum | cut -f 1 -d " ")

for i in {1..1000}; do
  zip_pwd=$(echo -n "$zip_pwd" | sha512sum | cut -f 1 -d " ")
  gpg_pwd=$(echo "$gpg_pwd" | sha512sum | cut -f 1 -d " ")
done

echo "Backuping..."

zip -P "$zip_pwd" -9 -r - "$1"| gpg --batch --passphrase "$gpg_pwd" -c > "$name".zip.gpg
echo "Done. Backup name: " "$name".zip.gpg
