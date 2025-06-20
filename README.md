# Uber Demand-Supply Gap Analysis

## Project Overview

This project focuses on a comprehensive analysis of Uber ride-hailing data to identify and understand the underlying demand-supply gaps. By leveraging a multi-stage approach involving Python for data preprocessing, MySQL for robust data storage and querying, and Microsoft Excel for interactive visualization, this analysis aims to pinpoint operational inefficiencies and propose data-driven recommendations.

The primary goal is to shed light on why requests remain unfulfilled (cancelled or no cars available) during various times and locations, ultimately contributing to improved service reliability and customer satisfaction.

## Problem Statement

Like many ride-hailing platforms, Uber frequently encounters challenges in efficiently matching rider demand with driver supply. This imbalance often leads to unfulfilled requests, driver frustration, and a diminished user experience. This project specifically investigates:
* The overall distribution of request statuses (completed, cancelled, no cars available).
* Hourly and location-specific patterns of demand and supply mismatches.
* The distinct nature of unfulfilled requests (driver cancellations vs. car unavailability) at different pickup points (Airport vs. City).

## Project Structure

The repository is organized as follows:

.
├── data/                       # Contains raw and cleaned CSV data files, along with query outputs

│   ├── Uber Request Data.csv       # Original dataset

│   ├── uber_requests_cleaned.csv   # Data after Python cleaning

└── Uber_Supply_Demand_Gap_Analysis.ipynb        # Google Colab Notebook for Python data cleaning and preprocessing

└── Uber_SQL_Analysis_Code.sql         # SQL script with all analytical queries

└── README.md                   # This README file


## Technologies Used

* **Python:** Used for initial data loading, cleaning, preprocessing, feature engineering, and basic exploratory analysis.
    * Libraries: `pandas`, `numpy`
* **MySQL:** Utilized as a relational database to store the cleaned data and execute complex analytical SQL queries.
* **Microsoft Excel:** Employed for creating a dynamic, interactive dashboard with various chart types to visualize key insights.
* **Git & GitHub:** For version control, collaborative development, and project hosting.

## Analysis Phases & Key Findings

The project followed a structured analytical approach:

### **1. Data Cleaning & Preprocessing (Python)**
The raw dataset was loaded and transformed in Python. Key steps included:
* Handling missing values in `Driver id` and `Drop timestamp`.
* Converting timestamp columns to datetime objects.
* Feature engineering to extract `RequestHour`, `Trip Duration (minutes)`, and `Request Day of Week`.

### **2. Data Analysis & Querying (SQL - MySQL)**
The cleaned data was imported into MySQL, and a series of targeted SQL queries were run to extract actionable insights.

* **Overall Request Status Distribution:**
    * **Finding:** A significant portion of requests are unfulfilled: **39.29% were 'No cars available'** (2650 requests) and **18.74% were 'Cancelled'** (1264 requests). Only **41.97% were 'Trip completed'** (2831 requests). This highlights a major inefficiency where almost 58% of demand goes unmet.

* **Request Status Distribution by Pickup Point:**
    * **Finding:** Distinct patterns emerge based on pickup location. The **Airport** predominantly suffers from **'No cars available' (1713 requests)**. In contrast, the **City** experiences a higher volume of **'Cancelled' requests (1066 requests)** compared to 'No cars available' from the city.

* **Overall Hourly Demand & Supply Patterns:**
    * **Finding:** Both morning (5 AM - 10 AM) and evening (5 PM - 9 PM) exhibit significant unfulfilled demand. 'Cancelled' requests spike during morning peak hours (e.g., 176 at 05:00, 175 at 09:00), while 'No cars available' surges in the evening (e.g., 322 at 18:00, 290 at 20:00).
    
* **Average Trip Duration by Pickup Point:**
    * **Finding:** The average trip duration for completed rides is remarkably similar for both Airport (~52.24 minutes) and City (~52.57 minutes) pickups, suggesting that trip length is not a primary driver of unfulfillment.
  
* **Top 5 Drivers by Completed Trips:**
    * **Finding:** Identified top-performing drivers such as Driver 22 (16 trips), Driver 233 (15 trips), and Driver 184 (15 trips).

### **3. Data Visualization & Dashboard (Excel)**
An interactive Excel dashboard was created, featuring various charts to clearly communicate the insights.

* **Key Charts on the Dashboard:**
    * **Overall Hourly Demand and Supply (Combo Chart):** Visually represents the hourly flow of total requests, completed trips, cancellations, and car unavailability, highlighting peak hour challenges.
    * **Uber Request Status by Pickup Point (Clustered Column Chart):** Compares status distribution between Airport and City, showing Airport's 'No cars available' problem vs. City's 'Cancelled' issue.
    * **Hourly Percentage of Unfulfilled Requests by Pickup Point (Clustered Column PivotChart with filter):** Provides dynamic, granular percentages of cancellations and unavailability per hour for Airport/City, confirming specific time-based pain points.
    * **Overall Request Status Distribution (Donut Chart):** Offers a quick visual summary of the overall percentage breakdown of request statuses.
    * **Request Status for City / Airport (Donut Charts):** Provide granular percentage breakdowns of request statuses for each pickup point, vividly contrasting the primary reasons for unfulfillment at each location.
    * **Top 5 Drivers by Completed Trips (Bar Chart):** Highlights the contributions of the most active drivers.

## Recommendations

Based on the findings, the following recommendations are proposed to mitigate the demand-supply gap:

1.  **Dynamic Incentives for Airport Evenings:** Implement targeted surge pricing and driver incentives for Airport pickups specifically during evening peak hours (5 PM - 9 PM) to attract more drivers to this highly undersupplied location.
2.  **Enhanced Predictive Analytics:** Develop and leverage more sophisticated predictive models for driver availability and rider demand in specific zones and time slots. This allows for proactive driver positioning and resource allocation.
3.  **Optimize City Dispatch Algorithms:** Review and fine-tune the dispatch and matching algorithms for City pickups, especially during morning peak hours, to reduce rider wait times and minimize driver-initiated cancellations.
4.  **Improve Rider Communication:** Implement clearer communication to riders about potential wait times or car availability in specific areas during peak times to manage expectations and potentially reduce rider-initiated cancellations.
5.  **Strategic Driver Recruitment & Retention:** Continue efforts to expand the overall driver pool and implement strategies to retain existing drivers, particularly focusing on those willing to serve high-demand or less convenient routes (like Airport trips).

## Conclusion

This analysis provides a clear, data-driven understanding of Uber's demand-supply gap. By focusing on targeted interventions at specific times and locations, particularly addressing 'No cars available' at the Airport in the evening and 'Cancelled' trips from the City in the morning, Uber can significantly improve its operational efficiency, reduce unfulfilled requests, and enhance both rider and driver satisfaction.

---
*Author - Samruddhi Sanap*
