import os
import docker

def main():
    print("==================================================")
    print("  Applying AppArmor Profile via Docker Python SDK ")
    print("==================================================")
    
    # Create Docker client from environment
    client = docker.from_env()

    app_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "app"))

    # Build the Docker image
    print("[*] Building image 'flask-apparmor' from Dockerfile...")
    image, build_logs = client.images.build(path=app_dir, tag="flask-apparmor", rm=True)
    for line in build_logs:
        if 'stream' in line:
            print(f"[INFO] {line['stream'].strip()}")

    # Run the container with the AppArmor profile
    print("\n[*] Running container with AppArmor profile 'my-apparmor-profile'...")
    container = client.containers.run(
        "flask-apparmor",
        name="flask-apparmor-demo",
        ports={'5000/tcp': 5000},
        security_opt=["apparmor=my-apparmor-profile"],
        detach=True
    )

    print(f"[+] Container started successfully: {container.short_id}")

    # Inspect container to verify AppArmor profile applied
    print("\n[*] Inspecting container to verify SecurityOpt...")
    container_info = client.api.inspect_container(container.id)
    apparmor_profile = container_info['HostConfig'].get('SecurityOpt', [])

    print(f"[+] AppArmor profile applied: {apparmor_profile}")

    # Stop and remove container
    print("\n[*] Stopping and removing the container...")
    container.stop()
    container.remove()
    print("[+] Cleanup complete.")

if __name__ == '__main__':
    main()
