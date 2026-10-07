# event-management-sql
SQLite database for event management, with SQL queries for invoice tracking and financial reporting.
# Event Management Database & SQL Reporting

A relational SQLite database for a fictional event management company, with SQL reporting for outstanding invoices and event financial performance.

## Project overview

Summit Event Management Group (SEMG) organises corporate and private events. This project models its clients, venues, events, attendees, staff, services, invoices and payments in a relational database.

The project was completed for MBIS623 Data Management at the University of Canterbury.

## My contribution

- Implemented the relational database from the ER diagram supplied in the assignment.
- Created tables with primary keys, foreign keys and data constraints.
- Implemented many-to-many relationships using associative tables.
- Extended the model to support speaker bookings, invoices and payments.
- Wrote SQL queries and explained their business value.

## Tools and skills

SQLite · DB Browser for SQLite · SQL · Relational modelling · Data integrity · Financial reporting

## Database structure

The database contains 20 application tables covering:

- Clients, events and venues
- Attendees and tickets
- Workshops, speakers and expertise
- Staff assignments and event services
- Client invoices and payments
- Speaker bookings, invoices and payments

## SQL reporting

### Outstanding client invoices

Identifies invoices that have not been fully paid, including partial payments.

Uses JOIN, LEFT JOIN, SUM, COALESCE, GROUP BY and HAVING to calculate outstanding balances.

### Event financial performance

Identifies the event with the lowest invoiced revenue less quoted service costs and booked speaker fees.

Revenue and cost totals are aggregated separately before joining to avoid multiplying amounts across one-to-many relationships.

## Scope and limitations

This is an academic demonstration using sample data, rather than a production system.

The financial calculation includes selected costs only. It does not represent complete accounting profit or cash received.

Foreign-key enforcement must be enabled for each SQLite connection using:

PRAGMA foreign_keys = ON;
