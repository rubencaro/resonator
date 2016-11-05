# resonator
[![Build Status](https://travis-ci.org/rubencaro/resonator.svg?branch=master)](https://travis-ci.org/rubencaro/resonator)
[![Hex Version](http://img.shields.io/hexpm/v/resonator.svg?style=flat)](https://hex.pm/packages/resonator)
[![Hex Version](http://img.shields.io/hexpm/dt/resonator.svg?style=flat)](https://hex.pm/packages/resonator)

External API's change resonator.

Application to simplify the job of polling an external API, and then execute some arbitrary code when any interesting change is detected.

All that is needed is the API endpoint, anything needed to access it, the function to detect changes, and the function to execute when a change is detected.

## Use

Just add `{:resonator, "0.1.0"}` to your deps on `mix.exs`, and then `:resonator` to your `applications` list to make sure it's started right before your app.

Then somewhere in your application configure the resonance like this:

```elixir

defmodule MyResonance do
  @behaviour Resonator.Resonance

  def change(_response) do
    # ... change detection logic
  end

  def fire(_response) do
    # ... response to change
  end

  def endpoint do
    # ... endpoint access logic
  end

  def error(_response) do
    # ... error handling logic
  end

  def options do
    # ... options definition
  end
end

Resonator.add(MyResonance)
```

## TODOs

* Plan everything
* Basic documentation

## Changelog

### master

* Initial development

### 0.1.0

* Placeholder release
