FROM public.ecr.aws/d3j8x8q7/olympus-base:latest

WORKDIR /app

# Copy application files (test.sh and test.patch excluded via .dockerignore)
COPY . /app

# Install system dependencies for development with pinned versions
RUN apt-get update && apt-get install -y \
    build-essential=12.9ubuntu3 \
    cmake=3.22.1-1ubuntu1 \
    git=1:2.34.1-1ubuntu1 \
    curl=7.81.0-1ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

# Set the default interactive shell as CMD
CMD ["bash"]
