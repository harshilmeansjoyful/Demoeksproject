FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app


FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
# Copy everything else and build

# Copy csproj and restore as distinct layers
COPY *.csproj ./
COPY . ./
RUN dotnet restore dotnet-example.csproj
COPY . .
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/out

FROM base AS final
WORKDIR /app
COPY --from=publish /app/out .
ENTRYPOINT ["dotnet", "dotnet-example.dll"]
