#!/bin/bash

for i in `ls rhel/usr_lib*.service`
do
  name=`echo $i | awk -F_ '{print $NF}'`
  echo $name
  cp $i /usr/lib/systemd/system/$name
  chmod a+r /usr/lib/systemd/system/$name
done

del_num_begin=`sed -n -e '/@begin_dpdk@/=' rhel/usr_lib_systemd_system_ovs-vswitchd.service.in`
del_num_end=`sed -n -e '/@end_dpdk@/=' rhel/usr_lib_systemd_system_ovs-vswitchd.service.in`

echo "删除第${del_num_begin}到第${del_num_end}行"
if [ ${del_num_begin} ] && [ ${del_num_end} ] && [ "${del_num_begin}" -gt 0 ] && [ "${del_num_end}" -gt 0 ] && [ "${del_num_end}" -gt "${del_num_begin}" ]
then
  sed -e '${del_num_begin},${del_num_end}d' rhel/usr_lib_systemd_system_ovs-vswitchd.service.in > /usr/lib/systemd/system/ovs-vswitchd.service
else
  cat rhel/usr_lib_systemd_system_ovs-vswitchd.service.in > /usr/lib/systemd/system/ovs-vswitchd.service
fi

