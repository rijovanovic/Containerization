Write-Output "Changing ini files to add Azure Logging..."

Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Datamapper Engine\DatamapperEngine.ini" -Value "-javaagent:C:\applicationinsights-agent-3.1.0.jar"
Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Datamapper Engine\DatamapperEngine.ini" -Value "-Dapplicationinsights.configuration.file=dm-app-insights.json"

Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Merge Engine\MergeEngine.ini" -Value "-javaagent:C:\applicationinsights-agent-3.1.0.jar"
Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Merge Engine\MergeEngine.ini" -Value "-Dapplicationinsights.configuration.file=me-app-insights.json"

Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Server\Server.ini" -Value "-javaagent:C:\applicationinsights-agent-3.1.0.jar"
Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Server\Server.ini" -Value "-Dapplicationinsights.configuration.file=se-app-insights.json"

Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Weaver Engine\WeaverEngine.ini" -Value "-javaagent:C:\applicationinsights-agent-3.1.0.jar"
Add-Content -Path "C:\Program Files\Objectif Lune\OL Connect\Connect Weaver Engine\WeaverEngine.ini" -Value "-Dapplicationinsights.configuration.file=we-app-insights.json"
