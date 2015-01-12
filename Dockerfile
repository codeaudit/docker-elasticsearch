FROM relateiq/oraclejava7

# elasticsearch
RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget ca-certificates

RUN mkdir /data /logs /elasticsearch

RUN wget --progress=dot:mega -O - https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.6.tar.gz | tar -zx -C /elasticsearch --strip-components=1

RUN echo "script.disable_dynamic: false" >> /elasticsearch/config/elasticsearch.yml

RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head
RUN /elasticsearch/bin/plugin -install lukas-vlcek/bigdesk/2.4.0
RUN /elasticsearch/bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/2.3.2
RUN /elasticsearch/bin/plugin -install analysis-naturalsort -url http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-analysis-naturalsort/1.4.0.0/elasticsearch-analysis-naturalsort-1.4.0.0-plugin.zip
RUN /elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf
RUN /elasticsearch/bin/plugin -install polyfractal/elasticsearch-inquisitor
RUN /elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic
RUN /elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ
RUN /elasticsearch/bin/plugin -install elasticsearch/marvel/latest

VOLUME [ "/logs", "/data" ]

EXPOSE 9200 9300

CMD ["/elasticsearch/bin/elasticsearch", "-f", "-D", "es.path.logs=/logs", "-D", "es.path.data=/data", "-D", "es.network.publish_host=127.0.0.1", "-D", "es.cluster.name=search-localhost" ]
