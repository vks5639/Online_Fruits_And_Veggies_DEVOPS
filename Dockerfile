FROM httpd:latest
COPY /home/ec2-user/EAPP/CI_CD_Pipeline_main /usr/local/apache2/htdocs/
RUN echo "This is a simple and easy env setup using docker"