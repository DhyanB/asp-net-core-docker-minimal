# ASP.NET Core and Docker

Minimal example on how to ship ASP.NET Core applications using Docker.

## Build the application

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

- Create the `Dockerfile` in `/aspnetcoredocker/`
- Open `/aspnetcoredocker/AspNetCoreDocker/Properties/launchSettings.json`and replace `localhost` by `0.0.0.0` in the `"applicationUrl`, so the container will listen to all IPv4 addresses. If this is set to `localhost`, you cannot access your application from outside the container. In a real world scenario you might want to override the port defined in `launchSettings.json` by means of external configuration, instead of having it in the application itself. Ways of doing this include setting `ENV ASPNETCORE_URLS http://0.0.0.0:49895` in the Dockerfile or passing parameters to `docker run`.
- Run `git add .`, `git commit` and `git push origin master`

## Build the Docker image

You can do this on any machine having Docker installed.

- Clone repository to `/aspnetcoredocker/`
- In a shell, navigate to `/aspnetcoredocker/`
- Run `docker build -t dhyanb/aspnetcoredocker:0.1 .` to build and tag a Docker image using the current folder as context. Replace `dhyanb` with your Docker username and `0.1` with any appropriate tag.
- Run `docker push dhyanb/aspnetcoredocker:0.1` to publish the image to a registry.

## Run anywhere

- Run `docker run -d -p 8080:49895 -t aspnetcoredocker:0.1` to create and run a container
- Run `curl 172.17.0.2:49895/api/values` (using the container's ip) or `curl 127.0.0.1:8080/api/values` (using one of the host's IP4v addresses) to test the application.

## Run in Azure

- Install Azure CLI (see https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- Create a resource group
- Create a container registry associated to that resource group
- Enable admin login to simplify exploration and testing, but use individual user credentials later on. See also: https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication.
- Use the CLI to login to the registry: `docker login <registryname>.azurecr.io`. When prompted for credentials use the admin user name and password.
