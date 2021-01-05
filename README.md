# Baget Proxy

http://localhost:4875/

## Start (simple)

```
./baget.sh sekret
```

## Start (chained)

```
./baget.sh sekret0 9999 "$(pwd)/upstream-baget-data"
UPSTREAM_IP="$(ip route get 1.1.1.1 | grep -oP 'src \K\S+')"

./baget.sh sekret 4875 "$(pwd)/baget-data" "http://${UPSTREAM_IP-"localhost"}:9999/v3/index.json"
```

## Use

### dotnet

```
dotnet new nugetconfig
dotnet nuget add source -n baget http://localhost:4875/v3/index.json

dotnet nuget list source
dotnet nuget disable source nuget
```

```
dotnet pack -c Release -o ./pack
Get-ChildItem ./pack -Filter '*.nupkg' | ForEach-Object { dotnet nuget push -s baget -k sekret $_ }
```

### powershell

```
./baget.sh sekret 4855 "$(pwd)/pwsh-baget-data"
```

```
$bagetServer="http://localhost:4855"
$repo = @{
    Name = 'BaGet'
    SourceLocation = "${bagetServer}/v3/index.json"
    PublishLocation = "${bagetServer}/api/v2/package"
    InstallationPolicy = 'Trusted'
}
Register-PSRepository @repo
```

```
# https://github.com/sethworks/PlasterTemplates
$env:PSModulePath = "${PWD}$([System.IO.Path]::PathSeparator)$env:PSModulePath"
Save-Module -Path . -Name @( "Plaster", "PlasterTemplates" )
Install-Module Plaster
$template=(Get-PlasterTemplate -IncludeInstalledModules | Where-Object Title -EQ 'PowerShell Module').TemplatePath
Invoke-Plaster -TemplatePath $template -DestinationPath ./Hello

Publish-Module -Repository BaGet -NuGetApiKey "sekret" -Name Hello
Find-Module    -Repository BaGet -AllowPrerelease -AllVersions Hello
```
