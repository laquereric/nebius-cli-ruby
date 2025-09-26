'''# Nebius CLI Ruby Wrapper

[![Gem Version](https://badge.fury.io/rb/nebius-cli-ruby.svg)](https://badge.fury.io/rb/nebius-cli-ruby)

This gem provides a Ruby-friendly wrapper around the [Nebius CLI](https://docs.nebius.com/cli/), allowing you to interact with Nebius cloud services from your Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nebius-cli-ruby'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install nebius-cli-ruby
```

### Prerequisites

You must have the [Nebius CLI](https://docs.nebius.com/cli/install) installed and configured on your system.

## Usage

### Client Initialization

To get started, create a new `Nebius::Client` instance:

```ruby
require 'nebius'

# Initialize with default profile
client = Nebius.new

# Or specify a profile
client = Nebius.new(profile: 'my-nebius-profile')

# Enable debug mode for detailed output
client = Nebius.new(debug: true)
```

### Compute

Manage your compute resources like instances, disks, and images.

#### Instances

```ruby
# List all instances
instances = client.compute.instance.list

# Get a specific instance
instance = client.compute.instance.get(name: 'my-instance')

# Create a new instance
new_instance = client.compute.instance.create(
  name: 'my-new-instance',
  zone: 'eu-north1-a',
  machine_type: 'standard-2',
  image: 'ubuntu-22.04-lts'
)

# Stop an instance
client.compute.instance.stop(name: 'my-instance')

# Start an instance
client.compute.instance.start(name: 'my-instance')

# Delete an instance
client.compute.instance.delete(name: 'my-instance')
```

#### Disks

```ruby
# List all disks
disks = client.compute.disk.list

# Create a new disk
new_disk = client.compute.disk.create(
  name: 'my-new-disk',
  size: '10GB',
  type: 'network-ssd'
)
```

### Storage

Manage your object storage buckets.

```ruby
# List all buckets
buckets = client.storage.bucket.list

# Create a new bucket
new_bucket = client.storage.bucket.create(name: 'my-new-bucket')

# Delete a bucket
client.storage.bucket.delete(name: 'my-new-bucket')
```

### IAM (Identity and Access Management)

Manage users, service accounts, and roles.

```ruby
# List all users
users = client.iam.user.list

# List all service accounts
service_accounts = client.iam.service_account.list
```

### VPC (Virtual Private Cloud)

Manage your networks and subnets.

```ruby
# List all networks
networks = client.vpc.network.list

# Create a new network
new_network = client.vpc.network.create(name: 'my-new-network')
```

### Managed Kubernetes (MK8s)

Manage your Kubernetes clusters and node groups.

```ruby
# List all clusters
clusters = client.mk8s.cluster.list

# Get credentials for a cluster
kubeconfig = client.mk8s.cluster.get_credentials(name: 'my-cluster')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nebius/nebius-cli-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nebius/nebius-cli-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
'''
