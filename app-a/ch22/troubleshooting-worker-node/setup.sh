# Simulate the problem
# SSH into worker-node-2 and run:
sudo systemctl stop kubelet
kubectl cordon worker-node-2