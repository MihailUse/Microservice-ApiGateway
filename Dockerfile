FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source
EXPOSE 80
EXPOSE 443

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ApiGatewayMicroservice/*.csproj ./ApiGatewayMicroservice/
RUN dotnet restore

# copy everything else and build app
COPY ApiGatewayMicroservice/. ./ApiGatewayMicroservice/
WORKDIR /source/ApiGatewayMicroservice
RUN dotnet publish -c release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ApiGatewayMicroservice.dll"]
