local k = import 'ksonnet-util/kausal.libsonnet';
local grafana = import 'grafana-lib/grafana.libsonnet';
local dashboards = import 'dashboards/dashboards.libsonnet';

k + grafana + dashboards + {

}
