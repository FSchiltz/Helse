# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Building the backend
WORKDIR /source

## copy and publish app and libraries for the backend
COPY ./Backend/Api .
RUN  dotnet publish -o /backend -c release

# Building the wep app
## Install flutter dependencies
RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 sed
RUN apt-get clean

## Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH "$PATH:/flutter/bin"   

## Run flutter doctor
RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --no-enable-android
RUN flutter config --no-enable-ios
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY ./App/ /app/
WORKDIR /app/
RUN flutter build web

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /app
## Copy the backend
COPY --from=build /backend ./
## Copy the webApp
COPY --from=build /app/build/web /app/wwwroot

EXPOSE 80

ENV DOTNET_EnableDiagnostics=0
ENTRYPOINT ["dotnet", "Api.dll"]