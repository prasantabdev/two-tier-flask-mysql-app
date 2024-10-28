#################  STAGE 1 ######################

#BASEIMAGE
FROM python:3.9 as builder

#WORK DIRECTORY
WORKDIR /app

#COPY REQUIREMENT.TXT
COPY requirements.txt .

#INSTALLPACKAGES
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

#INSTALL DEPENDENCIES
RUN pip install -r requirements.txt
RUN pip install mysqlclient
RUN pip install flask-mysqldb

######################## STAGE 2 #########################

FROM python:3.9-slim
WORKDIR /app
# Install runtime dependencies only
RUN apt-get update && \
    apt-get install -y --no-install-recommends libmariadb3 && \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY . .
CMD ["python","app.py"]


