# Solana Deploy
Deploy a Solana Validator and/or RPC with Terraform and Ansible

### Optimal Machine Settings
* Our Latitude.sh s3.large.x86 server starts with the settings below, which we prefer because:
  * the initial state of the machine is cleaner than others that we have tried
  * disks are named consistently (nvme01, nvme0n2)
  * ubuntu installed (preferably ubuntu 20.04, 22.04) - this won't work with centos, etc. since they don't use aptitude by default
  * the login user being ubuntu helps (all the solana operations are done using the solana user that the ansible playbook creates)
  * ubuntu is in the sudoer's list
  * unmounted disks are clean - if your root is on one of partitions and you pass it as an argument, this could be disastrous

* All the above are satisfied by a fresh s3.large.x86 launch found here: https://www.latitude.sh/pricing
* Zen3 AMD Epyc’s such as the 7443p are considered some of the most performant nodes for keeping up with the tip of the chain at the moment, and support large amounts of RAM.

* Recommended RPC Specs
  * 24 cores or more
  * 512 GB RAM if you want to use ramdisk/tmpfs and store the accounts db in RAM (we use 300 GB for ram disk). without tmpfs, the ram requirement can be significantly lower (~256 GB)
  * 3-4 TB (multiple disks is okay - i.e. 2x 1.9TB - because the ansible playbook stripes them together)

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
time ansible-playbook runner.yaml --extra-vars='{"solana_version": "v1.13.4", "swap_mb":100000,"raw_disk_list":["/dev/nvme0n1","/dev/nvme1n1"],"setup_disks":true,"download_snapshot":true,"ramdisk_size":300}'
```

### Check status
```
/mnt/solana/target/release/solana-validator --ledger /mnt/solana-ledger monitor
ledger monitor
Ledger location: /mnt/solana-ledger
⠉ Validator startup: SearchingForRpcService...
```