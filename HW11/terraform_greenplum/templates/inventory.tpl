[master]
# Valid is ONLY ONE master! Other will be ignored!
gp-mstr ansible_host=${ext_ip_vm0} ansible_ssh_user=ubuntu

[standbymaster]
# If you don't need SB-master, remove or comment line below
# and leave the section empty
#gp-sbmr ansible_host=130.193.55.222 ansible_ssh_user=ubuntu

[segments]
gp-seg1 ansible_host=${ext_ip_vm2} ansible_ssh_user=ubuntu

[masters:children]
master
standbymaster

[greenplum_cluster:children]
masters
segments

[all:vars]

#### Install ntp on master master_ntp maybe 'True' or 'False'
master_ntp=True

#### NTP hostname or IP
ntp_server=["0.ru.pool.ntp.org", "1.ru.pool.ntp.org", "2.ru.pool.ntp.org", "3.ru.pool.ntp.org"]

#### Path to GP install
gphome=/usr/local/greenplum

#### Login of user, who been owner of GP service
cluster_admin_user=gpadmin

#### If set to 'True', then try to create mkfs XFS on block devices on master
master_mkfs=True

#### If set to 'True', then try to create mkfs XFS on block devices on segments
segment_mkfs=True

#### Device name on master
master_devname=vdb

#### Mount point of datadisk on Master
master_datadir=/data1

#### Devices names on segments
segment_devname=["vdb", "vdc"]

#### Please set pairs of mount points and volume names
segment_datadisks=[["/data1", "/dev/vdb"], ["/data2", "/dev/vdc"]]

#### File system location where the master data directory
#### will be created.
master_directory=master

#### If set to 'True', then try to create and mount directories to vols on master
master_force_mount=True

#### If set to 'True', then try to create and mount directories to vols on segments
segment_force_mount=True

#### Folder for primary segments
primary_directory=primary

#### Naming convention for utility-generated data directories.
seg_prefix=gpseg

#### Create a database of this name after initialization.
database_name=gpdb

#### Port number for the master instance.
master_port=5432

#### Base number by which primary segment port numbers
#### are calculated.
port_base=6000

#### File system location(s) where primary segment data directories
#### will be created. The number of locations in the list dictate
#### the number of primary segments that will get created per
#### physical host (if multiple addresses for a host are listed in
#### the hostfile, the number of segments will be spread evenly across
#### the specified interface addresses).
#### You can omit this parameter, in this case the configurator will proceed from the values of the variables "segments_count" and "distribute".
#### Uncomment this, if you know, what you do for fine tuning.
; data_directory=/data1/primary /data1/primary /data1/primary /data1/primary

#### Number of segments on each drive.
segments_count=2

#### Need to distribute segments on all disks?
#### If `True` then segments will be created on all disk drives.
#### Else data-segments will be created on first disk drive on segment-server
#### and mirror-segments will be screated on last disk drive on segment-server (it can be same).
distribute=True

#### If 'True' is selected, then mirrors are created, relevant for seg>1
mirror=True

#### Folder for mirror segments
mirror_directory=mirror

#### Base number by which mirror segment port numbers
#### are calculated.
mirror_port_base=7000

#### File system location(s) where mirror segment data directories
#### will be created. The number of mirror locations must equal the
#### number of primary locations as specified in the
#### DATA_DIRECTORY parameter.
#### You can omit this parameter, in this case the configurator will proceed from the values of the variables "seg_count" and "distribute".
; mirror_data_directory=/data1/mirror /data1/mirror /data1/mirror /data1/mirror

#### Maximum log file segments between automatic WAL checkpoints.
check_point_segments=8

#### The number of segments to create in parallel.
init_parallel_processes=4
