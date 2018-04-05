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
    - Run `Ctrl + C to stop the app`
- Create the `Dockerfile`
- Open `/aspnetcoredocker/AspNetCoreDocker/Properties/launchSettings.json`and replace `localhost` by `0.0.0.0` in the `"applicationUrl`, so the container will listen to all IPv4 addresses. If this is set to `localhost`, you cannot access your application from outside the container. In a real world scenario you might want to override the port defined in `launchSettings.json` by providing external configuration to the container, instead of hard coding the port into the Docker image. One way of doing this is to set `ENV ASPNETCORE_URLS http://0.0.0.0:49895` in the Dockerfile.
- Run `git add .`, `git commit` and `git push origin master`
- On any (remote) machine having Docker installed
    - Clone repository to `/aspnetcoredocker/`
    - In a shell, navigate to `/aspnetcoredocker/`
    - Run `docker build -t aspnetcoredocker:0.1 .` to build the Docker image
    - Run `docker images` to view all existing images
    - Run `docker run -d -p 8080:49895 -t aspnetcoredocker:0.1` to create and run a container instance of the image
    - Run `curl 172.17.0.2:49895/api/values` to test the app using the container's ip
    - Run `curl localhost:8080/api/values` to test the app using the host address
