FROM mysql:8.0.38-debian

RUN apt update && apt install -y unzip wget
