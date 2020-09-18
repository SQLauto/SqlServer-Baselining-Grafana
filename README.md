# SqlServer-Baselining-Grafana
 
If you are a developer, or DBA who manages Microsoft SQL Servers, it becames important to understand current load vs usual load when SQL Server is slow. This repository contains scripts that will help you to setup SQL Server baselining and visualizing using Grafana.

Navigation
 - Sample Live Grafana Dashboards
   - [Live Dashboard - Basic Metrics](#live-dashboard-basic-metrics)
   - [Live Dashboard - Perfmon Counters - Quest Softwares](#live-dashboard-perfmon-counters-quest-softwares)
 - [Portal Credentials](#portal-credentials)

## Live Dashboard - Basic Metrics
You can visit [http://ajaydwivedi.ddns.net:3000](http://ajaydwivedi.ddns.net:3000/d/Fg8Q_wSMz/monitoring-live?orgId=1&refresh=30s&from=now-30m&to=now) for live dashboard for basic real time monitoring.<br>
![](https://github.com/imajaydwivedi/Images/blob/master/SqlServer-Baselining-Grafana/SQLDBATools%20_%20Monitoring%20-%20Live.JPG) <br>

## Live Dashboard - Perfmon Counters - Quest Softwares
Visit [http://ajaydwivedi.ddns.net:3000](http://ajaydwivedi.ddns.net:3000/d/_dioLINMk/monitoring-perfmon-counters-quest-softwares?orgId=1&refresh=1m)<br>
![](https://github.com/imajaydwivedi/Images/blob/master/SqlServer-Baselining-Grafana/SQLDBATools%20_%20Monitoring%20-%20Perfmon%20Counters%20-%20Quest%20Softwares.JPG) <br>

### Portal Credentials
Database/Grafana Portal | User Name | Password
------------ | --------- | ---------
http://ajaydwivedi.ddns.net:3000/ | guest | ajaydwivedi-guest
Sql Instance -> ajaydwivedi.ddns.net:1433 | grafana | grafana
