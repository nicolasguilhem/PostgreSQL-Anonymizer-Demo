# ajout du dépôt dalibo
echo deb http://apt.dalibo.org/labs $(lsb_release -cs)-dalibo main > /etc/apt/sources.list.d/dalibo-labs.list
curl -fsSL -o /etc/apt/trusted.gpg.d/dalibo-labs.gpg https://apt.dalibo.org/labs/debian-dalibo.gpg

# installation postgresql-anonymizer
apt update && apt install postgresql_anonymizer_17
