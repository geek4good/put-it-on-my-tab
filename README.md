# Put it on my TAB

A simplistic note-taking application framework.

**Put it on my TAB** is a very simple framework to create and retrieve notes. At the
moment there's is an example web delivery method and a file system serializer
for storing notes as well as a fake serializer for testing. If desired, the
notes can also be encrypted with a password. In fact, when using the web
delivery method, passing a password parameter is mandatory for both, storing and
retrieving notes, but it can be an empty string, of course.

There are no gem dependencies. Running the app on a Ruby version >= 2.0 should
work just fine. Older versions of Ruby probably work as well, but are untested.

## Structure

```
put_it_on_my_tab/
|
+-- note.rb
+-- crypto_helper.rb
|
+--+ bin/
|  + web_server.rb
|
+--+ delivery_methods/
|  +-- web.rb
|
+--+ serializers/
   +-- file_system.rb
```

Usually, I would not include the delivery method in this gem. Maybe not even the
serialization. But since, I'm just starting out, and the pain is not too great,
it's fine the way it is for now. But the deeply nested namespaces are definitely
an indication of things “wanting” to be separated.

## Installation

This is neither necessary for testing purposes, nor, since this whole thing is
far from production-ready, recommended for any other purpose. But for the sake
of a complete picture, here are some installation instructions:

Add this line to your application's Gemfile:

    gem 'put_it_on_my_tab'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install put_it_on_my_tab

## Usage

### Setup

Fire up the server by calling `PORT=8080 bin/web_server` on the command line.
You can freely choose a port number that suits you, of course.

If you want to want to use a different serializer set the environment variable
`SERIALIZER`. At this time valid values are `files` and `fake`. If the
environment variable `SERIALIZER` is not set, **Put it on my TAB** defaults to use
the file system serializer.

When using file system serialization, the default storage directory is
`$PWD/notes`. If you want to store your files in a different directory, you can
set the environment variable `FILE_STORE` to the directory of your choosing.

### Creating and retrieving notes

To create a note, you need to send a POST request to `localhost:8080/note` You
can use `curl` on the command line. The following should do the trick:

`curl -d title='The title' -d body='The body' -d password=S3CR37 localhost:8080/note`

On success, the server will return the ID the newly created note can be
retrieved with. Let's assume this ID is `f9fe53fa-52e5-44ba-bb95-64a9bfd030e5`.

You can then retrieve the note with the following command line:

`curl --get -d id=f9fe53fa-52e5-44ba-bb95-64a9bfd030e5 -d password=S3CR37 localhost:8080/note`

## To Do

Error handling:

* responding with status code 400 (Bad Request) when omitting mandatory query
  params
* responding with status code 403 (Forbidden) when trying to retrieve a note
  using the wrong password

Delivery methods, e.g. the following:

* command line
* web (GUI)

Serializers, e.g. the following:

* SQL databases
* key-value stores

Separation of concerns:

* separate serialization gem
* separate delivery method gem or using this gem (and if split off serialization
  gem) in an existing delivery method, e.g., Sinatra or Rails

Parting words

I've written this in several short sessions over the weekend. I've definitely
taken more than three hours to finish, but not much more than five, I think. So
don't let the file creation times and timestamps on the commits confuse you.
Thanks.
