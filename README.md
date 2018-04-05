# ASP.NET Core and Docker

Minimal example on how to ship ASP.NET Core applications using Docker.

Steps to recreate this setup:

- Create empty repository \aspnetcoredocker\
- Clone repository to \aspnetcoredocker\
- Add .NET specific .gitignore file to filter out Visual Studio temp files, build results, boilerplate etc.
- Open Visual Studio
- Create new project
-- Project type: ASP.NET Core API
-- Project name: "AspNetCoreDocker"
-- Project location: \aspnetcoredocker\ (uncheck "create solution folder" to use the existing repo folder)
- Close Visual Studio
- Open shell and navigate to \aspnetcoredocker\
- Run "dotnet restore" and "dotnet build"
- Navigate to \aspnetcoredocker\AspNetCoreDocker\
- Run "dotnet run"
- Open http://localhost:49895/api/values in browser to verify all is working fine (replace port)
- Run "git add .", "git commit" and "git push origin master"