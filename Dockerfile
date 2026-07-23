FROM public.ecr.aws/d3j8x8q7/olympus-base:latest

WORKDIR /app

# Copy application files (excluding test.sh and test.patch)
COPY . /app

# Install system dependencies for development
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set the default interactive shell as CMD
CMD ["bash"]
