local grafana = import "grafonnet-lib/grafonnet/grafana.libsonnet";
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local colors = import "colors.libsonnet";

dashboard.new("memory", uid="memory",)
.addTemplate(
    template.new(
        "instance",
        "Prometheus",
        "label_values(node_memory_MemTotal_bytes, instance)",
        "instance",
        refresh="load",
    )
)
.addPanel(
    grafana.graphPanel.new(
        "Memory",
        format="bytes",
        min=0,
        datasource="Prometheus",
    )
    .addTarget(
        prometheus.target(
            'node_memory_MemTotal_bytes{instance=~"$instance"}',
            legendFormat="Total",
        )
    )
    .addTarget(
        prometheus.target(
            'node_memory_MemTotal_bytes-node_memory_MemFree_bytes{instance=~"$instance"}',
            legendFormat="Used",
        )
    )
    + colors.totalused
    ,
    { x: 0, y: 0, w: 8, h: 6 }
)
