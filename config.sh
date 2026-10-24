
echo "===== KALI LINUX ====="
cat /etc/os-release | grep -E '^(PRETTY_NAME|VERSION)='

echo -e "\n===== CPU ====="
nproc
lscpu | grep -E 'Model name|CPU\(s\):' | head -5

echo -e "\n===== MEMORY ====="
free -h

echo -e "\n===== DISK SPACE ====="
df -h /

echo -e "\n===== INSTALLED TOOLS ====="
for tool in git docker node npm terraform kubectl minikube java jenkins helm; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf "%-12s %s\n" "$tool" "$(command -v "$tool")"
    else
        printf "%-12s %s\n" "$tool" "NOT INSTALLED"
    fi
done

echo -e "\n===== TOOL VERSIONS ====="
git --version 2>/dev/null
docker --version 2>/dev/null
node --version 2>/dev/null
npm --version 2>/dev/null
terraform --version 2>/dev/null | head -1
kubectl version --client 2>/dev/null
minikube version 2>/dev/null
java -version 2>&1 | head -2
helm version --short 2>/dev/null

echo -e "\n===== DOCKER STATUS ====="
docker info 2>&1 | head -20

echo -e "\n===== PROJECT DIRECTORY ====="
pwd

