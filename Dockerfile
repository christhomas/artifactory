FROM docker.bintray.io/jfrog/artifactory-pro:latest

COPY binarystore.xml /artifactory_extra_conf/binarystore.xml
COPY mysql-connector-java-8.0.17.jar /opt/jfrog/artifactory/tomcat/lib/

COPY custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

ENTRYPOINT ["/custom-entrypoint.sh"]