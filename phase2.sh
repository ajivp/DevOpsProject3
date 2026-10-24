
echo "===== EXISTING PROJECT FILES ====="
ls -la
find . -maxdepth 2 -type f \
  \( -name 'main.tf' -o -name 'Dockerfile' \
     -o -name 'Jenkinsfile' -o -name 'docker-compose.yml' \
     -o -name 'package.json' \) -print 2>/dev/null | head -60

echo -e "\n===== INSTALLED PACKAGES ====="
dpkg -l | grep -E 'docker.io|docker-ce|containerd|nodejs|terraform|kubectl|minikube' || true

echo -e "\n===== VIRTUALIZATION AND STORAGE ====="
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS

