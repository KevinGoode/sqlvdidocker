# Multistage build
# First stage dosn't do anything. We just need to define as first from source so we can later copy some dlls out so we can link
FROM mcr.microsoft.com/mssql/server:2017-latest   
# Second build stage gets api files from git, local source files and binaries from previous image, puts them into build container and builds
FROM rsmmr/clang
WORKDIR ./src 
COPY * ./
COPY --from=0 /opt/mssql/lib/* ./
RUN apt-get -y  install curl && \
    /usr/bin/curl -LJO https://github.com/microsoft/sql-server-samples/raw/master/samples/features/sqlvdi-linux/vdi.h && \
    /usr/bin/curl -LJO https://github.com/microsoft/sql-server-samples/raw/master/samples/features/sqlvdi-linux/vdierror.h && \
    make

#Final build stage pulls our binary from build container and installs it in runtime docker container 
FROM mcr.microsoft.com/mssql/server:2017-latest  
COPY --from=1 ./src/vdidevice /opt/mssql/

