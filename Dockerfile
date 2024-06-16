FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/SuperService.csproj", "src/"]
RUN dotnet restore "src/SuperService.csproj"
COPY . .
WORKDIR "/src/src"
RUN dotnet build "SuperService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SuperService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SuperService.dll"]
