# Pull down the latest SQL 2022 container image.
sudo docker pull mcr.microsoft.com/mssql/server:2022-latest

## Run the container
sudo docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<!Your Password Here!>" \
   -p 1433:1433 --name sql22 --hostname sql22 \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest

## Check container is running
docker ps