# SQLVDIDOCKER for Linux
This folder contains an example backup agent that uses the sql server vdi interface  
It is a modified version of :
https://github.com/microsoft/sql-server-samples/blob/master/samples/features/sqlvdi-linux
The addition here is a Dockerfile that:
1. Downloads the vdi header files and extracts the dependent shared libraries from the sqlserver docker container and puts them in a build container
2. Builds the vdidevice.cpp inside the build container
3. Extracts the vdidevice executable and installs it as an extra layer inside the sql-server-docker image
The original microsoft demo  device has only been modifed in two respects:
a.) The dependency on libuuid has been removed because the uuid is now hardcoded as DemoVDI-875af956-1255-49b5-95a1-2eace69d6eef
b.) The SQL backup/restore command is now not automatically executed.
(I feel demo works better if the SQL backup/restore command is executed outside of the vdidevice code which it would be in reality)  
## Files available
1.  ./src/vdidevice.cpp
2.  ./src/Makefile
2.  Dockerfile
## Known Bugs
Not a bug, but it is worth noting that the limitations of the demo (which would need addressing in a slightly improved demo) are:
1.) the vdi device still needs to be started inside the container (Need to check sqlserver process is running first though!)
2.) the vdi device exits after execution of a backup/restore job
## Steps

1. Install docker

2. Install sqlcmd

3. Build the docker image

   NOTE : Build container needs curl installed so if running behind a proxy forward local proxy settings in via  --build-arg
   Example: 
   ```bash
    docker build --build-arg http_proxy=$http_proxy --build-arg http_proxy=$https_proxy -t sqlserver2017-vdi:latest ./

   ```
   
4. Run the docker container
   
   ```bash
   docker run    -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=somepassword123' -p 1433:1433 -d sqlserver2017-vdi:latest
   ```

5. Create a db called exampledb (eg using Microsoft SQL Server Management Studio -
https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15#download-ssms)

6. Start (install) the vdidevice inside the container
	
   ```bash
   docker exec -it -e LD_LIBRARY_PATH=/opt/mssql/lib db1a8  /opt/mssql/vdidevice  B D exampledb sa somepassword123 /tmp/example.bak
   ```

7. Install sqlcmd (https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver15](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver15)
8. Execute a backup command
   ```bash
   sqlcmd -U sa -P somepassword123 -S . -Q "BACKUP DATABASE exampledb TO VIRTUAL_DEVICE='DemoVDI-875af956-1255-49b5-95a1-2eace69d6eef' WITH FORMAT, MAXTRANSFERSIZE=1048576 "

