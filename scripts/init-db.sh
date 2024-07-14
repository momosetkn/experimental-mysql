wget 'http://downloads.mysql.com/docs/sakila-db.zip'
unzip -o sakila-db.zip 1>/dev/null
mysql -u root -Ptest < sakila-db/sakila-schema.sql
mysql -u root -Ptest < sakila-db/sakila-data.sql

echo "sakila-db-import complete."
