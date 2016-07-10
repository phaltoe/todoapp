== README

This README would normally document whatever steps are necessary to get the
application up and running.

The Purpose of this project is showing to the user how to use:

1) Cross-Site Request Forgery;

2) Strong Parameters;

3) form_for | CREATE or UPDATE?

----------

Forms Part 1 - Cross-Site Request Forgery

In Rails you can build forms in a lot of different ways.  What does this mean?  It means that you can from a hard coded form to a very abstract one.

So, the lowest level would be some raw HTML, just like:

<form action="<%= songs_url %>" method="POST">

  <input type="text" name="song[name"]
  
  <input type="submit">

</form>

Now, when you hit submit you get: 

ActionController::InvalidAuthenticityToken

You may wonder why you get that.  Rails, by design has a protection against a Cross-Site Request Forgery. 

Ok.. what?

Let's quote google on this one: 

"Cross-Site Request Forgery (CSRF) is a type of attack that occurs when a malicious web site, email, blog, instant message, or program causes a user's web browser to perform an unwanted action on a trusted site for which the user is currently authenticated."

What's the work around for that?

If you are using raw HTML like in the first form example, you would need to have this line of code before your "Submit":

<input name="authenticity_token" type="hidden" value="token_value">

The authenticity_token Rails method prevents CSRF.

To make it simple to understand: 

when you use a method that can modify content(PUT/POST/DELETE) Rails, through authenticity_token method, makes sure that the request are being made from the client's browser. Not from a third party.

In fact, this is one of the reasons we want to avoid raw HTML in our Rails views. Whenever we let Rails generate the form for us(example below), that token is already present. We don't need to worry.

<%= form_tag(songs_path) do %>
  
  <%= text_field_tag 'song[name]' %>

  <%= submit_tag %>

<% end %> 

So if you inspect it, you can see that it's there:

<input name="authenticity_token" type="hidden" value="Hlg46F3uvymclxjRS8E33Y0wAU34qZJE3JhCTNaEUYmSPrjQHLT6cR7fvllapoXLHzbFSFanujFpq6eoHOOxwg==">

That way we can be sure that we are safe against CSRF.


-------------

Forms Part 2 - Strong Parameters 

What are Strong Parameters?

  We can call it a "Parameters Whitelist". Before an attribute gets passed into the Model, they have to be "permitted".  When you pass an attribute that is not explicitly permitted, it will throw a: 

  ActiveModel::ForbiddenAttributesError

Basically, what it does is check if the given parameter is in the allowed list, if it is, assigns it, otherwise, it throws an error.

class PostsController < ApplicationController
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:name, :content, :tag_ids => [])
  end
end

That way, you defined which attributes can be passed into the Model when you (Create/Update). 

So, your CREATE method would look like this:

  def create
    @post = Post.new(post_params)
    if @post.valid?
      @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end
  
Usually, you will want to permit the same attributes for both your CREATE and UPDATE actions.

But what happens if we, lets say, want to have control over which attributes can be used to create an object and which can be used to update?

We pass the attributes as arguments.

So, our "post_parameters" method would look like this:

private 

def post_params(*args)
  params.require(:post).permit(*args)
end

Our CREATE method would change to:

def create
  @post = Post.new(post_params(*args)) # !!! You would need to pass in symbols, not the *args splat
  if @post.valid?
    @post.save
    redirect_to post_path(@post)
  else
    render :new
  end
end

If you wanted to "whitelist" all attributes, you could magically do this:

def post_params
  params.require(:post).permit!
end

-------

Just to make sure, if you try to mass assign without using strong parameters, see what happens:

def create
  @post = Post.new(params)
  @post.save
  redirect_to post_path(@post)
end

ActiveModel::ForbiddenAttributesError in ListsController#create
ActiveModel::ForbiddenAttributesError

activemodel (4.2.6) lib/active_model/forbidden_attributes_protection.rb:21:in `sanitize_for_mass_assignment'


-----------

Forms Part 3 - Form For | CREATE or UPDATE?

How does Rails know if we are trying to create or update an object?

At this point, we are assuming that the convention form for form_for is the exactly the same for CREATE AND UPDATE. 

First, lets display a Post form:

  ...
  <%= form_for(@post) do |f| %>
    <%= f.text_field :name %>
  
    <%= f.submit %>
  <% end %> 
  ...

Question:  If both forms are the same then how does Rails knows if we are trying to create or update an object?

It will check a method called .persisted?

  If @post.persisted? returns true this means that it is not a new_record and already in the Database.

Rails knows that it is an EDIT form.

  If @post.persisted? returns false this means that it is a new_record and is not in the Database yet.

Rails knows that it is a CREATE form.

----

Another way of understanding it is to look at your Controller.
(Please bear in mind that this is not how Rails recognizes the pattern for CREATE or UPDATE but it will give you an idea)

  def update
    @post = Post.find(params[:id])
    @post.update(list_params)
    redirect_to post_path(@post.id)
  end

  def create
    @post = Post.new(post_params)

    if @post.valid?
      @post.save
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

Can you spot the difference between the two actions?  

When you try to UPDATE, you are reading retrieving data from your database:

  ...
  @post = Post.find(params[:id])
  ...

This is different from when you are trying to create a new instance, which means that you are explicitly trying to insert data in your database.

    ...
    @post = Post.new(post_params)

    if @post.valid?
      @post.save
      redirect_to post_path(@post.id)
    ...
    
You can try it by yourself using these methods:

.persisted?
.new_record?






