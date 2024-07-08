
upload_recursive() {
    local base_dir=$1
    local target_dir=$2

    # Hochladen der Dateien im aktuellen Verzeichnis
    cat <<EOF >> temp.txt
cd $target_dir
lcd $base_dir
mput *
EOF

    # Durchlaufen der Unterverzeichnisse
    for dir in "$base_dir"/*; do
        if [ -d "$dir" ]; then
            local sub_dir_name=$(basename "$dir")
            # Erstellen des Verzeichnisses auf dem FTP-Server
            cat <<EOF >> temp.txt
mkdir $target_dir/$sub_dir_name
EOF
            # Rekursiver Aufruf für das Unterverzeichnis
            upload_recursive "$dir" "$target_dir/$sub_dir_name"
        fi
    done
}
# $1 = Server, $2 = Port, $3 = Username, $4 = Password, $5 = lokaler Pfad, $6 = remote Pfad

HOST=$1
PORT=$2
USER=$3
PASSWD=$4
LOCAL_PATH=$5
REMOTE_PATH=$6

if [ -z "$HOST" ]
then
  echo "Bitte geben Sie den Server ein:"
  read HOST
fi

if [ -z "$PORT" ]
then
  echo "Bitte geben Sie den Port ein:"
  read PORT
fi

if [ -n "$PORT" ]
then
  SERVER="$HOST:$PORT"
else
  SERVER="$HOST"
fi

if [ -z "$USER" ]
then
  echo "Bitte geben Sie den Benutzernamen ein:"
  read USER
fi

if [ -z "$PASSWD" ]
then
  echo "Bitte geben Sie das Passwort ein:"
  read -s PASSWD
fi

if [ -z "$LOCAL_PATH" ]
then
  echo "Bitte geben Sie den lokalen Pfad ein:"
  read LOCAL_PATH
fi

if [ -z "$REMOTE_PATH" ]
then
  echo "Bitte geben Sie den Remote-Pfad ein:"
  read REMOTE_PATH
fi

cat <<END_SCRIPT > temp.txt
open "$SERVER" "$PORT"
user "$USER" "$PASSWD"
binary
END_SCRIPT

upload_recursive "$LOCAL_PATH" "$REMOTE_PATH"
cat "quit" >> temp.txt

ftp -n < temp.txt
rm temp.txt
exit 0

