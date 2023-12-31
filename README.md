# Update All is powerful and here is why you should use it!

## Introduction

This repo is the example repo used for a video lesson for this specific video:

TODO: add video url

## What is the update_all method?

The `update_all` method is an Active Record class method that allows developers to update multiple records at the same time.

Documentation: https://apidock.com/rails/v4.0.2/ActiveRecord/Relation/update

## How is this different to the `update` method?

The `update_all` method is special because it is *WAY* faster. Here is why:

### It does not instantiate the active record models

Instantiating an active record object using calls like `Model.new` is not a zero cost abstraction. You might be loading mixins (modules, concerns) and running before initialization callbacks.

### It does not run callbacks

Since it does not instantiate active record objects for each record you are trying to update, there is no way that your code can run your callbacks such as before_save, after_save, and etc.

### It does not run validations

(Same reason as above), since it does not instantiate active record objects for each record you are trying to update, there is no way that your code can run your validations.

### It uses condensed SQL

The `update_all` method will run your update logic in 1 update sql statement and send that 1 request out to your database. The traditional `update` method will send a select statement, read the contents of the select statement, does active record magic, and sends out an update statement for EACH record you are updating. So every record takes 2 sql transactions while `update_all` only has 1 sql transaction regardless of the amount of records you are updating.

## What are the downsides of using update_all?
To sum it up in 1 word: **SAFETY**

The downsides of using `update_all` is fundamentally connected to why it's fast! Let's dive deeper:

`update_all` essentially bypasses all your core logic that is embedded into your active record models. It even skips updating your timestamps!

So you have to be extremely careful when you are using this method. There might be important validations and callbacks that need to happen to fulfill the business requirements of your code. 

Make sure that you either confirmed that the callbacks/validations do NOT need to run OR that you have code that conducts all the needed logic in a separate control flow.

It also is very hard to make sure the code that runs `update_all` will be considered safe throughout the lifetime of your codebase. If business requirements change and new validations/callbacks are created, it's hard to make sure that the `update_all` method will remain bug free / violation free.

The most surefire way to make sure your code stays bug free as your code evolves is to make sure someone remembers to change it when business requirements change. This is a tall ask!

## When should you use update_all

When performance/speed matters especially in the context of doing huge batch updates.

I would deter developers from using the `update_all` method in code that can be run arbrtically from user actions, in other words, I would avoid using `update_all` in user facing application logic. 

Ideally, developers use `update_all` as an manually ran ruby script or rake task where every time the `update_all` code is run, there is a specific understanding of the consequences of said code.
