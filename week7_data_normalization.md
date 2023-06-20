![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | Database normalization

### Instructions

1. Use [dbdiagram.io](https://dbdiagram.io/home) or [draw.io](https://draw.io) to propose a new structure for the `Sakila` database.

2. Define primary keys and foreign keys for the new database.

![Sakila database](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/3.4-lab-sakila-normalization.png)


Here is my approximate guideline to modify the tables.

- In the table 'film', rental_duation & rental_rate is not relevant for the table. They need to be move to the table 'rental'
- In 'actor' table, that'd be great to add country_id to identify the actor's nationality. In this case, we could add country_id as a foreign key which is a primary key in 'country' table
- the table 'film_text' would not be necessary. it's redundancy of the data as the info already presented in 'film' table
- for 'address' table, this table is not necessary. The current talbe links to 'customer','staff' and 'store' tables. Having unique address_id is not really need.
- thus, in each 'customer' and 'store'table, we could add address, address2, district, postal_code, phone, city_id
