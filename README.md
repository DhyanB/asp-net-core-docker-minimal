# ASP.NET Core and Docker

Minimal example on how to ship ASP.NET Core applications using Docker.

Steps to recreate this setup:

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
- Create the `Dockerfile` in `/aspnetcoredocker/`
- Open `/aspnetcoredocker/AspNetCoreDocker/Properties/launchSettings.json`and replace `localhost` by `0.0.0.0` in the `"applicationUrl`, so the container will listen to all IPv4 addresses. If this is set to `localhost`, you cannot access your application from outside the container. In a real world scenario you might want to override the port defined in `launchSettings.json` by means of external configuration, instead of having it in the application itself. Ways of doing this include setting `ENV ASPNETCORE_URLS http://0.0.0.0:49895` in the Dockerfile or passing parameters to `docker run`.
- Run `git add .`, `git commit` and `git push origin master`
- On any (remote) machine having Docker installed
    - Clone repository to `/aspnetcoredocker/`
    - In a shell, navigate to `/aspnetcoredocker/`
    - Run `docker build -t dhyanb/aspnetcoredocker:0.1 .` to build the Docker image (replace `dhyanb` and `0.1` with your Docker username and a current version or other appropriate image tag)
    - Run `docker run -d -p 8080:49895 -t aspnetcoredocker:0.1` to create and run a container (i.e. an instance of the image)
    - Run `curl 172.17.0.2:49895/api/values` to test the app using the container's ip
    - Run `curl 127.0.0.1:8080/api/values` to test the app using one of the host's IP4v addresses
