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

password=$(echo -n "$password")
echo "Generate hashes..."

zip_pwd=$(echo -n "$password" | sha512sum | cut -f 1 -d " ")
zip_pwd=$(echo "$zip_pwd" "$password" "$zip_pwd" | sha512sum | cut -f 1 -d " ")
gpg_pwd=$(echo "$zip_pwd" "$password" "$zip_pwd" "$password"  | sha512sum | cut -f 1 -d " ")
scr_pwd=$(echo "$zip_pwd" "$password" "$gpg_pwd")

for i in {1..1000}; do
  zip_pwd=$(echo "$zip_pwd" "$password" "$gpg_pwd" "$scr_pwd" | sha512sum | cut -f 1 -d " ")
  gpg_pwd=$(echo "$scr_pwd" "$gpg_pwd" "$password" "$zip_pwd" | sha512sum | cut -f 1 -d " ")
  if [ "$2" = "-s" ]; then
    scr_pwd=$(echo "$scr_pwd" "$zip_pwd" "$password" "$gpg_pwd" | sha512sum | cut -f 1 -d " ")
  fi
done

echo "Backuping..."

if [ "$2" = "-s" ]; then
  export scrypt_pwd=$scr_pwd
  zip -P "$zip_pwd" -9 -r - "$1" \
    | gpg --s2k-digest-algo SHA512 --s2k-count 65011712 --s2k-cipher-algo AES256 --batch --passphrase "$gpg_pwd" -c \
    | scrypt enc --passphrase "env:scrypt_pwd" - "$name".zip.gpg.scrypt
  unset scrypt_pwd
  echo "Done. Backup name: " "$name".zip.gpg.scrypt
else
  zip -P "$zip_pwd" -9 -r - "$1" \
    | gpg --s2k-digest-algo SHA512 --s2k-count 65011712 --s2k-cipher-algo AES256 --batch --passphrase "$gpg_pwd" -c \
    > "$name".zip.gpg
  echo "Done. Backup name: " "$name".zip.gpg
fi
