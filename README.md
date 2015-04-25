**SupportUtils**
===================

SupportUtils is a collection of utility classes, helpers and standard library extensions that were found useful for develop projects, faster.

----------


**Installation**
------------



Add this line to your application's Gemfile:

```
gem 'support_utils'
```

And then execute:

```
bundle install
```

Or install it yourself as:

```
$ gem install support_utils
```
<div style="page-break-after: always;"></div>

##**Usage**

### Active Record Models

To have available all the extra methods and helpers in your models, simply just call the `has_utils` method inside your model. Example:

```
class Order < ActiveRecord::Base
  has_utils
  belongs_to :user
end

```

### List of methods added to your models

###  **`Model#column_name_format`**

This method behaves diferently depending on the type of the column in the database, here is the list behavior by type:

####  **`Model#column_name_format format, options`** - column type (Date, Datetime, etc)

When you call `Model#column_name_format` on a date column, it will use the `I18n.locale` and return the date formated.

List of arguments

* **format:** the format that is going to use to display the date. **Default value** **`:default`**.

Example using the completed_at attribute of the Order class.

```
order = Order.first

order.completed_at
=> Sat, 25 Apr 2015 18:29:40 UTC +00:00

# Default format

order.completed_at_format
 => "Sat, 25 Apr 2015 18:29:40 +0000"

# Short format

order.completed_at_format :short
  => "25 Apr 18:29"

```



####  **`Model#column_name_format  options`** - column type (Float, Decimal)


When you call `Model#column_name_format` on a decimal column, it will use some number helpers (such as `number_with_precision` and `number_to_currency`) to display the value.

List of options

* **currency:** if set to true it will call `number_to_currency` to display the value.

Example using the total attribute of the Order class.

```
order = Order.first

order.total.to_s
 => "29.15586957"

# Default

order.total_format
 => "29.16"

# Currency

order.total_format currency: true
 => "$29.16"

# Currency diferent unit

order.total_format currency: true, unit: "€"
 => "€29.16"


```

<div style="page-break-after: always;"></div>

####  **`Model#column_name_format  options`** - column type (String, Text)


When you call `Model#column_name_format` on a string column, it will use some text helpers (such as `simple_format` and `truncate`) to display the value. By default uses `simple_format`.

List of options

* **truncate:** Truncates a given text after a given :length if text is longer than :length (defaults to 30). The last characters will be replaced with the :omission (defaults to “…”) for a total length not exceeding :length.
* **word_wrap:** Wraps the text into lines no longer than line_width width. This method breaks on the first whitespace character that does not exceed line_width (which is 80 by default).
* **excerpt:** Extracts an excerpt from text that matches the first instance of phrase.


Example using the description attribute of the Order class.


```
order = Order.first

order.description
 => "Excepturi eum eius sed quia sint fuga veritatis. Nihil nisi omnis ullam voluptatem doloremque iure. Rerum eum recusandae est sit qui odio eum. Et laboriosam voluptas. Beatae qui voluptates velit est soluta. Fugiat ut omnis impedit voluptas alias."

# Default - simple_format

order.description_format
 => "<p>Excepturi eum eius sed quia sint fuga veritatis. Nihil nisi omnis ullam voluptatem doloremque iure. Rerum eum recusandae est sit qui odio eum. Et laboriosam voluptas. Beatae qui voluptates velit est soluta. Fugiat ut omnis impedit voluptas alias.</p>"


# truncate

order.description_format truncate: true
 => "Excepturi eum eius sed quia..."


 order.description_format truncate: {length: 10}
 => "Exceptu..."

# word_wrap

order.description_format word_wrap:  true
 => "Excepturi eum eius sed quia sint fuga veritatis. Nihil nisi omnis ullam\nvoluptatem doloremque iure. Rerum eum recusandae est sit qui odio eum. Et\nlaboriosam voluptas. Beatae qui voluptates velit est soluta. Fugiat ut omnis\nimpedit voluptas alias."


# highlight

order.description_format highlight: {phrases: "eum"}
 => "Excepturi <mark>eum</mark> eius sed quia sint fuga veritatis. Nihil nisi omnis ullam voluptatem doloremque iure. Rerum <mark>eum</mark> recusandae est sit qui odio <mark>eum</mark>. Et laboriosam voluptas. Beatae qui voluptates velit est soluta. Fugiat ut omnis impedit voluptas alias."


# excerpt

order.description_format excerpt:  {phrase: "fuga", radius: 10}
 => "...quia sint fuga veritatis..."


```

<div style="page-break-after: always;"></div>

###  **`Model#column_name?`**

If you create a column with integer as data type and with a length of 1, this method gets overwritten so it return true only if is equals to 1.


Example using the active attribute of the User class.


```
# migration

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string     :email
      t.string     :first_name
      t.string     :last_name
      t.integer    :active, limit: 1
      t.datetime   :confirmed_at
      t.timestamps null: false
    end
  end
end

```

```
user = User.first

user.active
=> nil

user.active?
 => false

user.active = 1
 => 1

user.active?
 => true

user.active = 0
 => 0

user.active?
 => false

```


###  **`Model.truncate(confirm)`**

Truncate the table reseting the primary key


```
Order.truncate! true
=> (30.0ms)  DELETE FROM orders
   (8.5ms)  DELETE FROM sqlite_sequence WHERE name='orders'

```

**Note:** since `sqlite` does't support the `truncate` statement it will delete the record and the sequence


---------
