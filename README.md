- Build docker-image
```
docker build . -t siganberg/sigan3d-estore  
```
- Copy App_Data inside the folder of `deploy` or where relative to the location of the docker-compose file. 
- Then execute docker-compose. This will create SQL Database and eStore WebApp with pre-configured settings. 
```angular2html
docker-compose -f .\deploy\docker-compose.yaml -p sigan3d-estore up -d 
```
- To restore database run `restore-db.sh`
```angular2html
./deploy/restore-db.sh backups/2023-01-05_21-29-48.eStore.bak DB_PASSWORD
```
- To backup the database
```
./deploy/backup-db.sh DB_PASSWORD
```