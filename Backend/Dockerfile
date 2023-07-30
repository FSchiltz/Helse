# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build

RUN apk add --update npm
WORKDIR /source

# copy and publish app and libraries
COPY ./Api .
RUN  dotnet publish -o /app -c release

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app
COPY --from=build /app ./

EXPOSE 80

ENV DOTNET_EnableDiagnostics=0
ENTRYPOINT ["dotnet", "Api.dll"]