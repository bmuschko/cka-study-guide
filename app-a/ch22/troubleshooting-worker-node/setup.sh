# On the control-plane node, corrupt the scheduler manifest:
sudo mv /etc/kubernetes/manifests/kube-scheduler.yaml /etc/kubernetes/manifests/kube-scheduler.yaml.backup
sudo bash -c 'cat /etc/kubernetes/manifests/kube-scheduler.yaml.backup | sed "s/image: registry.k8s.io\/kube-scheduler:.*/image: registry.k8s.io\/kube-scheduler:v1.99.0/" > /etc/kubernetes/manifests/kube-scheduler.yaml'