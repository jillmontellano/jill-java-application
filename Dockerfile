FROM tomcat:8.5
MAINTAINER Tung Nguyen <tongueroo@gmail.com>

# Debugging tools: A few ways to handle debugging tools.
# Trade off is a slightly more complex volume mount vs keeping the image size down.
RUN apt-get update && \
  apt-get install -y \
    net-tools \
    tree \
    vim \
    wget && \
  mkdir /node_exporter && \
  cd /node_exporter && \
  wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz && \
  tar -xzvf node_exporter-0.17.0.linux-amd64.tar.gz && \
  ls && \
  cd node_exporter-0.17.0.linux-amd64 && \
  rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get purge

RUN echo "export JAVA_OPTS=\"-Dapp.env=staging\"" > /usr/local/tomcat/bin/setenv.sh
COPY pkg/demo.war /usr/local/tomcat/webapps/demo.war

COPY node_exporter.sh /node_exporter.sh

EXPOSE 8080 9100
CMD ["catalina.sh", "run"]
CMD ["node_exporter.sh"]