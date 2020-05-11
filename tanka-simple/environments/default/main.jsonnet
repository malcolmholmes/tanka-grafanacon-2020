local k = import 'ksonnet-util/kausal.libsonnet';

k + {
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,
  local mount = container.volumeMountsType,
  local volume = $.core.v1.volume,
  local service = $.core.v1.service,
  local servicePort = $.core.v1.servicePort,
  local configMap = $.core.v1.configMap,

  _config+:: {
    replicas: 1,
  },

  _images+:: {
    grafana: 'grafana/grafana',
  },

  grafana_configmap: configMap.new('grafana-config')
    + configMap.withData({
      'dashboards.yaml': importstr 'files/dashboards.yaml',
      'dashboard.json': importstr 'files/dashboard.json',
      'grafana.ini': importstr 'files/grafana.ini',
    })
    ,

  local grafana_container = container.new('grafana', $._images.grafana)
    + container.withPorts(containerPort.new('http', 3000))
    + container.withEnvMap({GF_PATHS_CONFIG: '/etc/grafana-config/grafana.ini'})
    ,

  grafana_deployment: deployment.new('grafana', $._config.replicas, grafana_container, {})
    + $.util.configVolumeMount('grafana-config', '/etc/grafana/provisioning/dashboards')
    + $.util.configVolumeMount('grafana-config', '/etc/grafana-config')
    ,

  grafana_service: $.util.serviceFor(self.grafana_deployment)
    + service.mixin.spec.withPortsMixin(servicePort.newNamed(name='http', port=80, targetPort=3000))
    + service.mixin.spec.withType('LoadBalancer')
    ,
}
