local k = import 'ksonnet-util/kausal.libsonnet';
local grafana = import 'grafana-lib/grafana.libsonnet';

k + grafana + {

  grafanaDashboards+:: {
    'dashboard.json': import 'files/dashboard.json',
  }

}
