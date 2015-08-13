rvm_fw Cookbook
===============

This is a very opinionated and simple cookbook for utilizing an RVM::FW server instance and installing a default Ruby via RVM.

Requirements
------------

#### packages

- `build_essential` - RVM needs compiling tools to install ruby from source

Attributes
----------

#### rvm_fw::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['rvm_fw']['path']</tt></td>
    <td>String</td>
    <td>prefix for where to install RVM</td>
    <td><tt>'/usr/local/rvm'</tt></td>
  </tr>
  <tr>
    <td><tt>['rvm_fw']['sudo']</tt></td>
    <td>Boolean</td>
    <td>Use sudo to install RVM server-wide</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rvm_fw']['url']</tt></td>
    <td>String</td>
    <td>RVM::FW server URL (with protocol)</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['rvm_fw']['version']</tt></td>
    <td>String</td>
    <td>RVM::FW RVM installer version</td>
    <td><tt>'1.18.14'</tt></td>
  </tr>
  <tr>
    <td><tt>['rvm_fw']['global_ruby']</tt></td>
    <td>String</td>
    <td>Global ruby version to install via RVM</td>
    <td><tt>'ruby-2.2.2'</tt></td>
  </tr>
</table>

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

`#{node['rvm_fw']['path']/wrappers/default`

And are available for the following commands:

* ruby
* gem
* rake
* irb
* rdoc
* ri
* erb
* testrb

#### Testing Notes

In order to test this cookbook in its current form you'll need to setup your own RVM::FW instance and add the URL to the `['rvm_fw']['url']` attribute.

Tests are currently integration tests with test-kitchen:

`bundle exec kitchen test`

Kitchen tests are non-functional for debian platform systems. Not sure why yet. For now run the following:

```bash
bundle exec kitchen converge
```

You can verify that everything works as expected with the following:

```bash
bundle exec kitchen login <platform>
sudo su -
# Run the following to verify the cookbook works as expected
rvm --version
ruby --version
gem list bundler
```

#### Fedora (and possibly older RHEL distributions):

On Fedora (with test kitchen) you may need to negate `requiretty`:

```bash
$ visudo
# Change this line:
Defaults requiretty
# To this line:
Defaults !requiretty
```

If this occurs in your environment you'll need to configure your sudoers file prior to the rvm_fw cookbook running as it is outside the scope of this cookbook to make assumptions about your sudoers file.

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
