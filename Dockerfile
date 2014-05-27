FROM relateiq/oraclejava7

# elasticsearch
RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

RUN mkdir /data /logs /elasticsearch

RUN wget --progress=dot:mega -O - http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.6.tar.gz | tar -zx -C /elasticsearch --strip-components=1

RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head
RUN /elasticsearch/bin/plugin -install lukas-vlcek/bigdesk
RUN /elasticsearch/bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/1.9.0
RUN /elasticsearch/bin/plugin -u https://github.com/downloads/jprante/elasticsearch-analysis-naturalsort/elasticsearch-analysis-naturalsort-1.0.0.zip -install analysis-naturalsort

RUN /elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf
RUN /elasticsearch/bin/plugin -install polyfractal/elasticsearch-inquisitor
RUN /elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic
RUN /elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ

VOLUME [ "/logs", "/data" ]

EXPOSE 9200 9300

CMD ["/elasticsearch/bin/elasticsearch", "-f", "-D", "es.path.logs=/logs", "-D", "es.path.data=/data", "-D", "es.network.publish_host=127.0.0.1", "-D", "es.cluster.name=search-localhost" ]
