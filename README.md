Sequel mapping to Devise
========================

**At least version 1.2.rc of Devise is required**

Please report any issues!

Installation
------------

    # bundler
    gem 'devise_sequel'

Also, at the moment (0.0.3) please use the orm_adapter-sequel from my repository, which is a fork from the real project from elskwid: https://github.com/mooman/orm_adapter-sequel     
This should be very temporary.

You're going to need an ORM for rails also. Only sequel-rails has been tested to work this gem.

Usage
-----

There are no generators at this point, but it's pretty easy to get started:

I like to extend only the models I need for Devise:

    class User < Sequel::Model
      plugin :devise

      devise ... # put the devise modules you want here
    end

But if you want them to be globally available for all your Sequel models, load the plugin before model loading:

    Sequel::Model.plugin :devise

For schema migration, you can do something like this:

    Sequel.migration do                                                   
      up do
        create_table :users do
          database_authenticatable
          confirmable
          recoverable
          rememberable
          trackable
          lockable
        
          DateTime :created_at
          DateTime :updated_at
        end 
      end 

      down do
        drop_table :users
      end 
    end

Very similar to the devise active record example. "database_authenticatable" creates an autoincrementing primary key "id" field for you.

Notes on mehayden fork
======================

Motivation was to get Devise 1.5.2 with UTC time fixes working with Sequel 3.30.0. I had tried the original mooman gem which was giving stack overflows because Devise 1.5.2 calls before_validation twice. I also tried the arthurdandrea fork which did not seem work correctly with the callbacks that Devise uses.

The solution provided in this version extends the Devise user models with ActiveModel::Callbacks.
Wrapper methods for the Sequel :save, :update and :validate methods are included into the model which call the necessary ActiveModel "run_callbacks" on the :create, :update and :validation callback types used by Devise 1.5.2.

The design allows one to redefine :save, :update or :validate in the model class as long as "super" is called appropriately. These are redefined to call the wrapper methods which are then reincluded.

Credits / Contributors
======================

Rachot Moragraan       
Daniel Lyons      
Michael Hayden

A lot of testing designs are from dm-devise.

