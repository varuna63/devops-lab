param(
    [string]$ContainerName = "jenkins-ci"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Retrieving Jenkins Initial Admin Password               " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$running = docker ps --format '{{.Names}}'
if ($running -notcontains $ContainerName -and $running -notcontains "jenkins") {
    Write-Host "[!] Container '$ContainerName' is not running." -ForegroundColor Yellow
    docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'
    exit 1
}

$target = if ($running -contains $ContainerName) { $ContainerName } else { "jenkins" }

Write-Host "[*] Jenkins Admin Password:" -ForegroundColor Green
$password = docker exec $target cat /var/jenkins_home/secrets/initialAdminPassword
Write-Host $password -ForegroundColor Yellow

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Copy the password above and paste it at http://localhost:8080" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
