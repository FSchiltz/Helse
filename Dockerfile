# Build the backend on microsoft image
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Building the backend
WORKDIR /source

## copy and publish app and libraries for the backend
COPY ./Backend/ .
RUN  dotnet publish ./Api/Api.csproj -o /output -c release

# build the flutter web app 
# preparing the ubuntu container with all necessary tools
RUN apt update -y
RUN apt install -y bash curl file git unzip zip xz-utils libglu1-mesa

## Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH "$PATH:/flutter/bin"   

## Run flutter doctor
RUN flutter config --enable-web
RUN flutter doctor -v

# Copy files to container and build
RUN mkdir /app/
COPY ./flutter_frontend/ /app/
WORKDIR /app/
RUN flutter build web --release

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine
WORKDIR /app
## Copy the backend
COPY --from=build /output ./
## Copy the webApp
COPY --from=build /app/build/web /app/wwwroot

EXPOSE 8080

ENV DOTNET_EnableDiagnostics=0
ENTRYPOINT ["dotnet", "Api.dll"]
