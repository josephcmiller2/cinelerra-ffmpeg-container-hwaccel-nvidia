# Cinelerra FFmpeg Container with Hardware Acceleration (NVIDIA)

## Overview

This repository contains the configuration and setup needed to use Cinelerra (a free and open-source video editing software) with FFmpeg configured for NVIDIA hardware acceleration. The FFmpeg configuration uses the NVIDIA Codec SDK, enabling faster encoding/decoding processes, better performance, and lower CPU usage during video editing tasks.

## Requirements

To use this repository, you'll need:

- Linux OS
- Docker and Docker-compose or podman installed
- NVIDIA GPU (Compute Capability 3.0 and higher)
- The latest NVIDIA driver installed (470.xx and above recommended)
- Basic knowledge of Docker operations

## Setup

1. Clone the repository:
   ```
   git clone https://github.com/josephcmiller2/cinelerra-ffmpeg-container-hwaccel-nvidia.git
   ```

2. Navigate to the directory:
   ```
   cd cinelerra-ffmpeg-container-hwaccel-nvidia
   ```

3. Configure and build with podman:
   ```
   ./configure
   make
   ```

4. Start the container:
   ```
   ./run.sh
   ```

## Usage

After you have the container up and running, you can start using Cinelerra with hardware-accelerated FFmpeg.

1. Access the running Docker container:
   ```
   ./run.sh
   ```

2. Start Cinelerra:
   ```
   cinelerra
   ```

3. Run ffmpeg
   ```
   ffmpeg [OPTIONS]
   ```

## Updates

To update Cinelerra and FFmpeg to their latest versions:

1. Stop the running Docker container:
   ```
   docker-compose down
   ```

2. Pull the latest changes from the repository:
   ```
   git pull
   ```

3. Rebuild the Docker image:
   ```
   docker-compose build
   ```

4. Start the Docker container:
   ```
   docker-compose up -d
   ```

## Troubleshooting

If you face any issues while setting up or using the container, feel free to create an issue in the GitHub repository. Please include as many details as possible in your report, including the exact error message, steps you've taken, and your system specifications.

## Contributing

If you would like to contribute to the project, please fork the repository, make your changes, and submit a pull request. We appreciate any contributions that improve the functionality and usability of the project.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgements

Thanks to the Cinelerra team for creating an excellent open-source video editing software and the FFmpeg team for their amazing work on the multimedia framework. Special thanks to NVIDIA for providing the tools and SDKs for hardware-accelerated video encoding/decoding. Thanks to ChatGPT 4 for creating this README.

---

**Note:** This repository is not affiliated with, endorsed by, or sponsored by Cinelerra, FFmpeg, or NVIDIA.

