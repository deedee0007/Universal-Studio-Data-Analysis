# Universal Studios Data Scraping Project

This project involves scraping data from the Universal Studios website using Python's BeautifulSoup library and storing it in an SQL database. The scraped data includes movie details, showtimes, and other relevant information.

## Table of Contents

- Installation
- Usage
- Database Setup

## Installation

1. Clone this repository to your local machine.
2. Install Jupyter Notebook
3. Install the required Python libraries:
   - `requests`: To fetch HTML content from a URL.
   - `beautifulsoup4`: For parsing HTML content.
   - `pandas`:For exporting the scrapped data into csv file
4. Sql Server Management Studio : For Analyzing Data through sql

## Database Setup

1. Set up an SQL Server (if not already done).
2. Create a database (e.g., `UniversalStudiosData`).
3. Define a table (e.g., `Movies`) with appropriate columns (e.g., `Title`, `ReleaseDate`, `Description`).