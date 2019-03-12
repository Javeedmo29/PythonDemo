# Use an official Python runtime as a parent image
FROM python:3.6.8-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY djangoproject /app/djangoproject
COPY posts	 /app/posts
COPY manage.py /app
COPY requirements.txt /app



RUN apt-get update && apt-get -y install ca-certificates
ADD https://get.aquasec.com/microscanner /
RUN chmod +x /microscanner
ARG token
RUN /microscanner ${OWIzMTA5NTYwMmE0}
RUN echo "No vulnerabilities!"


RUN curl https://github.com/Arachni/arachni/releases/download/v1.5.1/${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf ${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    mv ${ARACHNI_VERSION}/ /usr/local/arachni && \
    rm -rf *.tar.gz

COPY "$PWD"/files /
EXPOSE 22 7331 9292


# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

	
# Make port 80 available to the world outside this container
EXPOSE 8000

# Define environment variable

# Run app.py when the container launches
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

#CMD ["sleep", "45m"]
