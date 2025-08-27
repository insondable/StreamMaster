# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar la solución entera
COPY . .

# Restaurar dependencias apuntando al proyecto principal
RUN dotnet restore "src/StreamMaster.API/StreamMaster.API.csproj"

# Publicar en modo Release
WORKDIR /src/src/StreamMaster.API
RUN dotnet publish "StreamMaster.API.csproj" -c Release -o /app/publish

# Etapa runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "StreamMaster.API.dll"]
