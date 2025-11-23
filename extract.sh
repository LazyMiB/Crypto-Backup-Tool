#!/usr/bin/env bash
if [ -z "$1" ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
  echo "./extract.sh backup.zip.gpg /dir/to/extract"
  exit 0
fi
if ! [ -f "$1" ]; then
  echo "file not exists"
  exit 0
fi
if ! [ -d "$2" ]; then
  mkdir -p "$2"
fi

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

echo "Generate hashes..."

zip_pwd=$(echo -n "$password" | sha512sum | cut -f 1 -d " ")
zip_pwd=$(echo "$zip_pwd" $(echo -n "$password") "$zip_pwd" | sha512sum | cut -f 1 -d " ")
gpg_pwd=$(echo "$zip_pwd" $(echo -n "$password") "$zip_pwd"  | sha512sum | cut -f 1 -d " ")

for i in {1..1000}; do
  zip_pwd=$(echo "$zip_pwd" "$gpg_pwd" | sha512sum | cut -f 1 -d " ")
  gpg_pwd=$(echo "$gpg_pwd" "$zip_pwd" | sha512sum | cut -f 1 -d " ")
done

echo "Decrypting to '.tmp.zip' ..."

gpg --batch --passphrase "$gpg_pwd" -d "$1" > .tmp.zip
echo "Extracting..."
unzip -P "$zip_pwd" -d "$2" -o ".tmp.zip"
echo "Remove '.tmp.zip' ..."
rm ".tmp.zip"
echo "Done. Extracted path: " "$2"
