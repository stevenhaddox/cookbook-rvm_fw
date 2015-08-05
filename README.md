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
    <td><tt>'http://rvm-fw.herokuapp.com'</tt></td>
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
