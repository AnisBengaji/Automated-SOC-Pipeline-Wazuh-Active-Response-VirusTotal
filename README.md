# Automated SOC Pipeline: Wazuh + VirusTotal + Active Response

![Platform](https://img.shields.io/badge/Platform-Ubuntu%2022.04-E95420?style=flat-square&logo=ubuntu&logoColor=white)
![Wazuh](https://img.shields.io/badge/Wazuh-4.x-00A1E0?style=flat-square)
![VirusTotal](https://img.shields.io/badge/VirusTotal-API%20v3-394EFF?style=flat-square)

A hands-on SOC automation lab that detects newly created files in real time, validates them against VirusTotal, and automatically removes confirmed threats — no manual intervention required.

---

##  How It Works

1. File created inside a monitored directory
2. Wazuh FIM detects the change in real time
3. File hash extracted and sent to VirusTotal API v3
4. If malicious → Rule 87105 triggers
5. `remove-threat.sh` executes on the agent
6. File deleted and event logged to the dashboard

---

##  Key Configuration

**FIM — Agent**
```xml
<directories realtime="yes" check_all="yes">/home</directories>
<directories realtime="yes" check_all="yes">/tmp</directories>
<directories realtime="yes" check_all="yes">/etc</directories>
```

**VirusTotal Integration — Manager**
```xml
<integration>
  <name>virustotal</name>
  <api_key>YOUR_API_KEY</api_key>
  <rule_id>554</rule_id>
  <alert_format>json</alert_format>
</integration>
```

**Active Response — Manager**
```xml
<command>
  <name>remove-threat</name>
  <executable>remove-threat.sh</executable>
  <timeout_allowed>no</timeout_allowed>
</command>

<active-response>
  <command>remove-threat</command>
  <location>local</location>
  <rules_id>87105</rules_id>
</active-response>
```

---

##  Test Result

- Dropped EICAR test file into monitored directory
- FIM detected file instantly
- VirusTotal confirmed file as malicious
- Rule 87105 triggered automatically
- File removed within seconds
- Deletion logged in Wazuh dashboard



---

##  Capabilities Demonstrated

✔ Real-time endpoint monitoring  
✔ Threat intelligence integration (VirusTotal API v)  
✔ Automated malware containment  
✔ Rule-based active response  
✔ SIEM deployment and configuration  
✔ SOC workflow simulation  


```
