FROM tutum/curl:trusty

COPY index.json /opt/
COPY data.json /opt/
COPY load_data.sh /opt/

RUN chmod +x /opt/load_data.sh

ENTRYPOINT ["/bin/bash", "/opt/load_data.sh"]

