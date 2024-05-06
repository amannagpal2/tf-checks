FROM tomcat:8.0.20-jre8
COPY target/Example-0.0.1-SNAPSHOT.war /home/runner/work/Hello_World_v1/Hello_World_v1/src/main/webapp/sample.war
