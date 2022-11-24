# Solana Deploy
Deploy a Solana Validator and/or RPC with Terraform and Ansible

## Steps
### Provision a Machine 
```
cd providers/latitude
terraform init 
terraform apply
```

### Run the ansible command to provision machine
* this command can take between 10-20 minutes based on the specs of the machine
* it takes long because it does everything necessary to start the validator (format disks, checkout the solana repo and build it, download the latest snapshot, etc.)
* make sure that the solana_version is up to date (see below)
```
ansible-playbook playbooks/runner.yaml --extra-vars='{"solana_version": "v1.13.4", "swap_mb":100000,"raw_disk_list":["/dev/nvme0n1","/dev/nvme1n1"],"setup_disks":true,"download_snapshot":true,"ramdisk_size":300}'
```

### Check status
```
/mnt/solana/target/release/solana-validator --ledger /mnt/solana-ledger monitor
ledger monitor
Ledger location: /mnt/solana-ledger
⠉ Validator startup: SearchingForRpcService...
```