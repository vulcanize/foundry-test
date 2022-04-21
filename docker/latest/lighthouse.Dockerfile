FROM sigp/lighthouse:latest-modern

RUN apt-get update; apt-get install bash netcat curl less jq -y;

WORKDIR /root/
ADD start-up-files/lighthouse/start-lighthouse.sh .

ENTRYPOINT [ "./start-lighthouse.sh" ]