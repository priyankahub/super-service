# Run unit tests
dotnet test src/SuperService.UnitTests/SuperService.UnitTests.csproj

# Build Docker image
docker build -t superservice:latest .

# Run Docker Compose
docker-compose up -d
