FROM jenkins/jenkins:latest

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc.yml

USER root

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --verbose

COPY casc.yml /usr/share/jenkins/ref/casc.yml
COPY get-server-ip.sh /usr/share/jenkins/ref/get-server-ip.sh
RUN chmod +x /usr/share/jenkins/ref/get-server-ip.sh

# Switch to the appropriate directory for plugin installation
#WORKDIR /tmp

# Download Jenkins Plugin Manager
#RUN curl -O -L "https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.15/jenkins-plugin-manager-2.12.15.jar" 

# Run Jenkins Plugin Manager to install plugins
#RUN java -jar jenkins-plugin-manager-*.jar --plugin-download-directory /var/jenkins_home/plugins/ --plugin-file /tmp/plugins.txt --verbose

WORKDIR /var/jenkins_home

USER jenkins

ENTRYPOINT ["/bin/bash", "/usr/share/jenkins/ref/get-server-ip.sh"]

