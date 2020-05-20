local grafana = import 'grafana/grafana.libsonnet';
local tk = import 'tk';

grafana {
  _config+:: {
    namespace: tk.env.spec.namespace,
    //    grafana_root_url: 'https://example.com/grafana',
    dashboard_config_maps: 1,
  },

  _images+:: {
    grafana: 'grafana/grafana:7.0.0',
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
