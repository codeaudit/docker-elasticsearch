FROM relateiq/oraclejava7

# elasticsearch
RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget ca-certificates

RUN mkdir /data /logs /elasticsearch

RUN wget --progress=dot:mega -O - https://s3-us-west-1.amazonaws.com/relateiq-build-resources/elasticsearch-1.1.2.tar.gz | tar -zx -C /elasticsearch --strip-components=1

RUN /elasticsearch/bin/plugin -u https://s3-us-west-1.amazonaws.com/relateiq-build-resources/elasticsearch-head.zip -install head
RUN /elasticsearch/bin/plugin -u https://s3-us-west-1.amazonaws.com/relateiq-build-resources/elasticsearch-bigdesk-v2.4.0.zip -install bigdesk
RUN /elasticsearch/bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/2.0.0
RUN /elasticsearch/bin/plugin -u https://github.com/downloads/jprante/elasticsearch-analysis-naturalsort/elasticsearch-analysis-naturalsort-1.0.0.zip -install analysis-naturalsort

RUN /elasticsearch/bin/plugin -u https://s3-us-west-1.amazonaws.com/relateiq-build-resources/elasticsearch-kopf-1.0.zip -install kopf
RUN /elasticsearch/bin/plugin -install polyfractal/elasticsearch-inquisitor
RUN /elasticsearch/bin/plugin -u https://s3-us-west-1.amazonaws.com/relateiq-build-resources/elasticsearch-paramedic.zip -install paramedic
RUN /elasticsearch/bin/plugin -u https://s3-us-west-1.amazonaws.com/relateiq-build-resources/royrusso-elasticsearch-HQ-14ac197.zip -install HQ

VOLUME [ "/logs", "/data" ]

EXPOSE 9200 9300

CMD ["/elasticsearch/bin/elasticsearch", "-f", "-D", "es.path.logs=/logs", "-D", "es.path.data=/data", "-D", "es.network.publish_host=127.0.0.1", "-D", "es.cluster.name=search-localhost" ]
