local grafana = import 'grafana/grafana.libsonnet';
local tk = import 'tk';

grafana + {
  _config+:: {
    namespace: tk.env.spec.namespace,
//    grafana_root_url: 'https://example.com/grafana',
    dashboard_config_maps: 1,
  },

  _images+:: {
    grafana: 'grafana/grafana',
  },

  // remove prometheus, as if we have Prometheus, we want to add it intentionally
  grafanaDatasources+:: {
    'prometheus.yml':: {}
  },

  grafana_config+:: {
    sections+: {
      server+: {
        root_url:: '',
      },
    },
  },

  grafana_service+: {
    spec+: {
      type: 'LoadBalancer',
    },
  },
}
