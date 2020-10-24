FROM httpd:latest
COPY . /usr/local/apache2/htdocs/
RUN echo "This is a simple and easy env setup using docker"