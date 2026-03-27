POOL=Bailey

# Delete QEMU VMs and LXC Containers + their disks
pvesh get /pools/$POOL --output-format json \
  | jq -r '.members[] | select(.type=="qemu" or .type=="lxc") | "\(.node) \(.type) \(.vmid)"' \
  | while read node type vmid; do
      if [ "$type" = "qemu" ]; then
          echo "Deleting QEMU VM $vmid on node $node..."
      elif [ "$type" = "lxc" ]; then
          echo "Deleting LXC Container $vmid on node $node..."
      fi
      
      # The API path conveniently matches the type variable ('qemu' or 'lxc')
      pvesh delete /nodes/$node/$type/$vmid
    done
