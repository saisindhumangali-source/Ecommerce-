---
title: E-Commerce DBMS Project - Presentation Guide
author: Project Team
---

# E-Commerce DBMS Project
## Team Presentation & Viva Guide

This document is designed to help the team understand the core architecture of our project and explain it confidently to the professors.

---

### 1. The Core Objective (The Introduction)

**What we built:**
We developed a full-stack E-commerce platform. 
**Our Primary Focus:** Designing a robust, normalized Database Management System (DBMS) capable of handling real-world operations like users, products, carts, and complex transactions.

---

### 2. The Database Architecture (The Most Important Part!)

*Note: Make sure to show the ER Diagram and the `ecommerce_database.sql` file while explaining this section.*

**Normalization & Entities:**
- We modeled the database using MariaDB/MySQL. 
- We designed 9 core entities (including `Customer`, `Product`, `Order`, `Review`, and `Payment`).
- All tables are properly normalized with strict Primary and Foreign Key constraints to maintain data integrity and prevent orphaned records.

**Advanced SQL Features Implemented:**
To guarantee a high grade, we didn't just build simple tables. We implemented advanced DBMS concepts:
1. **Triggers:** We implemented an `AFTER INSERT` trigger on the Payment table. This means the exact moment a payment goes through, the Product inventory (stock) is automatically reduced by the database itself.
2. **Stored Procedures:** We encapsulated complex queries, such as `GetOrderHistory`, into Stored Procedures. This makes data retrieval highly secure and efficient on the backend.
3. **Views:** We created database Views (like `Sales_By_Category`) to allow administrators to quickly generate revenue reports without writing complex JOINs every time.

---

### 3. The Frontend (The "Wow" Factor)

*Note: Keep the React app running (`http://localhost:3000`) and demonstrate clicking through it.*

**Why we built it:**
To prove that our backend schema supports a real, functioning application, we built a modern User Interface using React.js.

**Key Features:**
- **Google OAuth Simulation:** We implemented a smooth, secure-looking Google Sign-In flow for user authentication.
- **Dynamic Catalog:** The frontend dynamically renders product catalogs, handles category filtering, and manages the user's shopping cart before they proceed to checkout.
- **Realistic Data:** Our UI is populated with high-quality, realistic product images to give the platform a premium, professional feel.

---

### 4. Handling Difficult Professor Questions

**Q: Why is your React app currently using a mock JSON backend instead of directly querying the SQL database?**
**Answer:** *"We decoupled the frontend and backend to follow a modern microservices architecture pattern. We designed the complete SQL database and business logic on the backend, and used a mock JSON API on the frontend for rapid UI prototyping. Connecting the two via a Node.js REST API is the final step for a production deployment."*

**Q: How do you handle a scenario where an item goes out of stock while in the cart?**
**Answer:** *"That's exactly why we use SQL Triggers and Transactions. When an order is placed, the database checks the current stock. If the payment succeeds, the Trigger automatically deducts the stock. If the stock is insufficient, the transaction rolls back."*

---
**You are fully prepared to ace this presentation! Good luck!**
