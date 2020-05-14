local prometheus = import 'prometheus.libsonnet';
local disk = import 'disk_space.libsonnet';

prometheus + {
  grafanaDashboards+:: {
    'memory.json': import 'memory.libsonnet',
    'disk_bytes.json': disk.new(
        'Disk space',
        'diskspace',
        'node_filesystem_size_bytes',
        'node_filesystem_avail_bytes',
        'bytes'
    ),
    'disk_files.json': disk.new(
        'Inodes',
        'inodes',
        'node_filesystem_files',
        'node_filesystem_files_free',
        'short'
    ),
  }
}
