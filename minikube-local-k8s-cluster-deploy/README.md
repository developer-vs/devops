# Installing Minikube

To install Minikube on Ubuntu, you can follow these steps:

** Prerequisites:

1. Ensure that you have a hypervisor installed on your system. VirtualBox is a popular choice. You can install it using the following command:
```bash
sudo apt-get update
sudo apt-get install virtualbox
```
2. Verify that your system supports virtualization by running:
```bash
egrep -q 'vmx|svm' /proc/cpuinfo && echo "Virtualization is supported" || echo "Virtualization is not supported"
```

## Installation Steps:

1. Download Minikube Binary:
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

2. Make the Minikube Binary Executable:
```bash
sudo chmod +x minikube-linux-amd64
```

3. Move the Minikube Binary to a Directory in Your PATH:
```bash
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
```

4. Start Minikube with Virtualbox Driver:
```bash
minikube start --driver=virtualbox
```
4. Start Minikube with Docker Driver:
```bash
minikube start --driver=docker
```

5. Verification:
```bash
minikube status
```


# Installing Kubectl

To install kubectl, the Kubernetes command-line tool run the command:
```bash
sudo apt-get update && sudo apt-get install -y kubectl
```


# Manual Installation of Kubectl

1. Download kubectl Binary:
```bash
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$(uname | tr '[:upper:]' '[:lower:]')/amd64/kubectl"
```

2. Make kubectl Executable:
```bash
chmod +x kubectl
```

3. Move kubectl Binary to a Directory in Your PATH:
```bash
sudo mv kubectl /usr/local/bin/
```

4. Verify Installation:
```bash
kubectl version --client
```


# Installing Kubectx and Kubens

1. Download Kubectx and Kubens Scripts:
```bash
curl -LO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx
curl -LO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens
```

2. Make Scripts Executable:
```bash
chmod +x kubectx kubens
```

3. Move Scripts to a Directory in Your Path:
```bash
sudo mv kubectx kubens /usr/local/bin
```

4. Verify Installation:
```bash
kubectx --help
kubens --help
```


# Running Pacman in Minikube

Follow these steps to set up and run Pacman on a Minikube cluster:

1. **Start Minikube**

2. **Set Kubernetes Context**
Ensure you are in the proper Kubernetes cluster:

3. **Set Kubernetes Namespace**
Make sure you are using the proper namespace (pacman):

4. **Deploy MongoDB**
Apply the MongoDB deployment and check the pod logs:
Then retrieve and view the logs of the MongoDB pod:
a. Retrieve Pod ID:
   ```
   kubectl get pods
   ```
b. View Pod Logs:
   ```
   kubectl logs <pod_ID>
   ```

5. **Deploy Pacman**
Apply the Pacman deployment:

6. **Access Pacman Service**
Access the Pacman service deployed in Minikube:

7. **Enjoy!**
Your Pacman game should now be running and accessible.




$ minikube start

$ kubectl apply -f namespace.yaml

$ kubens pacman

$ minikube image build -t my-pacman-image .

$ kubectl apply -f mongo-deployment.yaml

$ kubectl apply -f pacman-deployment.yaml

$ kubectl get service
NAME      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
mongo     ClusterIP   None          <none>        27017/TCP        8m31s
pac-man   NodePort    10.97.91.18   <none>        8080:30258/TCP   8m13s

$ $ minikube ip
192.168.49.2

$ minikube ssh sudo systemctl status docker

$ kubectl get rs
NAME                 DESIRED   CURRENT   READY   AGE
pac-man-6b6d6c9d99   1         1         0       66m

Try scaling up to run 20 replicas:
$ kubectl scale deployment/my-python-app --replicas=20


https://minikube.sigs.k8s.io/docs/commands/image/#minikube-image-build

Note: Make sure the "imagePullPolicy" is set, otherwise minikube will continue to try and pull from Dockerhub, even if the image is present in the local registry.
