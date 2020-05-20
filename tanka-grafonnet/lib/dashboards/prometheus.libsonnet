{
  grafanaDatasources+:: {
      'prometheus.yml': $.grafana_datasource('Prometheus', 'https://prometheus.demo.do.prometheus.io/', true),
  }
}
