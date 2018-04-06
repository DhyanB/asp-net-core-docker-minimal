# ASP.NET Core and Docker

Minimal example on how to ship ASP.NET Core applications using Docker.

## Build the example application

You can do this on any machine having .NET Core and Visual Studio installed.

- Create empty remote repository `/aspnetcoredocker/`
- Clone repository to `/aspnetcoredocker/`
- Add .NET specific .gitignore file to filter out Visual Studio temp files, build results, boilerplate etc.
- Open Visual Studio
- Create new project
    - Project type: ASP.NET Core API
    - Project name: "AspNetCoreDocker"
    - Project location: `/aspnetcoredocker/` (uncheck "create solution folder" to use the existing repo folder)
- Close Visual Studio
- Verify that the app is working
    - Open shell and navigate to `/aspnetcoredocker/`
    - Run `dotnet restore` and `dotnet build`
    - Navigate to `/aspnetcoredocker/AspNetCoreDocker/`
    - Run `dotnet run`
    - Open http://localhost:49895/api/values in a browser to verify all is working fine
    - Run `Ctrl + C` to stop the app
    
## Dockerize the application

- Create the `Dockerfile` in `/aspnetcoredocker/`, use Microsofts `aspnetcore` Docker image from https://hub.docker.com/r/microsoft/aspnetcore/
- Open `/aspnetcoredocker/AspNetCoreDocker/Properties/launchSettings.json`and replace `localhost` by `0.0.0.0` in the `"applicationUrl`, so the container will listen to all IPv4 addresses. If this is set to `localhost`, you cannot access your application from outside the container. In a real world scenario you might want to override the port defined in `launchSettings.json` by means of external configuration, instead of having it in the application itself. Ways of doing this include setting `ENV ASPNETCORE_URLS http://0.0.0.0:49895` in the Dockerfile or passing parameters to `docker run`.
- Run `git add .`, `git commit` and `git push origin master`

## Build the Docker image

You can do this on any machine having Docker installed.

- Clone repository to `/aspnetcoredocker/`
- In a shell, navigate to `/aspnetcoredocker/`
- Run `docker build -t dhyanb/aspnetcoredocker:0.5 .` to build and tag a Docker image using the current folder as context. Replace `dhyanb` with your registry username and `0.5` with the current version.
- Run `docker push dhyanb/aspnetcoredocker:0.5` to publish the image to a registry (Docker Hub in this case).

## Run anywhere

- Run `docker pull dhyanb/aspnetcoredocker` to fetch the image from the registry
- Run `docker run -d -p 8080:49895 -t aspnetcoredocker:0.5` to create and run a container
- Run `curl 172.17.0.2:49895/api/values` (using the container's ip) or `curl 127.0.0.1:8080/api/values` (using one of the host's IP4v addresses) to test the application.

## Run in Azure

Summary from https://docs.microsoft.com/en-us/azure/container-instances/container-instances-tutorial-prepare-acr.

### Push image to registry

- Install Azure CLI (see https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- Create a resource group called `docker-test-rg`
- Create a container registry associated to that resource group
- Enable admin login to simplify exploration and testing, but use individual user credentials later on. See also: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication.
- Use the CLI to login to the registry: `docker login <registryname>.azurecr.io`. When prompted for credentials use the admin user name and password.
- Tag the existing image with the loginServer of your container registry: `docker tag aspnetcoredocker:0.5 <registryname>.azurecr.io/aspnetcoredocker:0.5`
- Push the image to the registry: `docker push <registryname>.azurecr.io/aspnetcoredocker:0.5`

### Create a container instance

See also: https://docs.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest#az-container-create

- Create a container instance named `aspnetdocker` from the registry image and set a DNS name label: `az container create -g "docker-test-rg" -n "aspnetdocker" --image "<registryname>.azurecr.io/aspnetcoredocker:0.5" --dns-name-label "aspnetdockerdemo" --ports 80 -l "westus"`
- Check that container is running: `az container logs -g "docker-test-rg" -n "aspnetdocker"`
- Output should look like this:
    ```
    Using launch settings from /app/AspNetCoreDocker/Properties/launchSettings.json...
    warn: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[35]
        No XML encryptor configured. Key {88888888-4444-4444-4444-121212121212} may be persisted to storage in unencrypted form.
    Hosting environment: Development
    Content root path: /app/AspNetCoreDocker
    Now listening on: http://0.0.0.0:49895
    Application started. Press Ctrl+C to shut down.
    ```
- Use `az container show -g "docker-test-rg" -n "aspnetdocker"` to show the container's properties and its FQDN. In my case the FQDN was `aspnetdockerdemo.westus.azurecontainer.io`.
- Use `az container exec -g "docker-test-rg" -n "aspnetdocker" --exec-command "/bin/bash"` do open a shell in the container
- Use `ip a` to find out the internal IPv4 address, e.g. `10.244.83.2`
- Test the application using `curl 10.244.83.2:49895/api/values`
- [OPEN-ISSUE] Find out how to access the container and its application from the outside
