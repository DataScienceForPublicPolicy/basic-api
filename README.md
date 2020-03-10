# Setting up an API service

Imagine that many property owners would like to know the expected sales price for their property if they put it on the market. It's not possible to know this for certain unless they put the property on the market. However, given the price of other units that have sold, we could train a hedonic price model to associate price with the qualities of the property, like the size, age, type, location, among others.  It sounds like a prediction problem, no? 

Now suppose we train a model. It could be useful to a wide number of people, but having each person send data about their house might be quite a lot to handle. Instead, what if a web application (e.g. website) could make a direct request to your model to score housing characteristics. An Application Programming Interface (API) can serve as a layer that connects web applications to predictive models on a server, making it easier to extract insights from data products.

In this repository, we provide all necessary code to kick start a basic API service for scoring real estate data. Using a pre-trained regression model for real estate in Brooklyn, NY, we set up a RESTful API service to score real estate attributes and return a predicted price.

## Basic concepts 

Let's first walk through what exactly is an API. To start, we need to understand the idea of CRUD - Create, Retrieve, Update, and Delete - basic operations that allow users and programs to work and mange data-driven applications. A user may want to add or *create* a new records in a database, retrieving information, query to *retrieve* it when needed, *update* it with new information, or *delete* when cleaning old or unnecessary information. When it comes to web applications, APIs are one way to perform CRUD operations on a remote data system. 

To make it easy to perform CRUD through APIs over the internet, they are often designed following a representational state transfer (REST) design, placing constraints on what CRUD can and cannot do and standardizing how one makes requests to a system. In API parlance, we can make four types of requests:  `POST` (Create), `GET` (Retrieve), `PUT` (Update), and `DELETE` (Delete). 

In this example, we focus on `GET` requests to a prediction model.

## The game plan

To deploy a scoring API, we need three files: 

- *Pre-trained model*. A linear regression model object trained to predict housing prices in Brooklyn, NY using Building Class, Gross Area of Unit, Land Area, Zip code, Year of Construction. See file `model/mod.Rda`.
- *The Endpoints*. We need to define *endpoints* that will be available through the API. Each endpoint is a function that takes a `GET` request and returns something. For simplicity, we will define three endpoints: (1) `\modsummary` to provide details about the scoring model's performance, (2) `\plotresids` to return a graph of the model's underlying performance in terms of the residuals, (3) `\score` to push a set of building characteristics provided by the user through the housing price model to obtain a predicted price. See file `script/scoring-api.R`.
- *Deployment code*. To deploy the API, we will need specific instructions for how a web browser can access the API. The deployment code indicates the *port* through which the endpoints can be accessed. With See file `script/host-api-locally.R`.

In each of the scripts, make sure to change the working directory following the instructions in the annotation.


## Test the API

To test the API, let's deploy the API locally by running the entire `host-api-locally.R` script. In production environments, this would be a server that would run **R** and make the service open to the world. But in this case, we will only make the available locally on your computer as a test using port `8000`. To make queries from your web browser, you, simply submit requests to `http://localhost:8000`.

In a browser, let's test a couple of the services. When the API receives the request, it will look at the available queries that are possible and return a result. Otherwise, it will a 404 code for "resource not found". 


### Model Summary
To start, let's retrieving basic information about the scoring model using `modsummary`:

`http://localhost:8000/modsummary`

The API will return:

`{"msg":["Underlying linear regression model has a R-squared of 0.449 with a RMSE of 1265793.222"]}`

This indicates that the regression model used for scoring has some predictive power, but it is not precise. 

### Retrieve score

Now, let's give the scoring service a shot. Let's say we have a three bedroom home with 1500 square feet and 2340 square feet of land located in zip code 11230 built in the year 2000: 

`http://localhost:8000/score?bclass=3&year=2000&gsf=1500&lsf=2340&zip=11230`

- `bclass`: Integer indicating type of building (1 = single family, 2 = two family home, 3 = three family home, 30 = warehouses). See the training sample `data/home_sales_bk.csv`  for detail.
- `year`: Year structure was built.
- `gsf`: Gross square footage
- `lsf`: Land square footage
- `zip`: Zip code in Brooklyn, NY (e.g. 11229, 11215, 11208, etc.)

The scoring engine returns a result of $992,622. In contrast, the same home in zipcode 11231 would be worth $2,295,014.


## The next level

These services can be as many as functions and methods available in R. But to make the API available to the world, it needs to be hosted on cloud infrastructure. Setting up a hosting environment is beyond the scope of this tutorial, but  consider reviewing this documentation: [
https://www.rplumber.io/docs/hosting.html](
https://www.rplumber.io/docs/hosting.html). 