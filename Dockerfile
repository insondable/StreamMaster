# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar primero los .csproj (mejora el cache en Docker)
COPY StreamMaster/StreamMaster.csproj StreamMaster/
COPY StreamMaster.Domain/StreamMaster.Domain.csproj StreamMaster.Domain/
COPY StreamMaster.Infrastructure/StreamMaster.Infrastructure.csproj StreamMaster.Infrastructure/
COPY StreamMaster.Application/StreamMaster.Application.csproj StreamMaster.Application/
COPY StreamMaster.Playlists/StreamMaster.Playlists.csproj StreamMaster.Playlists/
COPY StreamMaster.SchedulesDirect/StreamMaster.SchedulesDirect.csproj StreamMaster.SchedulesDirect/
COPY StreamMaster.Streams/StreamMaster.Streams.csproj StreamMaster.Streams/
COPY StreamMaster.Web/StreamMaster.Web.csproj StreamMaster.Web/

# Restaurar dependencias
RUN dotnet restore StreamMaster/StreamMaster.csproj

# Copiar el resto del código
COPY . .

# Publicar la aplicación principal
WORKDIR /src/StreamMaster
RUN dotnet publish "StreamMaster.csproj" -c Release -o /app/publish

# Etapa final (runtime)
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "StreamMaster.dll"]

