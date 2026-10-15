import docker

def main():
    print("==================================================")
    print("  Testing AppArmor Restricted Actions via SDK     ")
    print("==================================================")

    # Create Docker client
    client = docker.from_env()

    # Run the container with the AppArmor profile
    print("[*] Starting container with AppArmor profile 'my-apparmor-profile'...")
    container = client.containers.run(
        "flask-apparmor",
        name="flask-apparmor-test",
        ports={'5000/tcp': 5000},
        security_opt=["apparmor=my-apparmor-profile"],
        detach=True
    )
    print(f"[+] Container started: {container.short_id}")

    try:
        # Test Restricted Action 1: Attempt to read /etc/passwd
        print("\n[*] Test 1: Attempt to read sensitive file '/etc/passwd' (should be DENIED)...")
        exit_code, output = container.exec_run("cat /etc/passwd")
        print(f"    Attempt to read /etc/passwd: Exit Code {exit_code}, Output: {output.decode().strip() or '<blocked by AppArmor>'}")

        # Test Restricted Action 2: Attempt to execute /bin/bash binary
        print("\n[*] Test 2: Attempt to execute binary '/bin/bash' (should be DENIED)...")
        exit_code, output = container.exec_run("/bin/bash -c 'whoami'")
        print(f"    Attempt to execute /bin/bash: Exit Code {exit_code}, Output: {output.decode().strip() or '<execution denied (126)>'}")

    finally:
        # Stop and remove container
        print("\n[*] Stopping and removing test container...")
        container.stop()
        container.remove()
        print("[+] Container stopped and cleaned up.")

if __name__ == '__main__':
    main()
