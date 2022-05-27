FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app
COPY *.sln .
COPY src/OrchestratorService/*.csproj ./src/OrchestratorService/
COPY test/OrchestratorService.Tests/*.csproj ./test/OrchestratorService.Tests/
RUN dotnet restore

COPY . .
RUN dotnet build

FROM build AS testrunner
WORKDIR /app/test/OrchestratorService.Tests
CMD ["dotnet", "test", "--logger:trx"]

FROM build AS test
WORKDIR /app/test/OrchestratorService.Tests
RUN dotnet test --logger:trx

FROM build AS publish
WORKDIR /app/src/OrchestratorService
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=publish /app/src/OrchestratorService/out ./
EXPOSE 5000
ENTRYPOINT ["dotnet", "OrchestratorService.dll"]
