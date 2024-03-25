FROM jenkins/jenkins:latest

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc.yml

USER root

# Install required packages and cleanup
RUN apt-get update && \
    apt-get install -y wget less rsync && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "sleep 10"

# Install Ansible
RUN apt-get update && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "sleep 10"

# Install Terraform
RUN cd /tmp && \
    wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "sleep 10"

# Install AWS CLI
RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf /tmp/*

RUN /bin/bash -c "sleep 10"

# Copy Jenkins configurations
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --verbose

RUN /bin/bash -c "sleep 10"

COPY casc.yml /usr/share/jenkins/ref/casc.yml
COPY get-server-ip.sh /usr/share/jenkins/ref/get-server-ip.sh
RUN chmod +x /usr/share/jenkins/ref/get-server-ip.sh

RUN /bin/bash -c "sleep 10"

# Set Jenkins user and entrypoint
USER jenkins
WORKDIR /var/jenkins_home
ENTRYPOINT ["/bin/bash", "/usr/share/jenkins/ref/get-server-ip.sh"]

