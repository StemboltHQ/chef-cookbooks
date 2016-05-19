# Stembolt Chef Cookbooks

This is our collection of Chef cookbooks for deploying to Chef 12 on [Amazon
Opsworks][1].  Currently a work in progress.

## Testing Locally

We have a full "Kitchen" set up, which allows you to deploy the recipes to a VM
on your local machine to make sure nothing is broken.

### Prerequisites

There are a few things you'll need to have installed and functioning before
you'll be able to run the tests.

1. [Virtualbox][2]
2. [Vagrant][3]
3. [Chef DK][4]

### Running

Once you have the necessary software installed, you can then proceed to set up
and run the test suite:

```
$ kitchen converge
```

This should provision a couple VMs, and configure them using Chef.

[1]: https://aws.amazon.com/opsworks/
[2]: https://www.virtualbox.org/
[3]: https://www.vagrantup.com/
[4]: https://downloads.chef.io/chef-dk/
