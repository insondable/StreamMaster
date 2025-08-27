# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiamos todo el código de golpe
COPY . .

# Restaurar dependencias
RUN dotnet restore StreamMaster/StreamMaster.csproj

# Publicar
WORKDIR /src/StreamMaster
RUN dotnet publish "StreamMaster.csproj" -c Release -o /app/publish

# Etapa final (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "StreamMaster.dll"]
