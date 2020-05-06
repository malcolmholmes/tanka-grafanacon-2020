local grafana = import "grafonnet-lib/grafonnet/grafana.libsonnet";
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local colors = import "colors.libsonnet";

{
    new(title, uid, total_metric, free_metric, format,)::
        dashboard.new(title, uid=uid,)
        .addTemplate(
            template.new(
                "instance",
                "Prometheus",
                "label_values(%s, instance)" % free_metric,
                "instance",
                refresh="load",
            )
        )
        .addTemplate(
            template.new(
                "mountpoint",
                "Prometheus",
                'label_values(%s{instance=~"$instance"}, mountpoint)' % free_metric,
                "mountpoint",
                refresh="load",
                multi=true,
                includeAll=true,
                current="all",
            )
        )
        .addPanel(
            grafana.graphPanel.new(
                "$mountpoint",
                format=format,
                repeat="mountpoint",
                min=0,
                datasource="Prometheus",
            )
            .addTarget(
                prometheus.target(
                    '%s{instance=~"$instance",mountpoint=~"$mountpoint"}' % total_metric,
                    legendFormat="Total",
                )
            )
            .addTarget(
                prometheus.target(
                    '%s-%s{instance=~"$instance",mountpoint=~"$mountpoint"}' % [total_metric, free_metric],
                    legendFormat="Used",
                )
            )
            + colors.totalused
            ,
            { x: 0, y: 0, w: 8, h: 6 }
        ),
}
