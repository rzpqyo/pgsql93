#!/bin/bash

# touch /etc/sysconfig/network
if [[ ! -f /var/lib/postgresql/9.3/main/PG_VERSION ]]; then
	rm -f /var/lib/postgresql/9.3/main/postgresql.conf
	rm -f /var/lib/postgresql/9.3/main/pg_hba.conf
	chmod 700 /var/lib/postgresql/9.3/main
	chown -R postgres:postgres /var/lib/postgresql/9.3

	# service postgresql initdb
	su - postgres -c "/usr/lib/postgresql/9.3/bin/initdb --encoding=UTF-8 --no-locale -D /var/lib/postgresql/9.3/main"
	service postgresql start
	su - postgres -c "psql -w -c \"ALTER USER postgres encrypted password 'pas4pgsql'\""
	service postgresql stop
	cat <<EOF >>/var/lib/postgresql/9.3/main/postgresql.conf
listen_addresses = '*'
EOF
	cat <<EOF >/var/lib/postgresql/9.3/main/pg_hba.conf
local all all md5
host all all 0.0.0.0/0 md5
host all all ::1/128 md5
EOF
	su - postgres -c "mkdir -p -m 700 /usr/lib/postgresql/9.3/main/pg_log"
fi

if [[ -f /var/lib/postgresql/postgresql.conf ]]; then
	cp -p /var/lib/postgresql/postgresql.conf /var/lib/postgresql/9.3/main/postgresql.conf
	chmod 600 /var/lib/postgresql/9.3/main/postgresql.conf
	chown postgres:postgres /var/lib/postgresql/9.3/main/postgresql.conf
fi

service postgresql start

su - postgres -c "psql -f /usr/share/postgresql/9.3/contrib/textsearch_ja.sql -d testdb"

while [[ true ]]; do
	/bin/bash
done
