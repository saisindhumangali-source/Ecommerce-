# DBMS Project Submission Guide

## 1. Database Backend (MariaDB/MySQL)

The core database design, constraints, and business logic are fully implemented in SQL.
To evaluate the backend:
1. Open your MariaDB/MySQL server interface (e.g., phpMyAdmin, MySQL Workbench, or the command line).
2. Import and execute the `ecommerce_database.sql` script located in the root directory.
3. This script will automatically:
   - Create the relational schema (`ecommerce_db`) with all strict constraints and foreign keys.
   - Establish the **Triggers** (e.g., dynamically updating product stock on payment).
   - Create the **Views** and **Stored Procedures** (e.g., tracking order histories and categorizing sales).
   - The end of the `.sql` file includes the exact **complex queries** outlined in the project requirements.

## 2. Interactive Frontend Demo (React)

To show the working user interface of the platform:
1. Ensure Node.js is installed.
2. Open two separate terminal windows in the `FrontEnd` directory.
3. In the first terminal, run the mock backend server:
   ```bash
   npm run start-server
   ```
4. In the second terminal, run the React application:
   ```bash
   npm start
   ```
5. A browser window will open automatically. You can demonstrate the **Google Sign-In**, browsing dynamic product pages, using the **Cart**, and viewing the **Dashboards**.
