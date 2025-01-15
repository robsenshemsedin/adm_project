# 🇮🇹 Italian Census Data Management System

## 📖 Project Overview

This project is developed as part of the **Advanced Database Management** course. The objective is to efficiently store, manage, and query the **2021 Italian Census Dataset** using **MongoDB** and provide access through a **FastAPI** backend and a **Flutter** web application.

The system is designed to handle large-scale data while ensuring **Scalability**, **Availability**, **Distributed Queries**, **Consistency**, and efficient **Data Import**.

---

## 🏗️ Project Architecture

- **Database:** MongoDB (with multiple local hosts for sharding and replication)
- **Backend:** FastAPI (Python)
- **Frontend:** Flutter Web App
- **Data:** 2021 Italian Census Dataset


---

## ✅ Feasibility Study Requirements

### 1. **Data Import**

- Data was imported into MongoDB using **MongoDB Compass** for four local hosts.
- **Database:** `italian_census`  
- **Collection:** `region`

### 2. **Scalability**

- **Sharding** was implemented by distributing data across two shards:
  - **Host 1 (27017):** Region 1 (Primary)  
  - **Host 2 (27018):** Region 1 (Replica)  
  - **Host 3 (27019):** Region 2 (Primary)  
  - **Host 4 (27020):** Region 2 (Replica)

- **FastAPI** dynamically queries across all shards using a multi-client connection.

### 3. **Distributed Queries**

- Queries are executed across multiple hosts for efficient data retrieval.  
- Implemented with a helper function `query_all_collections()` in **main.py**, which sends queries to all hosts and aggregates the results.

### 4. **Availability**

- **Replication** ensures data availability even if a primary node fails.  
- If a primary host is unavailable, the system automatically queries its replica.  
- Handled through the `try-except` blocks in **main.py** with active host skipping.

### 5. **Consistency Model**

- **Read/Write Consistency** is achieved using MongoDB's replication model.  
- The app reads from available hosts, ensuring up-to-date data is always served.

---

## 🚀 Running the Project

### 1. **Start MongoDB Hosts**

bash
# Host 1 - Region 1 Primary
mongod --port 27017 --dbpath C:\Users\shems\mongodb\host1\data --bind_ip localhost --logpath C:\Users\shems\mongodb\host1\logs\mongo.log

# Host 2 - Region 1 Replica
mongod --port 27018 --dbpath C:\Users\shems\mongodb\host2\data --bind_ip localhost --logpath C:\Users\shems\mongodb\host2\logs\mongo.log

# Host 3 - Region 2 Primary
mongod --port 27019 --dbpath C:\Users\shems\mongodb\host3\data --bind_ip localhost --logpath C:\Users\shems\mongodb\host3\logs\mongo.log

# Host 4 - Region 2 Replica
mongod --port 27020 --dbpath C:\Users\shems\mongodb\host4\data --bind_ip localhost --logpath C:\Users\shems\mongodb\host4\logs\mongo.log

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn main:app --reload

# Navigate to frontend directory
cd frontend

# Get dependencies
flutter pub get

# Run the app
flutter run -d chrome

## 👨‍💻 Developer Information

**Developer:** Robsen Shemsedin Yusuf  
📧 **Email:** [shemsedinrobsen@gmail.com]  




