FROM ubuntu:latest

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev git \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

WORKDIR /app/continuous-intelligence
RUN mkdir /app/continuous-intelligence/data

COPY requirements.txt /app/continuous-intelligence/
RUN cd /app/continuous-intelligence && pip3 install -r requirements.txt

CMD ["/app/continuous-intelligence/start.sh"]
