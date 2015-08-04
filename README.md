rvm_fw Cookbook
===============
This is a very opinionated and simple RVM installation cookbook for utilizing an RVM::FW server instance.

Requirements
------------
#### packages
- `build_essential` - rvm_fw needs compiling tools to install ruby from source

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
    <td><tt>['rvm_fw']['prefix']</tt></td>
    <td>String</td>
    <td>prefix for where to install RVM</td>
    <td><tt>/usr/local/rvm</tt></td>
  </tr>
</table>

Usage
-----
#### rvm_fw::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `rvm_fw` in your node's `run_list`:

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
