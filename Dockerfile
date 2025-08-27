ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

# Copy only the src directory
COPY src /src

# Build UI
RUN echo "Building frontend..." && \
    cd /src/StreamMaster.WebUI && \
    npm install && \
    npm run build && \
    cp -rpv dist/* ../StreamMaster.API/wwwroot/

# Build and publish API
RUN cd /src/StreamMaster.API && \
    dotnet restore "StreamMaster.API.csproj" -a $TARGETARCH --verbosity m && \
    dotnet publish "StreamMaster.API.csproj" -c Debug -o /app/publish /p:UseAppHost=false -a $TARGETARCH --verbosity m

# Verify the wwwroot directory contents
RUN ls -la /app/publish/wwwroot || true

# Clean up source files
RUN rm -rf /src
