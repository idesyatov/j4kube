# Reproducible localhost

[Download NixOS installation ISO](https://nixos.org/nixos/download.html)

## Installation

```sh
parted /dev/sda mklabel gpt
parted /dev/sda mkpart EFI fat32 0% 512M
parted /dev/sda set 1 esp on
parted /dev/sda mkpart NIX ext4 512M 100%

mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt/
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

nix-env -iA nixos.gitMinimal
git clone https://github.com/idesyatov/j4kube.git /mnt/etc/nixos/

Set import role in `/etc/nixos/configuration.nix`

nix-channel --add https://nixos.org/channels/nixos-20.09 nixos
nix-channel --add https://nixos.org/channels/nixos-20.09-small nixos-small
nix-channel --update

nixos-generate-config --root /mnt

nixos-install
reboot
```

## After install

Login as `root` with the password specified during installation

Set passwd for `user`

```sh
sudo nix-channel --add https://nixos.org/channels/nixos-20.09 nixos
sudo nix-channel --add https://nixos.org/channels/nixos-20.09-small nixos-small
sudo nix-channel --update
```

## Role configuration

[nixos.wiki/wiki/Kubernetes](https://nixos.wiki/wiki/Kubernetes)

### - Master

Link your kubeconfig to your home directory:

`ln -s /etc/kubernetes/cluster-admin.kubeconfig ~/.kube/config`

Now, executing `kubectl cluster-info` should yield something like this:

```sh
Kubernetes master is running at https://10.1.1.2
CoreDNS is running at https://10.1.1.2/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

You should also see that the master is also a node using `kubectl get nodes`:

```sh
NAME       STATUS   ROLES    AGE   VERSION
direwolf   Ready    <none>   41m   v1.16.6-beta.0
```

### - Node

According to the NixOS tests, make your Node join the cluster:

```sh
# on the master, grab the apitoken
cat /var/lib/kubernetes/secrets/apitoken.secret

# on the node, join the node with
echo TOKEN | nixos-kubernetes-node-join
```

After that, you should see your new node using kubectl get nodes:

```sh
NAME       STATUS   ROLES    AGE    VERSION
direwolf   Ready    <none>   62m    v1.16.6-beta.0
drake      Ready    <none>   102m   v1.16.6-beta.0
```
