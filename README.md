rvm_fw Cookbook
===============

This is a very opinionated and simple cookbook for utilizing an RVM::FW server instance and installing a default Ruby via RVM.

Requirements
------------

#### packages

- `build_essential` - RVM needs compiling tools to install ruby from source

Attributes
----------
* `['rvm_fw']['path'] = nil` (String) - Custom path for where to install RVM, overrides RVM default paths
* `['rvm_fw']['user'] = 'root'` (String) - User to install RVM as: root for system-wide, normal install otherwise
* `['rvm_fw']['url'] = nil` (String) - RVM::FW server URL (e.g., 'http://rvm-fw.herokuapp.com')
* `['rvm_fw']['version'] = '1.18.14'` (String) - RVM::FW provided RVM version
* `['rvm_fw']['global_ruby'] = 'ruby-2.2.2'` (String) - Default Ruby version to install via RVM
* `['rvm_fw']['disable_requiretty'] = false` [True, False] - Enable the cookbook to disable `requiretty` setting in the `/etc/sudoers` file

Usage
-----

#### rvm_fw::default

Include `rvm_fw` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rvm_fw]"
  ]
}
```

Notes
-----

#### Using RVM installed Ruby Binaries

RVM automatically generates wrappers for each ruby installed through it. These
wrapper binaries are perfect cronjobs, library dependencies, etc.

Binaries are found in the following location:

`#{node['rvm_fw']['path']}/wrappers/default`

And are available for the following commands:

* ruby
* gem
* rake
* irb
* rdoc
* ri
* erb
* testrb

#### RHEL Distros & `requiretty`

In older (and SELinux enabled) distributions based on RHEL you'll often encounter a setting in `/etc/sudoers` that sets `Defaults requiretty`. This setting doesn't provide a lot of added security and is actually disabled in most newer distros.

This cookbook will change the setting to `Defaults !requiretty` if you want it to. This will prevent an error encountered on nodes with it enabled, but you have to explicitly enable it with the following attribute setting:

`['rvm_fw']['disable_requiretty'] = true`

Once you've set that attribute value to `true` the cookbook will modify requiretty so that the cookbook won't error when running.

#### Testing Notes

Tests are currently integration tests with test-kitchen:

`bundle exec kitchen test`

In order to test this cookbook you'll need to point to or setup an RVM::FW instance and set the following environment variables:

* `RVM_FW_URL`: The RVM::FW server you will use to install RVM from
* `RVM_FW_USER`: The user to install RVM as (`root`, or `vagrant`) for example.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Add specs for your feature
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Authors: [Steven Haddox](https://github.com/stevenhaddox)
