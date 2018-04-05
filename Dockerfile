FROM microsoft/dotnet:latest
COPY . /app
WORKDIR /app
 
RUN ["dotnet", "restore"]
RUN ["dotnet", "build"]

WORKDIR /app/AspNetCoreDocker
 
EXPOSE 49895/tcp
 
ENTRYPOINT ["dotnet", "run"]