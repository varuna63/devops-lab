# Exercise 05: Docker Security with AppArmor and Python

## 🎯 Objective
Understand how to secure Docker containers using **AppArmor** (Application Armor) security profiles with Python. In this exercise, you enforce Mandatory Access Control (MAC) policies, deploy profiles using both the Docker CLI and the **Docker SDK for Python**, and systematically verify security boundaries by attempting restricted actions inside the container.

---

## 🛡️ Security Threat Model & Defense-in-Depth

By default, Docker containers share the host Linux kernel and rely on namespaces and cgroups for isolation. If an attacker discovers a Remote Code Execution (RCE) vulnerability in an application (such as Flask):
1. **Without AppArmor**: The attacker can read `/etc/passwd`, traverse sensitive files in `/var/`, or spawn interactive shells (`/bin/bash`, `/bin/sh`) to escalate privileges.
2. **With AppArmor**: The Linux Security Module (LSM) intercepts every system call. Even if an attacker compromises the web app, directory reads to `/etc/` are denied at kernel level, binary execution of shells is blocked (Exit Code 126), and Linux administrative capabilities (`CAP_SYS_ADMIN`) are dropped.

---

## 🏗️ Architecture & Kernel Enforcement Flow

```mermaid
flowchart TD
    subgraph HostKernel["Host Linux Kernel (LSM - Linux Security Modules)"]
        APPARMOR["AppArmor Kernel Engine\nLoaded Profile: 'my-apparmor-profile'"]
        SYSCALL["Syscall Interceptor (open, execve, socket)"]
        FS_ETC["/etc/** (Deny Read)"]
        BIN["/bin/** (Deny Execute)"]
        APP_DIR["/app/** (Allow RWK)"]

        SYSCALL --> APPARMOR
        APPARMOR -->|Block| FS_ETC
        APPARMOR -->|Block| BIN
        APPARMOR -->|Allow| APP_DIR
    end

    subgraph DockerDaemon["Docker Engine"]
        SEC_OPT["--security-opt='apparmor=my-apparmor-profile'"]
    end

    subgraph Container["Container: flask-apparmor"]
        PYTHON["Python Web Process (app.py :5000)"]
        ATTACK1["Attacker Action: cat /etc/passwd"]
        ATTACK2["Attacker Action: /bin/bash"]
        
        PYTHON -->|Valid Request| APP_DIR
        ATTACK1 -->|Syscall open()| SYSCALL
        ATTACK2 -->|Syscall execve()| SYSCALL
    end

    SEC_OPT --> Container
```

---

## ⚙️ Prerequisites & Installation

### Install AppArmor Utilities
On Ubuntu / Debian / WSL2:
```bash
sudo apt-get update
sudo apt-get install -y apparmor-utils
```
Verify parser installation:
```bash
apparmor_parser --version
```

---

## 📋 Step-by-Step Implementation Guide

### Task 1: Write a Basic Python Flask Application
File: [`app/app.py`](./app/app.py)
```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, this is a secure Flask application running inside a Docker container!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

---

### Task 2: Containerize the Application
File: [`app/Dockerfile`](./app/Dockerfile)
```dockerfile
FROM python:3.8-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]
```

Build the Docker image:
```bash
docker build -t flask-apparmor ./app
```

---

### Task 3: Create and Apply AppArmor Profile
File: [`security/my-apparmor-profile`](./security/my-apparmor-profile)

```text
#include <tunables/global>

profile my-apparmor-profile flags=(attach_disconnected,mediate_deleted) {
    #include <abstractions/base>

    # Deny access to sensitive system files
    deny /etc/** r,
    deny /var/** rw,

    # Allow Flask app to bind to port 5000
    network inet stream,

    # Permissions to the application directory
    /app/** rwk,

    # Deny execution of any binaries in /bin or /usr/bin
    deny /bin/** rmix,
    deny /usr/bin/** rmix,

    # Capability restrictions
    capability net_bind_service,
    deny capability sys_admin,
}
```

#### Steps to Load and Apply:
1. **Copy and load profile into the Linux kernel**:
   ```bash
   sudo cp security/my-apparmor-profile /etc/apparmor.d/my-apparmor-profile
   sudo apparmor_parser -r /etc/apparmor.d/my-apparmor-profile
   ```
2. **Run container with the security option**:
   ```bash
   docker run -d --name flask-apparmor \
     --security-opt="apparmor=my-apparmor-profile" \
     -p 5000:5000 \
     flask-apparmor
   ```

---

### Task 4: Use Docker SDK for Python to Apply AppArmor Profile
Script: [`python_sdk/apply_apparmor.py`](./python_sdk/apply_apparmor.py)

Install SDK:
```bash
pip install -r python_sdk/requirements.txt
```

Run the script:
```bash
python python_sdk/apply_apparmor.py
```

Expected Output:
```text
Building image from Dockerfile...
[INFO] Sending build context to Docker daemon  3.072kB
[INFO] Successfully built flask-apparmor

Running container with AppArmor profile...
Container started: f8c2a7f9b9b8

Inspecting container to verify AppArmor profile...
AppArmor profile applied: ['apparmor=my-apparmor-profile']

Stopping the container...
```

---

### Task 5: Test Restricted Actions
Script: [`python_sdk/test_restricted_actions.py`](./python_sdk/test_restricted_actions.py)

Run the security test:
```bash
python python_sdk/test_restricted_actions.py
```

Expected Output:
```text
Container started: f8c2a7f9b9b8

Attempt to read /etc/passwd: Exit Code 1, Output: 
Attempt to execute /bin/bash: Exit Code 126, Output: 

Container stopped
```

> **Why Exit Code 126?**
> In Linux systems, **Exit Code 126** indicates that the command was found, but **permission was denied to execute it** by the operating system (enforced here by AppArmor).

---

## ❓ Q&A Review

| # | Question | Answer |
| :--- | :--- | :--- |
| **Q1** | **What is the purpose of using AppArmor with Docker containers?** | AppArmor provides Mandatory Access Control (MAC) to confine container processes, restricting file system access, network capabilities, and binary execution beyond standard Linux user permissions. |
| **Q2** | **How do AppArmor profiles help secure a Docker container?** | They define granular rules dictating allowed vs denied system operations (path reads/writes, capability bounding, binary execution), preventing an application compromise from impacting the container or host. |
| **Q3** | **Why is it important to restrict access to sensitive directories such as `/etc/` and `/var/`?** | These directories house credentials, system configurations, user tables (`/etc/passwd`), and system logs. Restricting access eliminates information disclosure and local tampering. |
| **Q4** | **What other capabilities can you restrict using AppArmor profiles?** | You can restrict network sockets (`raw`, `stream`), specific port bindings, Linux capabilities (such as `CAP_SYS_ADMIN`, `CAP_NET_ADMIN`), and mounting operations. |
| **Q5** | **How can you verify if an AppArmor profile is successfully applied to a Docker container?** | By inspecting the container using `docker inspect <container-id> | grep -i apparmor` or checking `HostConfig.SecurityOpt` via the Docker SDK. |

---

## 🧹 Cleanup
```bash
# Bash
./scripts/cleanup.sh

# PowerShell
.\scripts\cleanup.ps1
```
