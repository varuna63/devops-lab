# Exercise 10: Multi-Node Kubernetes Cluster with Multiple Applications

## Objective
Deploy two Flask applications on a three-node Minikube cluster: Product Catalog with 2 replicas and Shopping Cart with 3 replicas. Pod anti-affinity spreads replicas of the same application across nodes.

## Repository structure

```text
exercise-10/
├── app/
│   ├── product_catalog.py
│   ├── shopping_cart.py
│   ├── Dockerfile.product
│   └── Dockerfile.shopping
├── manifests/
│   ├── product-catalog.yaml
│   └── shopping-cart.yaml
├── scripts/
│   ├── deploy.sh
│   ├── deploy.ps1
│   ├── cleanup.sh
│   └── cleanup.ps1
└── README.md
```

## Important corrections to the provided exercise

1. **Namespace mismatch fixed:** In the supplied text, the Shopping Cart Deployment used `devops-exercise`, but its Service used `default`. A Service can select Pods only within its own namespace. Both applications and Services now use `default` consistently.
2. **Anti-affinity:** Required Pod anti-affinity is used so replicas of each application cannot share a node. Since Shopping Cart has 3 replicas and the cluster has 3 nodes, each replica should be scheduled on a separate node. If a node is unavailable or resources are insufficient, some replicas can remain Pending; inspect events in that case.
3. **Images:** The deployment scripts build both images and load them into the `devops-multinode` Minikube profile before applying manifests. This supports the `imagePullPolicy: Never` used by these local images.
4. **Cart state limitation:** The Shopping Cart uses a Python in-memory list to match the exercise's simple example. Each Pod has its own memory; a Service may send consecutive requests to different Pods, so cart contents are not shared. A real application needs a shared database or cache.
5. This is a learning lab. Flask's built-in development server is not intended for production.

## Prerequisites
Install Docker, Minikube, and kubectl. Verify their commands work in your terminal.

## Deploy on Linux / WSL
From the `exercise-10` directory:

```bash
chmod +x scripts/*.sh
./scripts/deploy.sh
```

## Deploy on Windows PowerShell
From the `exercise-10` directory:

```powershell
.\scripts\deploy.ps1
```

The script creates (or starts) a Minikube profile named `devops-multinode` with three nodes, builds the application images, loads them into Minikube, applies the manifests, waits for the Deployments, and shows Pod placement.

## Verify the deployment

```bash
kubectl --context=devops-multinode get nodes
kubectl --context=devops-multinode get deployments
kubectl --context=devops-multinode get pods -o wide
kubectl --context=devops-multinode get services
kubectl --context=devops-multinode get endpoints
```

Expected desired counts: Product Catalog `2/2`; Shopping Cart `3/3`. The `NODE` column in `kubectl get pods -o wide` should show replicas spread across the nodes. Because required anti-affinity is enabled, Pods will remain Pending rather than co-locate if there are not enough eligible nodes.

## Access the applications
Run each command in a separate terminal. Keep those terminals open while testing:

```bash
minikube -p devops-multinode service product-catalog-service
minikube -p devops-multinode service shopping-cart-service
```

Alternatively, port-forward with separate terminals:

```bash
kubectl --context=devops-multinode port-forward service/product-catalog-service 8081:80
kubectl --context=devops-multinode port-forward service/shopping-cart-service 8082:80
```

In another terminal, test endpoints:

```bash
curl http://127.0.0.1:8081/products
curl http://127.0.0.1:8082/cart
curl -X POST http://127.0.0.1:8082/cart -H "Content-Type: application/json" -d '{"id":1,"name":"Laptop","quantity":1}'
```

Expected Product Catalog response contains Laptop, Phone, and Headphones. The initial cart response is `[]`. The POST endpoint returns the item list and status 201. Remember: because storage is in memory per replica, another request may reach another Pod and return a different cart.

## Troubleshooting

```bash
kubectl --context=devops-multinode describe pods
kubectl --context=devops-multinode get events --sort-by=.lastTimestamp
kubectl --context=devops-multinode logs deployment/product-catalog
kubectl --context=devops-multinode logs deployment/shopping-cart
```

- `ErrImageNeverPull` / `ImagePullBackOff`: check the Docker build succeeded and both images were loaded into the correct profile; image names and tags must match the YAML exactly.
- Pods stuck in `Pending`: check events and node capacity; required anti-affinity needs one eligible node per replica of that app.
- Service has no endpoints: make sure Service selectors match Pod labels and that they use the same namespace.
- Minikube context errors: check `kubectl config get-contexts` and `minikube profile list`.

## Cleanup

```bash
./scripts/cleanup.sh
```

On Windows PowerShell:

```powershell
.\scripts\cleanup.ps1
```

These scripts delete only the exercise Deployments and Services. To delete the whole cluster separately, run:

```bash
minikube -p devops-multinode delete
```

## Q&A

**1. Why use a multi-node cluster?** To practise scheduling Pods across nodes and observe node placement and failure domains.

**2. How many replicas are required?** Product Catalog: 2. Shopping Cart: 3.

**3. What does a Deployment do?** It manages ReplicaSets and maintains the desired number of Pods.

**4. What is the role of a Service?** It provides a stable endpoint and routes traffic to matching Ready Pods.

**5. Why must the Service and Pods be in the same namespace?** A Service selects Pods by labels within its own namespace; it cannot select Pods in another namespace.

**6. How do you verify node distribution?** Run `kubectl get pods -o wide` and inspect the `NODE` column.

**7. What happens when a Pod is deleted?** Its owning Deployment/ReplicaSet creates a replacement to restore the desired replica count.

**8. Is the in-memory cart shared between replicas?** No. Each Pod has independent memory. A real shopping-cart service should store state in shared persistent storage such as a database.
