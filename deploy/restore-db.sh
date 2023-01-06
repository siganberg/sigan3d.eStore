#! /usr/bin/env bash
CONTAINER_NAME=sqlserver
DATABASE_NAME=eStore
BACKUP_NAME=$1
DB_PASSWORD=$2

if [ -z $CONTAINER_NAME ]
then
  echo "Usage: $0 [container name] [database name] [backup file name]"
  exit 1
fi

if [ -z $DATABASE_NAME ]
then
  echo "Usage: $0 [container name] [database name] [backup file name]"
  exit 1
fi

if [ -z $BACKUP_NAME ]
then
  echo "Usage: $0 [container name] [database name] [backup file name]"
  exit 1
fi

# Check if the backup file can be found
if [ ! -f $BACKUP_NAME ]
then
  echo "Backup file $BACKUP_NAME does not exist."
  exit 1
fi

# Set bash to exit if any command fails
set -e
set -o pipefail

FILE_NAME=$(basename $BACKUP_NAME)

echo "Copying backup file $BACKUP_NAME to container '$CONTAINER_NAME'. Note: the container should already be running!"

# Copy the file over to a special restore folder in the container, where the sqlcmd binary can access it
docker exec $CONTAINER_NAME mkdir -p /var/opt/mssql/restores
docker cp $BACKUP_NAME "$CONTAINER_NAME:/var/opt/mssql/restores/$FILE_NAME"

echo "Restoring database '$DATABASE_NAME' in container '$CONTAINER_NAME'..."

# Restore the database with sqlcmd
docker exec -it "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $DB_PASSWORD -Q "RESTORE DATABASE [$DATABASE_NAME] FROM DISK = N'/var/opt/mssql/restores/$FILE_NAME' WITH FILE = 1, NOUNLOAD, REPLACE, RECOVERY, STATS = 5"

echo ""
echo "Restored database '$DATABASE_NAME' in container '$CONTAINER_NAME' from file $BACKUP_NAME"
echo "Done!"