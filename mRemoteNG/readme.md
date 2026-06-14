

# 📁 mRemoteNG Folder Structure

a powershell to create this Structure in mRemoteNG 

## CSV

| State | Branch   | T    | Connection | Username | Domain | Password | Hostname     |
|-------|----------|------|------------|----------|--------|----------|--------------|
| NY    | DOWNTOWN | USA  | 10.10.10.10 |          |        |          | 10.10.10.10  |



## 🗺️ Folder Hierarchy Flowchart

```mermaid
flowchart TD
    A[📂 all] --> B[📂 Country 1]
    A --> C[📂 Country 2]
    
    B --> D[📂 State]
    C --> E[📂 State]
    
    D --> F[📂 Branch]
    E --> G[📂 Branch]
    
    F --> H[🖥️ SRV-1]
    F --> I[🖥️ SRV-2]
    
    G --> J[🖥️ SRV-1]
    G --> K[🖥️ SRV-2]
```
