# Foodtaster

Foodtaster is a library for testing your Chef code with RSpec. Specs
are actually executed on VirtualBox machine(s) managed by
[Vagrant](http://www.vagrantup.com/).

Foodtaster uses VM snapshots to bring something like DB transactions
into your cookbook specs. Before each Chef Run VM is rolled-back into
initial 'clean' state which removes any modifications made by
previously executed specs. It allows you to independently test different
cookbooks on a single VM.

Of course, you aren't limited by just one VM for your specs, you may
run as many as you need. PostgreSQL replication, load balancing and
even entire application environments becomes testable (of course, if
you have enought amount of RAM).

Foodtaster is on early development stage, so feedback is very
appreciated.

## Quick Example

```ruby
require 'spec_helper'

describe "nginx::default" do
  run_chef_on :vm0 do |c|
    c.json = {}
    c.add_recipe 'nginx'
  end

  it "should install nginx as a daemon" do
    vm0.should have_package 'nginx'
    vm0.should have_user('www-data').in_group('www-data')
    vm0.should listen_port(80)
    vm0.should open_page("http://localhost/")

    vm0.should have_file("/etc/init.d/nginx")
    vm0.should have_file("/etc/nginx/nginx.conf").with_content(/gzip on/)
  end

  it "should have valid nginx config" do
    result = vm0.execute("nginx -t")

    result.should be_successfull
    result.stdout.should include("/etc/nginx/nginx.conf syntax is ok")
  end
end
```

## Installation

First, install Vagrant for your system following [official
instructions](http://docs.vagrantup.com/v2/installation/index.html).
Then, install two plugins: `sahara` and `vagrant-foodtaster-server`:

    vagrant plugin install sahara
    vagrant plugin install vagrant-foodtaster-server

That's all, you are ready to go.

## Usage

In your Chef repository, create a basic Gemfile:

    source 'https://rubygems.org/'

    gem 'rspec'
    gem 'foodtaster'

Then, create a Vagrantfile describing VMs you need for specs. Here is
[example
Vagrantfile](http://raw.github.com/mlapshin/foodtaster-example/master/Vagrantfile).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request