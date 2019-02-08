FROM python:3.6.6-windowsservercore-ltsc2016

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
RUN Invoke-WebRequest 'https://github.com/git-for-windows/git/releases/download/v2.19.0.windows.1/MinGit-2.19.0-64-bit.zip' -OutFile C:\MinGit.zip

RUN Expand-Archive C:\MinGit.zip -DestinationPath C:\MinGit
RUN $env:PATH = $env:PATH + ';C:\MinGit\cmd\;C:\MinGit\cmd'

WORKDIR /app/continuous-intelligence
RUN mkdir C:\app\continuous-intelligence\data

COPY requirements.txt C:\app\continuous-intelligence\
RUN cd C:\app\continuous-intelligence && pip install -r requirements.txt

CMD ["C:\app\continuous-intelligence\start.bat"]
