# Jerkin Image as a Base Image
FROM jenkins/jenkins:lts

# Switching to user root to install the dependencies
USER root

# Installing pre-requisites and Docker
RUN apt-get update -y && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian bullseye stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update -y && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean

# Add Jenkins user to the Docker Group (Only Create if it doesn't exist)
RUN groupadd -f docker && \
    usermod -aG docker jenkins

# Creating Docker Directory and volumne for DinD
RUN mkdir -p /var/lib/docker
VOLUME /var/lib/docker

# Switch back to the Jenkins user
USER jenkins