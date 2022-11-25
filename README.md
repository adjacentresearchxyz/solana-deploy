# Solana Deploy
Deploy a Solana Validator and/or RPC with Terraform and Ansible

## Steps
### Provision a Machine 
```
git clone https://github.com/adjacentresearchxyz/solana-deploy.git
cd solana-deploy
cd providers/latitude

# since terraform cloud backend doesn't support -var-file link it 
ln -s variables/solana-validators.tfvars ./*.auto.tfvars

# initialize and apply
terraform init 
terraform apply
```

### Provision Solana
```
# ssh into the machine 
# install ansible 
sudo apt-get update 
sudo apt install -y software-properties-common
sudo apt -y install ansible

# run the playbook
git clone https://github.com/adjacentresearchxyz/solana-deploy.git
cd solana-deploy

ansible-playbook playbooks/runner.yaml --extra-vars='{"solana_version": "v1.13.4", "swap_mb":100000,"raw_disk_list":["/dev/nvme0n1","/dev/nvme1n1"],"setup_disks":true,"download_snapshot":true,"ramdisk_size":300}'
```

### Check status
For the first few minutes you will see
```
/mnt/solana/target/release/solana-validator --ledger /mnt/solana-ledger monitor
ledger monitor
Ledger location: /mnt/solana-ledger
⠉ Validator startup: SearchingForRpcService...
```

Following that something like
```
⠐ 00:08:26 | Processed Slot: 156831951 | Confirmed Slot: 156831951 | Finalized Slot: 156831917 | Full Snapshot Slot: 156813730 |
```

Open port `:8899` to access from anywhere
