# Use a base image with correct CUDA and cuDNN support
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubi8

# make this container run with the same user/group id as
# the opencast user on the host node to keep permissions correct
ARG USER_ID=1001
ARG GROUP_ID=1001
ARG USER=opencast

RUN groupadd --gid $GROUP_ID user
RUN useradd -u $GROUP_ID -g $USER_ID $USER

# Install necessary dependencies
RUN dnf install python38 -y && dnf clean all

# Install whisper-ctranslate2
RUN pip3 install --no-cache-dir -U whisper-ctranslate2

USER $USER

# run once to download model
COPY silent.mp3 /tmp
RUN whisper-ctranslate2 --model medium -o /tmp /tmp/silent.mp3

# Set the entry point
ENTRYPOINT ["whisper-ctranslate2"]
